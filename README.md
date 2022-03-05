# lurker userland rootkit

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

# compile and run rootkit:
```
chmod u=rwx setup.sh
./setup.sh --export
```

# delete and unload rootkit:
```
chmod u=rwx setup.sh
./setup.sh --remove
```
