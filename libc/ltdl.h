#include "all.h"

typedef void *lt_dlhandle;

void *lt_dlsym();
lt_dlhandle lt_dlopen(const char *x);
void lt_dlclose();
void lt_dlinit(void);
void lt_dlexit();
