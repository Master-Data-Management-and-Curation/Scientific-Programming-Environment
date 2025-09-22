
# Unix and shell tutorial

## 0 - Survival Kit

**Goal:** Learn to feel comfortable in front of a blank shell.

---

### Moving through the filesystem

* **`ls [-lhrt]`** - List files in different ways:

  * `-l`  long format (detailed info)
  * `-h`  human-readable sizes
  * `-r`  reverse order
  * `-t`  sort by modification time

* **`cd`** - **C**hange **D**irectory

  * Absolute path (full path starting with `/`):

    ```bash
    cd /home/student01/projects
    ```
  * Relative path (relative to current directory, can use `./`):

    ```bash
    cd ./subfolder
    ```
  * Go **up one level**:

    ```bash
    cd ..
    ```
  * Go to **previous directory**:

    ```bash
    cd -
    ```

* **`pwd`** - Print working directory

  * Shows **where you are** in the filesystem.

  ```bash
  pwd
  ```

**Exercise**: discover what `cd` (without any argument and flag) does.

---

### Hidden Files

* Files starting with `.` are **hidden**.
* To see them, use:

```bash
ls -a
```

* The special entries `.` (current directory) and `..` (parent directory) are also shown with `ls -l`.

### Create a folder

To create a new folder you will use `mkdir` command.
```bash
mkdir foldername
```

You can specify a path (relative/absolute)

```bash
mkdir /home/user001/newfolder
```

This require that `/home/user001` exists, you can use the flag `-p` that create for you the parent directories if necessary.


---

### Basic commands
This is a list of command that you need to know and master at the end of the module:

* `touch` - Create an empty file
* `cat` - Display file contents
* `echo` - Output text
* `less` - View file content page by page
* `head` - Show the beginning of a file
* `tail` - Show the end of a file
* `>` and `>>` - Redirect output to a file (overwrite or append)
* `|` - Pipe: take stdout of one command and pass it as stdin to another
* `grep` - Search inside files

### I don’t know ...

* `man <command>` - open manual page
* `<command> -h` or `--help` - quick help

---

## 1 - Basics

### Create an empty file

```bash
touch empty_file
ls -lh
```

Output:

```text
total 0
-rw-r--r-- 1 user user 0 Sep 19 21:14 empty_file
```

---

### `echo` and redirect

```bash
echo "This will go to stdout"
echo "This will go to a file" > not_empty
cat not_empty
ls -lh
```

**Append** vs **overwrite**:

```bash
echo "This text will be appended" >> not_empty
cat not_empty
echo "This will overwrite" > not_empty
```

**Note**: overwriting a file mean lost all its content, use it carefully ! 

**Exercise:** Given 2 files `A.txt`, `B.txt`, merge them into `C.txt`, possibly use a one-line command.
(Hint: `cat` accepts multiple input files.)

---

### `cat` is not enough

*Requirement:* Execute this command (a "one-liner"):

```bash
for i in {1..1000000}; do echo "line $i"; done > long_file.txt
```

Discover that `cat` is impractical for long files. Use `wc`:

```bash
wc -l long_file.txt
cat long_file.txt
```

**Note**: sometimes it is impractical also for binaries files (not ascii), the output could be terrible and broke (temporarly) your console:

```bash
cat /usr/bin/less
```

Possible output:

```bash
�]                                �e�D.kk5����Xׯ8v�i8	�8@�8Z�p[
  V<"TЊ<;ْPk�'h@:=�l	�dd��)�D��
                                  �Kp�*o�]a��
                                             /�
                                               �d�"y\CSV=9���vQi���!q$Uv�Eڰh{E�6q�vG��Ëe�Swύ�o?۹`c�
                             _��
                                x�k�<�ř7�YĽQNC��
                                                NtЩ�VT�R�HGA0�?�3���Ra%��HjbG��teA�JlJ'3�ܤ8�?3
                        H�~{17.�V݁Z�=�Z%?���4`G-c�ٕpBP5fr]�
                                                         �%<2WpʪVr
                                                                  췔�N�p2ҺI!Z;Fh{94{j&G?ߵ�Wgp);�my1�{�PH.cRa<O�q~�N�n.�y9QB��/��7ҏ�[�Gy�[�ǨK�T�\s0	��J�<
``` 

The right tool to do that is `hexdump`

---

### Display the Beginning and End

```bash
head long_file.txt
head -n 3 long_file.txt
tail long_file.txt
tail -n 5 long_file.txt
```

**Exercise:** Try both `head` and `tail` on the same file.

---

### `less`

Use `less` to navigate a file:

```bash
less long_file.txt
```

* Search inside: `/searchterm`
* Next result: `n`
* Previous result: `Shift+n`
* Quit: `q`

**Exercise:** Search for line `12345`.

---


### Pipes & Filters

1. A **pipe (`|`)** takes the **output of one command** (*stdout*) and feeds it as **input to another command** (*stdin*).

2. Filters are commands that **process input** in some way, such as sorting, counting, or searching. 

The idea is to combine more than one filter (command) to manipulate output !

---
* **Combine pipe and**`less`

```bash
cat long_file.txt | less
```

---

* **List the 5 largest files in `/var/log`**

```bash
ls -lh /var/log | sort -k5 -h | tail -n 5
```


* `ls -lh /var/log`  list files in long format (`-l`), human-readable sizes (`-h`).
* `sort -k5 -h`  sort by **5th column** (file size) numerically/human-readable 
* `tail -n 5`  show **last 5 entries** (largest files after sort)

**Exercise** Modify the one-liner above to show the 5 smallest file in /var/log. Solve the exercise in **two** different way. Read `man sort`. 

---

* **Check disk usage of files in current directory**

```bash
du -sh * | sort -h
```

* `du -sh *`  show disk usage of all items, summarized and human-readable
* `sort -h`  sort by **size** in human-readable format


---

### Search with `grep`

```bash
grep "12345" long_file.txt
grep -A2 -B2 -C2 "12345" long_file.txt
```

**Exercise:**

* Search for line `12345` using `grep`.
* Use `man grep` to discover what `-A`, `-B`, and `-C` do.
*  Combine `grep` with `|` to search inside `very_long_file` and save results to a file.

Grep could be used as *i)* filter, *ii)* to search inside a file and *iii)* to search a pattern inside in several files (not a specific one).

```bash
grep -irnw "enum"
```
 
- **`-i`**  case-insensitive search    
- **`-r`**  recursive:  search through all files in the current directory and subdirectories.
- **`-n`**  show line numbers where the match occurs.
- **`-w`**  match whole words only (so it matches `enum` as a standalone word, but not `enumeration` or `denum`).

A possible output could be:

```c
src/sview/sview.h:83:enum { JOB_PAGE,
src/sview/sview.h:95:enum { TAB_CLICKED,
src/sview/sview.h:102:enum { ERROR_VIEW,
src/sview/sview.h:106:enum { STATUS_ADMIN_MODE,
src/sview/sview.h:111:enum { DISPLAY_NAME,
src/sview/sview.h:116:enum { EDIT_NONE,
```

---

## 2. Introduction to scripting

First see how we can write down files.
### No text editor

If you are very brave you don't need a text editor, you can use just `cat` , `>` and `<< EOF`.

```
cat > fancy_file << EOT
hi
this is a very strange way to edit a file
EOT

```

1. Normally, cat without arguments just *echoes* what you type back.
2. `> my_file` edirects output to a file.
3. `<< EOF` It tells the shell: “take everything I type until the word EOT appears on its own line, and feed it to the command as input”.

And finally the shell collects the lines between << EOT and the closing EOT. Those lines become stdin for cat. Because of > fancy_file, cat writes them into the file.

### Text Editor

Since the previous mode is not so practical, let's use more modern text editor. 
We’ll use **nano**. If you know other editors, feel free to use them.
Basics command (*nano101*):
* Save: `Ctrl+o`
* Exit: `Ctrl+x`

Some alternatives are:
* `vim`: A more complex, modal editor. To exit, press `Esc` and type `:q!`. Use - `vimtutor` for a guided tutorial.
* `emacs`: Powerful editor. Start the tutorial with `Ctrl+h t`. To quit, press `Ctrl+x Ctrl+c`. For fun, try starting a game of Tetris with `Alt+x` tetris.

---

### First script

```bash
touch first.sh
nano first.sh
```

Inside `nano` or your favourite editor:

```bash
#!/bin/bash
# This is a comment — lines starting with # are ignored by the shell.

echo "Hello world!"
```

---

### Run with an interpreter

```bash
bash first.sh
sh first.sh
```

* Here, the shebang is ignored: you explicitly chose the interpreter.

---

### Run by making it executable

```bash
chmod +x first.sh
./first.sh
```

* Here, the shebang matters: system uses it to select interpreter.
* Running `first.sh` without `./` will fail unless `.` is in `$PATH` (we'll see later the meaning of $PATH).

---

### The Shebang (`#!`)

* `#!/bin/bash` mean Bash shell
* `#!/bin/sh` mean POSIX shell 
* Interpreter you call manually **overrides** the shebang.

**Exercise:**
* Check with `ls -l` if script is executable.
* Remove executability: `chmod -x first.sh` and try to run it.
* Verify which shell you are actually running, inspect the variable `$SHELL` in your current instance. (not always trustable).

---

## 3. User environment

### `execute` vs `source`

There are 2 ways to run a script: execute or source it.

Let's play with this script, save it as `test.sh`:

```bash
# test.sh
VAR=hello
echo "Inside script: $VAR"
```

### Executing

The script will run on a new shell, (say sub-shell, a child process). Any variables defined inside the script does not affect the current shell.

```bash
./test.sh
echo $VAR   # nothing shows, VAR is lost
```

### Sourcing

Runs in your current shell session.

Any changes (variables, functions, aliases) stay after it runs.
Example:

```bash
source test.sh
echo $VAR   # prints hello
```


## `.bashrc`

When you open a Bash shell (common in Linux or macOS), the shell reads configuration files that tell it how to behave.

One of the most widely used is `~/.bashrc` (the “rc” stands for **run commands**).

This file is a script that runs automatically whenever you start an **interactive shell** (like opening a terminal window), but **not** when running a script directly.

**Exercise:** Customize your `.bashrc` file to display a greeting message each time you open a new shell using the `cowsay` command. For example:

```bash
cowsay "Welcome to your shell!"
```
**Important**: any change to the `.bashrc` file will not affect the current instance of your shell since it is executed during its initialization. To see the effect you must open a new shell or source the file again (**not execute**).

*Note:* Different shells (like `zsh`) use different configuration files (`~/.zshrc` for Zsh).

---

### Alias

The `.bashrc` file is the perfect place to define **aliases** — shortcuts for longer commands.

For example, instead of typing a long `ls` command each time, you can create an alias:

```bash
# Define a shortcut for a detailed, human-readable listing
alias myls='ls -lrtah'

# Remove the alias if you no longer want it
unalias myls
```

Now, whenever you type `myls`, it will run `ls -lrtah`.

---

```bash
alias please='sudo $(fc -ln -1)'
```
How it works:
-  `fc -ln -1`  gets the last command you typed
- `sudo $(...)` re-runs that command with superuser privileges.


**Exercise**: try to run `apt update`/`dnf update` without sudo, and you should get an error. Then set the alias `please`, and then type please to just repeat the command without the need to retype it.

---

## Environment

Interactive shells are characterized by variable, they can be local or global (**environmental**). Global variables are inherited by child processes.

**Note**: environmental variables affect many many applications behavior and bash shell.

Let's use this script to explore differences between local and global variables.

Save the following `test.sh`:

```bash
#!/bin/bash

echo "MYVAR=$MYVAR"
```

### Variables

In a interactive shell they can be set as follow:

```bash
MYVAR="this is a local var"
echo $MYVAR
```

Then if we run `./test.sh` we will see that `MYVAR` is empty.

They are not inherited by child processes. If you want to pass a variable to a child process you can prepend it as follow: ` MYVAR="Testvar" bash test.sh`.

### Environmental variables

If you use the command `exprot` you will set environmental variables, that will be inherited by child processes:

```bash
export MYVAR="This will be seen by child"
bash test.sh
```

Usually many enviromental variable are already defined, you can inspect them using `env` command. To unset a variable you could just `unset MYVAR`.

Most important enviromental variables:
- `PATH`
- `HOME`
- `USER`
- `SHELL`
- `PWD` and `OLDPWD`
- `EDITOR`
- `PS1`

Usually messing up with this varialbe could lead to broken interactive shell. It is not permanent, unless messing with them in your `.bashrc`.

**Exercise** : 
- try to break your interactive shell by corrupting PATH (not in the `.bashrch`)
- try to personalize your shell using `PS1`variable


