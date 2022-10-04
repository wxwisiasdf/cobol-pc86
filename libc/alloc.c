/* SOF allocator - this allocator, designed by me :D . Uses a slab for small
 * objects. Supports RAM holes and RAM hotplug.
 *
 * Allocation is done from end to start. This is because software will always
 * hit the free block. Making allocation be O(1) for most of the time.
 *
 * The heap is "infinite" in the sense that we really never expand it. Since
 * the free block always is the fist block; the heap *will* take space
 * from the free block. This reduces complexity by a fuckton. */

// TODO: Add poison
// TODO: We can run out of region space; We need a way to allocate extra master blocks.
// TODO: We need to also consider that RAM hotswap is a thing; so we need to copy master blocks.
// TODO: We need to make copies of the master RAM block; because RAM hotswap exists

#include <stdint.h>
#include <stdlib.h>
#include "alloc.h"

int mem_init_master(struct mem_master *master)
{
	master->next = NULL;
	master->max_regions = DEFAULT_MAX_REGIONS;
	for (size_t i = 0; i < master->max_regions; i++)
	{
		master->regions[i].addr = NULL;
		master->regions[i].free_size = 0;
		master->regions[i].size = 0;
		master->regions[i].head = NULL;
		master->regions[i].max_blocks = 0; /* Default for new blocks */
		master->regions[i].blocks = NULL;
	}
	return 0;
}

struct mem_region *mem_new_region(struct mem_master *master, void *addr, size_t size)
{
	struct mem_region *region = NULL;
	/* Record new region onto the master heap */
	for (size_t i = 0; i < master->max_regions; i++)
	{
		region = &master->regions[i];
		if (region->addr == NULL)
			break;
	}

	if (region == NULL)
		return NULL;

	/* Fill out info of region */
	region->addr = addr;
	region->free_size = size;
	region->size = size;
	region->blocks = addr;
	region->head = addr;
	region->max_blocks = size / DEFAULT_DESCRIPTORS_PER_BYTES;
	if (region->max_blocks < 8192)
		region->max_blocks = 8192;

	/* Fill heap correctly */
	for (size_t i = 0; i < region->max_blocks; i++)
	{
		struct mem_block *tmp = &region->blocks[i];
		tmp->type = BLOCK_NOT_PRESENT;
	}

	/* Create the genesis block - this block is used for ram */
	struct mem_block *block;
	block = &region->blocks[0];
	block->next = NULL;
	block->type = BLOCK_FREE;

	/* New genesis block = less free memory on region */
	region->free_size -= sizeof(struct mem_block) * region->max_blocks;
	region->blocks[0].size = region->free_size;
	return region;
}

struct mem_block *mem_new_block(struct mem_region *region)
{
	/* Iterate through the blocks on heap, not all blocks are used
	 * and some are just there to be took over by newer blocks */
	for (size_t i = 0; i < region->max_blocks; i++)
	{
		struct mem_block *block = &region->blocks[i];
		if (block->type == BLOCK_NOT_PRESENT)
			return block;
	}

	// TODO: We could just expand the heap to avoid less errors.
	printf("No free blcks found\n");
	return NULL;
}

/** Fixes a block by merging next blocks into it (incase this block is a free block) */
static void mem_fix_block(struct mem_block *block)
{
	if (block->next != NULL && block->type == BLOCK_FREE && block->next->type == BLOCK_FREE)
	{
		block->size += block->next->size;
		block->next->type = BLOCK_NOT_PRESENT;
		block->next = block->next->next;
	}
	return;
}

/** Allocate memory of specified size */
void *mem_alloc(struct mem_master *master, size_t size)
{
	for (size_t i = 0; i < master->max_regions; i++)
	{
		struct mem_region *region = &master->regions[i];
		struct mem_block *block = region->head;
		void *ptr = region->addr;
		if (region->addr == NULL || region->free_size < size)
			continue;
		while (block != NULL)
		{
			struct mem_block *newblock;
			mem_fix_block(block);

			if (block->type != BLOCK_FREE && !(block->size >= size))
			{
				ptr += block->size;
				block = block->next;
				continue;
			}

			if ((newblock = mem_new_block(region)) == NULL)
				return NULL;

			newblock->type = BLOCK_USED;

			/* Parenting - VERY IMPORTANT! */
			newblock->next = block->next;
			block->next = newblock;

			newblock->size = size;
			block->size -= size;
			region->free_size -= size;

			ptr += block->size;
			return ptr;
		}
	}
	return NULL;
}

/** Free previously allocated memory */
void mem_free(struct mem_master *master, void *ptr)
{
	for (size_t i = 0; i < master->max_regions; i++)
	{
		struct mem_block *block, *prev;
		struct mem_region *region;
		void *bptr;

		region = &master->regions[i];
		bptr = region->addr;

		/* While we recurse we will also take the opportunity to
		 * merge free blocks */
		block = region->head;
		prev = NULL;
		while (block != NULL)
		{
			mem_fix_block(block);

			if (block->type == BLOCK_USED && bptr >= ptr && ptr <= bptr + block->size)
			{
				if (prev != NULL && prev->type == BLOCK_FREE)
				{
					prev->next = block->next;
					prev->size += block->size;
					block->type = BLOCK_NOT_PRESENT;
				}
				else
				{
					block->type = BLOCK_FREE;
				}
				return;
			}

			bptr += block->size;

			prev = block;
			block = block->next;
		}
	}
	return;
}

/** Allocate memory with align constraint */
void *mem_align_alloc(struct mem_master *master, size_t size, size_t align)
{
	for (size_t i = 0; i < master->max_regions; i++)
	{
		struct mem_region *region;
		struct mem_block *block;
		void *bptr;

		region = &master->regions[i];
		if (region->addr == NULL || region->free_size < size)
			continue;
		bptr = region->addr;
		block = region->head;
		while (block != NULL)
		{
			uintptr_t pbptr = (uintptr_t)bptr;
			if (block->type == BLOCK_FREE && block->size >= size + ((uintptr_t)pbptr % align))
			{
				uintptr_t target;
				uintptr_t offset;

				/* Perfect match! (very unlikely) */
				if (!(uintptr_t)pbptr % align)
				{
					/* If size is bigger split block into free and used parts */
					if (block->size >= align)
					{
						/* New block AFTER this used block */

						// TODO: Make block be BEFORE this used block (for speed reasons)
						struct mem_block *newblock;
						newblock = mem_new_block(region);
						if (newblock == NULL)
							return NULL;

						block->type = BLOCK_USED;
						newblock->next = block->next;
						block->next = newblock;

						newblock->size = block->size - size;
						block->size = size;
						return bptr;
					}
					/* Astronomically impossible: the perfectest match, aligned and
					 * with same size */
					else if (block->size == size)
					{
						block->type = BLOCK_USED;
						return bptr;
					}
				}
				/* Block sufficiently big */
				else
				{
					target = pbptr + block->size;
					target -= align;
					target -= target % align;

					uintptr_t off = target - pbptr;

					/* First check if we should make  afree part AFTER this block (a free part) */
					if (off + size > block->size)
					{
						struct mem_block *afterblock;
						afterblock = mem_new_block(region);
						if (afterblock == NULL)
							return NULL;
						afterblock->size = block->size - (off + size);
						afterblock->type = BLOCK_FREE;

						afterblock->next = block->next;
						block->next = afterblock;
						block->size -= afterblock->size;
					}

					// TODO: Assert off != 0

					/* Make block BEFORE this block (also a free part) */
					struct mem_block *usedblock;
					usedblock = mem_new_block(region);
					if (usedblock == NULL)
						return NULL;
					block->size = off;
					usedblock->size = size;
					usedblock->type = BLOCK_USED;

					usedblock->next = block->next;
					block->next = usedblock;

					// TODO: Implement after eating pizza
					return (void *)(pbptr + block->size);
				}
			}
			bptr += block->size;
		}
	}
	return NULL;
}

/** Reallocate previously allocated memory */
void *mem_realloc(struct mem_master *master, void *ptr, size_t size)
{
	void *bptr;
	for (size_t i = 0; i < master->max_regions; i++)
	{
		struct mem_region *region;
		struct mem_block *block, *prev;

		region = &master->regions[i];
		if (region->addr == NULL || region->free_size < size)
			continue;
		bptr = region->addr;
		block = region->head;
		prev = NULL;
		while (block != NULL)
		{
			mem_fix_block(block);

			/* Find block - if possible take space from next free block.
			 * Otherwise do a allocation and then free. */
			if (block->type == BLOCK_USED && bptr >= ptr && ptr <= bptr + block->size)
			{
				size_t diff;

				diff = size - block->size;

				/* Expand */
				if ((ssize_t)diff > 0)
				{
					/* Take size from next block */
					if (block->next != NULL && block->next->type == BLOCK_FREE && block->next->size >= diff)
					{
						block->size += diff;
						block->next->size -= diff;
						region->free_size -= diff;
						return bptr;
					}
					/* Take size from previous block */
					else if (prev != NULL && prev->type == BLOCK_FREE && prev->size >= diff)
					{
						block->size += diff;
						prev->size -= diff;
						region->free_size -= diff;
						return bptr - diff;
					}
					/* If the method above fails; we will do a malloc and then
					 * free the old block */
					else
					{
						void *new_ptr;
						new_ptr = mem_alloc(master, size);
						if (new_ptr == NULL)
							return NULL;

						memcpy(new_ptr, ptr, block->size);
						mem_free(master, ptr);
						return new_ptr;
					}
				}
				/* Shrink */
				else if ((ssize_t)diff < 0)
				{
					diff = -diff;

					/* Give size to block before */
					if (prev != NULL && prev->type == BLOCK_FREE)
					{
						prev->size += diff;
						block->size -= diff;
						region->free_size += diff;
						return bptr + diff;
					}
					/* Give size to block after */
					else if (block->next != NULL && block->next->type == BLOCK_FREE)
					{
						block->next->size += diff;
						block->size -= diff;
						region->free_size += diff;
						return bptr;
					}
					/* Create (split) block with remainder size. We will put it after
					 * the block for simplicity */
					// TODO: We must do it BEFORE block; because that reduces fragmentation
					// remember that all free blocks are guaranteed to be at the left
					else
					{
						struct mem_block *new_block;

						new_block = mem_new_block(region);
						if (new_block == NULL)
							return NULL;

						new_block->type = BLOCK_FREE;
						new_block->size = diff;
						block->size -= diff;
						region->free_size += diff;
						return bptr;
					}
				}
				/* No change - no reallocation :D */
				else
				{
					return bptr;
				}
			}

			bptr += block->size;
			prev = block;
			block = block->next;
		}
	}

	/* This only happens when */
	bptr = mem_alloc(master, size);
	return NULL;
}

size_t mem_total_free(struct mem_master *master)
{
	size_t total_free = 0;
	for (size_t i = 0; i < master->max_regions; i++)
	{
		struct mem_region *region = &master->regions[i];
		struct mem_block *block = region->head;
		if (region->addr == NULL)
			continue;
		
		while (block != NULL)
		{
			if (block->type == BLOCK_FREE)
				total_free += block->size;
			block = block->next;
		}
	}
	return total_free;
}

void mem_print(struct mem_master *master)
{
	printf("master has max. %zu regions\n", master->max_regions);
	for (size_t i = 0; i < master->max_regions; i++)
	{
		struct mem_region *region = &master->regions[i];
		struct mem_block *block;
		if (region->addr == NULL)
			continue;

		printf("ram#%zu: %zu\n", i, region->size);
		printf("maxblocks: %zu\n", region->max_blocks);
		printf("free: %zu\n", region->free_size);
		printf("total size: %zu\n", region->size);

		block = region->head;
		while (block != NULL)
		{
			printf("%s %zu\n", (block->type == BLOCK_FREE) ? "FREE" : "USED", block->size);
			block = block->next;
		}
	}
	return;
}
