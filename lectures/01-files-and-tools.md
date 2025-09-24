# File and tools
## Everything about files

### `stat` and `file`

The `stat` command displays detailed information about a file or directory.
```bash
stat myfile.txt
```
Obtaining:
```bash
  File: myfile.txt
  Size: 1024       Blocks: 8    IO Block: 4096  regular file
Device: 802h/2050d Inode: 1234567  Links: 1
Access: (0644/-rw-r--r--)  Uid: (1000/user)  Gid: (1000/user)
Access: 2025-09-20 12:00:00
Modify: 2025-09-19 18:30:00
Change: 2025-09-19 18:35:00

```

**Exercise**: use the `touch` command to modify a file’s access time (`atime`) and modification time (`mtime`), then run `stat` to observe the changes.

---

The `file` command identifies the type of a file by inspecting its content (not just the extension).  It is seful for detecting text vs binary files, scripts, executables, compressed archives, etc...
```bash
file myfile.txt
```

Results in:
```bash
myfile.txt: ASCII text
```

**Exercise**: test `file` on an executable file.
## Managing permission

Key concept:

1. Everything is a file (including directories, devices, processes).
2. Each file has permissions and an owner.
3. You can decide who can **read**, **write**, **execute**. (The term have different significatne if you are talking about a file or directory)
In this section the key command will be:
- `chown`
- `chmod`
###  File Ownership

Every file ownership could be described with 3 field:

- Owner (a user), usually indicated as **u**
- A group owner, **g**
- Others, **o**

Check with `ls -l` (or alternatively `stat`):

```bash
-rw-r--r-- 1 user01 group01 1024 Sep 20 file.txt
```

So `file.txt` is owned by `user01` (the user) and by `group01` (the group).

Use `chown` to change file owner and group:  `chown user02:group99 file.txt`
Result:
- `user02` is the new **owner**
- `group00` is the new group owner

### File permissions
3 possible type of permisison, different meaning on different context (i.e., folder vs file)

- **r (read)** 
    - File: view contents.
    - Directory: list files inside.
- **w (write)** 
    - File: modify/delete contents.
    - Directory: create, rename, or delete files inside.
- **x (execute)** 
    - File: run it as a program/script.
    - Directory: "enter" it (using `cd`) and access files within.

The output of `ls -l` to infer permissions is the following:

```bash
-rwxr-xr--  1 user group  1234 Sep 20 12:00 script.sh
drwxrwxr-x  2 user group  4096 Sep 20 11:50 myfolder
```

It is a series of 10 characters (depitct just `script.sh`):
* `-` or `d` it mean file or directory
* `rwx` user (owner) permissions
* `r-x` group permissions
* `r--` others permissions

Summarizing: with  `-rwxr-xr--`  is a file where owner can **read, write, execute**; group can **read, execute**; others can only **read**.

Change with `chmod`:

```bash
chmod u+x file.sh     # add execute for user
chmod g-w file.txt    # remove write from group
chmod o=r file.txt    # set others to read only
chmod a+rw folder     # everyone can read/write
```

### Exercise on permissions
Save the following script in a file called `setup_exercise.sh`, then run it `sudo setup_exercise.sh`. It require `root` privileges to run, since it will add a new user. 

```bash
#!/bin/bash
# setup.sh - run as root
# 1. Create a new user
useradd -m -s /bin/bash student01
# 2. Create a directory structure in the new user's home
mkdir -p /home/student01/projects
mkdir -p /home/student01/projects/src
touch /home/student01/projects/file1.txt
touch /home/student01/projects/src/file2.txt
# 3. Assign initial ownership incorrectly
chown root:root /home/student01/projects/file1.txt
chown root:root /home/student01/projects/src/file2.txt
chown root:root /home/student01/projects/src
# 4. Set restrictive permissions
chmod 600 /home/student01/projects/file1.txt
chmod 600 /home/student01/projects/src/file2.txt
chmod 600 /home/student01/projects/src/
chmod 600 /home/student01/projects/
echo "Setup complete. Log in as student01 to fix permissions."
```

This script will generate the following structure:
```bash
/home/student01/
└── projects
    ├── file1.txt
    └── src
        └── file2.txt
```

**Goal** be able as `student01` user to read `file1.txt`,`file2.txt`, access folders and do `ls`.

**Tasks**
* Login as `student01`, you can do `sudo su - student01`, this allow you to impersonate a new user.  Verify that using the command `id` and `whoami` . You should be `student01` and not the usual one.
* Try as `student01` to do `ls /home/student01/projects/src`, you should get an error.
* Open a **new terminal** and login as root: `sudo su`, then fix the permission in order to allow `student01` to acces its files.  In other words, `student01` should be able to do anything inside its home and `projects` folder.

### `rsync` to move files

`cp` is nice for small file transfer and every day docs, but with large amount of data, when metadata, file integrity, performance matter, `rsync` is a better solution.

```bash
rsync -av source/ destination/
```

Could show you what will happen with `--dry-run `  flag, could preserve metadata with `-a` and show what is happening with `-v`.

You could use it to keep synced 2 directory using `--delete ` (dangerous) and show the progress `--progress`.

**Exercise** try `rsync` to copy 2 folder.

## Terminal Multiplexer `tmux`

Suppose you have a script that runs indefinitely:

```shell
sleep 12345
```

How do you keep its output accessible even after closing the shell? Use `tmux`:

1. Create a new session: `tmux new -s session_name`
2. Run your script.
3. Detach from the session: `Ctrl+b d`
4. List active sessions: `tmux ls`
5. Reattach to the session: `tmux attach -t session_name`
### Bonus features:

- Split the screen: `Ctrl+b "` or `Ctrl+b %`
- Close a panel: `Ctrl+b x`
- Scroll within a pane: `Ctrl+b [`
- Move with `Ctrl+b <arrows>`

**Exercise** Open a termina, launch `tmux` , split it in 4 quadrants, then move around .

### Share Your Terminal with Friends

```bash
tmux -S /tmp/shared_session_socket
chmod 777 /tmp/shared_session_socket
tmux server-access -a friend_username
```

Your friend can then join with:

```bash
tmux -S /tmp/shared_session_socket
```
## Search for files and directories
If you need to search for a specific file/folder, or an object that match some metadata, `find` is the right tool:

* Find a specific object
```bash
find . -name "file.txt"
find . -iname "file.txt" #case insesitive version
```

**Tip**: it could be that during a find you end up in several `Permission denied`. That message could pollute your stdoutput, so you can filter errors using the following: `2>/dev/null`.

- Find only files or directories
```bash
find . -type d -name "backup"
find . -type f -name "*.log"
```
- Find files by size
```bash
find . -size +10M
find . -size -1k
```
- Find files by time
```bash
find . -mtime -7 # modified in last 7 days
find . -atime +7 # accessed more than 30 daya
```
Use `-exec` to run another command on found files.
```bash
find . -type f -name "*.tmp" -exec rm {} \;
find . -type f -name "*.sh" -exec ls -l {} \;
```
( `{}` is replaced with the filename, and `\;` ends the `-exec` command. )

---

## Download Files from the Internet

Two common tools for downloading files in the terminal are **`wget`** and **`curl`**.
### `wget`

`wget` is a simple utility to download files from a URL. It works well for single files or recursive downloads.

**Example**: Download a single file

```bash
wget https://example.com/file.zip
```

**Options**
- `-O <filename>`  save with a custom filename:

```bash
wget -O my_file.zip https://example.com/file.zip
```

- `-r -np -k` - Download a website recursively:
```bash
wget -r -np -k https://example.com/subpage/
```

---

### `curl`

`curl` is a versatile tool for transferring data with many protocols (HTTP, FTP, etc.). It is often used for scripts or APIs.

**Example: Download a file**

```bash
curl -O https://example.com/file.zip
```

(`-O` keeps the original filename; `-o <filename>` sets a custom one.)

**Other useful options**

- `-L` - Follow redirects: 

```bash
curl -L -O https://example.com/redirected_file.zip
```

---

## Processes

In Linux/Unix, a **process** is any running program. You can monitor and manage processes using `ps` and `kill`.

---

### `ps` – List processes

`ps` shows running processes. Useful options:

- `ps`  shows processes for the current shell.    
- `ps -e`  shows all processes.
- `ps aux`  detailed view of all processes with user, CPU, memory usage.    (**this is the most used**)

Example:

```bash
ps aux | grep firefox
```

This lists all processes and filters for `firefox`.

---

### `kill` – Stop a process

To stop a process, you need its **PID** (process ID, shown by `ps`).
- Sends the default `SIGTERM` signal (graceful stop).
```bash
kill <PID>
```


Force kill if the process doesn’t respond:
- Sends `SIGKILL` (immediate termination).
```bash
kill -9 <PID>
```

**Exercise**: open a terminal and launch a `sleep 12345` process, let it running. Then open a new terminal and kill it ! Hint: `ps aux` + `grep` will help you. 
