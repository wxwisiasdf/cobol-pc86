#include "all.h"

typedef void *lt_dlhandle;

void *lt_dlsym();
lt_dlhandle lt_dlopen(const char *x);
int lt_dlclose();
int lt_dlinit();
int lt_dlexit();
