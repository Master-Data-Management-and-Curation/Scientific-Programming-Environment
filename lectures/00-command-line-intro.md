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

*hint*: to discover the absolute path, you can use the command `realpath`.

**Exercise 1**: discover what `cd` without any argument and flag does.

---

### Hidden Files

* Files starting with `.` are **hidden**.
* To see them, use:

```bash
ls -a
```

* The special entries `.` (current directory) and `..` (parent directory) are also shown with `ls -la`.

**Exercise 2**: Inspect the hidden folder and files in your home folder.
**Exercise 3**: Login to orfeo (`ssh <your_username>@195.14.102.215`), then go to `/orfeo/cephfs/scratch/area/ntosato/exercises/exercise3` and search for `secret_hidden_file.txt`.

## Handling files - Copy / Move / Delete

#### Copy

Files:

```bash
cp source.txt destination.txt
```

Copy a files into a folder:

```bash
cp source.txt ~/Documents/
```

Copy a whole directory:

```bash
cp -r project/ backup_project/
```

#### Move

Move a file to another folder:

```bash
mv notes.txt ~/Documents/
```

Rename a file:
```bash
mv oldname.txt newname.txt
```

Move a directory:

```bash
mv project/ ~/ProjectsArchive/
```
**Warning**: `mv` and `cp` could be dangerous, it is a very nice tool to destroy files. Look at the following example.

```bash
$ ls -l
total 0
-rw-r--r-- 1 ntosato ntosato 0 Sep 18 12:04 a.txt
-rw-r--r-- 1 ntosato ntosato 0 Sep 18 12:05 b.txt
$ mv a.txt b.txt
$ ls -l
total 0
-rw-r--r-- 1 ntosato ntosato 0 Sep 18 12:04 b.txt
```

You can use `-i` to have a confirmation before making mistakes.

```bash
$ cp file1.txt file2.txt -i
cp: overwrite 'file2.txt'?
```

#### Create a folder

To create a new folder you will use `mkdir` command.
```bash
mkdir foldername
```

You can specify a path (relative/absolute)

```bash
mkdir /home/user001/newfolder
```

This require that `/home/user001` exists, you can use the flag `-p` that create for you the parent directories if necessary.

#### Delete

**Note** there are no recycle bin, once deleted file are gone (unless particular cases).

A single file:
```bash
rm file.txt

```

Multiple files
```bash
rm file1.txt file2.txt

```
Using a wildcard:

```bash
rm *.log

```

A folder:
```bash
rm -r old_project/
```

### Tip

If you are unsure about what you are doing or you deal with very important data, use the flag `-i`.

```bash
rm -i file.txt   # asks before deleting
```

---

## 1 - Basics

This is a list of commands that you need to know and master at the end of the module:

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

**Exercise 5** Create the following structure:
```bash
exercise
├── folder1
│   └── file1
└── folder2
    └── file2
```
Do that in your home, **never** move from your home! `file1` and `file2` are empty files.
Verify the result with `tree exercise`, the output should match the one above.

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

**Note**: overwriting a file means losing all its content, use it carefully !

**Exercise 6:** Given 2 files `A.txt`, `B.txt`, merge them into `C.txt`, possibly using a one-line command.
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

**Note**: sometimes it is impractical also for binary files (not ascii), the output could be terrible and could temporarily break your console:

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

The right tool to do that is `hexdump`:

```bash
hexdump -C /usr/bin/less
```

---

### Display the Beginning and End

```bash
head long_file.txt
head -n 3 long_file.txt
tail long_file.txt
tail -n 5 long_file.txt
```

**Exercise 7:** The previous command broke (or will break) your console. Repeat it *safely*:
* Run `head -c 1004 /usr/bin/less | cat` — the output looks like garbage, but the terminal is still fine because we only dumped 100 bytes.
* Run `head -c 1004 /usr/bin/less | hexdump -C` and see how the same bytes are displayed in hexadecimal.
* Check that your shell still works: `echo "I am alive"`.

**Exercise 8**: Try both `head` and `tail` on the same file.

---

### `less`

Use `less` to navigate a file:

```bash
less long_file.txt
```

* Search inside: `/<searchterm>`
* Next result: `n`
* Previous result: `Shift+n`
* Quit: `q`

**Exercise 9:** Search for line `12345` using `less`.

---


### Pipes & Filters

1. A **pipe (`|`)** takes the **output of one command** (*stdout*) and feeds it as **input to another command** (*stdin*).

2. Filters are _commands_ that **process input** in some way, such as sorting, counting, or searching.

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

**Exercise 10** Modify the one-liner above to show the **5 smallest** files in `/var/log`. Solve the exercise in **two** different ways. Read `man sort` for hints.

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
grep -A2 -B2 "12345" long_file.txt
```

**Exercise 11:**

* Search for line `12345` in `long_file.txt` using `grep`.
* Use `man grep` to discover what `-A`, `-B`, and `-C` do, then show 2 lines *before* and *after* the match.
* Combine `grep` with `|` to search inside `long_file.txt` and save the results to a file called `matches.txt`.

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

If you are very brave you don't need a text editor, you can use just `cat`, `>` and `<< EOF`.

```
cat > fancy_file << EOF
hi
this is a very strange way to edit a file
EOT

```

1. Normally, cat without arguments just *echoes* what you type back.
2. `> my_file` redirects output to a file.
3. `<< EOF` It tells the shell: “take everything I type until the word EOF appears on its own line, and feed it to the command as input”.

And finally the shell collects the lines between << EOF and the closing EOF. Those lines become stdin for `cat`. Because of `> fancy_file`, `cat` writes them into the file.

### Text Editor

Since the previous mode is not so practical, let's use more *modern* text editor.
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

**Exercise 12:**
* Check with `ls -l` if script is executable.
* Remove executability: `chmod -x first.sh` and try to run it, check again with `ls -l`.


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

When you open a Bash shell, the shell reads configuration files that tell it how to behave.

One of the most widely used is `~/.bashrc` (the “rc” stands for **run commands**), that is more a script rather than a confiuration file. It is an hidden file placed in your home.

This file is a script that runs automatically whenever you start an **interactive shell** (like opening a terminal window), but **not** when running a script directly.

**Exercise 13:** Customize your `.bashrc` file to display a greeting message each time you open a new shell using the `cowsay` command. For example:

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


**Exercise 14**: try to run `apt update`/`dnf update` without sudo, and you should get an error. Then set the alias `please`, and then type please to just repeat the command without the need to retype it.

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

If you use the command `export` you will set environmental variables, that will be inherited by child processes:

```bash
export MYVAR="This will be seen by child"
bash test.sh
```

Usually many environmental variables are already defined, you can inspect them using `env` command. To unset a variable you could just `unset MYVAR`.

Most important environmental variables:
- `PATH`
- `HOME`
- `USER`
- `SHELL`
- `PWD` and `OLDPWD`
- `EDITOR`
- `PS1`

Usually messing up with these variables could lead to a broken interactive shell. It is not permanent, unless you mess with them in your `.bashrc`.

**Exercise 15** :
- try to break your interactive shell by corrupting `PATH` (not in the `.bashrc`)
- try to personalize your shell using the `PS1` variable

### History

You can query past commands typed in your bash shell using the `history` command and analyze its output to *stdout*.

You can search from the CLI on history using `ctrl+r` and typing a command:

```bash
(reverse-i-search)`mk': mkdir afolder
```

The bash history is stored in a text file in your home (usually, it can be checked by logging in at the variable `HISTFILE`).

**Exercise 16** Search where your history is stored and delete some commands.

## Pulling it together

You now know more than enough to write a useful script. Let's combine several ideas.

**Exercise 17:** Write a script `summary.sh` that takes a directory as an argument and prints:
1. the number of files in it (`$1` is the first argument),
2. the total disk usage (rounded, human-readable),
3. the 5 largest files.

Hints: combine `ls`, `find`, `du`, plus command substitution `$(...)`. Then run it on `~` and save the output to `summary.txt` with a redirect.
