#ifndef __MEM_H__
#define __MEM_H__

#include <stddef.h>

#define PAGE_SIZE 4096
#define DEFAULT_MAX_REGIONS 4
#define DEFAULT_DESCRIPTORS_PER_BYTES 4096

enum
{
	BLOCK_FREE = 1,
	BLOCK_USED = 2,
	BLOCK_NOT_PRESENT = 3,
	BLOCK_POISON = 4
};

struct mem_block
{
	struct mem_block *next;
	size_t size;
	unsigned char type;
};

struct mem_region
{
	void *addr;
	size_t free_size;
	size_t size;
	struct mem_block *head;
	size_t max_blocks;
	struct mem_block *blocks;
};

// TODO: Do something when we run out of regions (make new regions)
struct mem_master
{
	struct mem_master *next;
	size_t max_regions;
	struct mem_region regions[DEFAULT_MAX_REGIONS];
};

int mem_init_master(struct mem_master *master);
struct mem_region *mem_new_region(struct mem_master *master, void *addr, size_t size);
struct mem_block *mem_new_block(struct mem_region *region);
void *mem_alloc(struct mem_master *master, size_t size);
void mem_free(struct mem_master *master, void *ptr);
void *mem_align_alloc(struct mem_master *master, size_t size, size_t align);
void *mem_realloc(struct mem_master *master, void *ptr, size_t size);
size_t mem_total_free(struct mem_master *master);

#endif
