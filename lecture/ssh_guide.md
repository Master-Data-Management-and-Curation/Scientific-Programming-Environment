# SSH

Today we will connect to ORFEO cluster using `ssh` protocol.

## Generate a key

To generate a key:

```
$ ssh-keygen -t rsa -b 4096 -C 'your_email@example.com'
```

This command will generate a pair of RSA keys, asking you where to save them. The private key will not have any extension, and the default name should be `id_rsa`. The public key should have the same name with a .pub suffix. E.G.: `id_rsa.pub`.

You can inspect the `~/.ssh` folder a see the keys that you have generated. 

## Connect to ORFEO cluster

```
$ ssh username@195.14.102.215 
```

By default ssh will search and try the keys present in `~/.ssh` , but you can specify the key that you want to use to connect:

```
$ ssh -i my_custom_key username@195.14.102.215
```

**Exercise**: Copy you key to a random location and change its name, then use it to connet to ORFEO.


## Add a new public key to login in ORFEO

If you need to regenerate a pair of keys, login into orfeo and and enable your new public key.

Go to `~./ssh` and add on a new line you public key to the file `authorized_keys`.

## Transfer file

Thanks to the ssh protocol, you can transfer files between you local machine and a remote machine.

You can copy a file to ORFEO cluster typing:

```
$ touch file_to_copy
$ scp file_to_copy username@195.14.192.215:~
```

**Exercise**: Try to copy a file and login to verify the succesfull copy of the file, then do the reverse. Copy a file from the cluster to you local machine. Repeat the exercise with a folder.


## Configure ssh

Since typing every time the username, the `ip` address and eventually the private key path is a long and annoyng task, you can save some time creating a configure file as follow:

p```
$ cat ~./ssh/config
AddKeysToAgent=true
host *
  SetEnv TERM=xterm
host orfeo
 Hostname 195.14.102.215
 User your_username
 IdentityFile path_to_you_private_key
```

And the you can login into ORFEO just typing:

```
$ ssh orfeo
```

**Exercise**: Configure you ssh in order to use the syntax above to login.

## Port-Forwarding

If you are running a service on a remote machine and you are required to connect to it (a jupyter lab, a simple web server and so on), you can forward a specific port on the a remote machine to a local port in your machine, exploiting the last one to login to a your server.

On the remote machine:

```
$ git clone 
$ cd codes/04-forwarding
$ python3 -m http.
```

On you local machine

```
$ ssh -L 8000:127.0.0.1:8000 orfeo
```

Now if you open a browser, you must be able to go at the url `http://127.0.0.1:8000/`.

## Jump-Box

Our cluster has several compute nodes, they can be accessible only from the login node, since the live in a private network. You can login on them via login node, but not from you local machine. If you need to login in a compute node behind the login node, you can usethe login node as jump boh using the flag -J.

```
$ ssh ntosato@10.128.2.171 -J epyc
```

Repeat the exercise, without using the jump box. 


