# Editors and Text Files

## Survival kit

Here’s a list of handy commands for working with files:

- `touch` – Create an empty file
- `ls [-lahrt]` – List files with different options (like long format, showing hidden files, human-readable sizes, etc.)
- `cat` – Display file contents
- `echo` – Output text or append to a file
- `less` – View file content page by page
- `head` – Show the beginning of a file
- `tail` – Show the end of a file
- `pwd` - I'm lost, **p**rint **w**orking **d**irectory.

### Tip:
If you're unsure how a command works, use `man unknownCommand` to access its manual.

If the manual isn’t available, try using the common `-h` or `--help` options for assistance.

### Creating an Empty File

```bash
$ touch my_empty_file
$ ls -l
total 0
-rw-rw-r-- 1 user user 0 Sep 16 20:41 my_empty_file
$ cat my_empty_file
$
```

### Writing Text to a File

```bash
$ echo "Some text" > not_empty_file
$ cat not_empty_file
Some text
$ ls -l
total 4
-rw-rw-r-- 1 user user  0 Sep 16 20:41 my_empty_file
-rw-rw-r-- 1 user user 10 Sep 16 20:42 not_empty_file
```

### Appending Text to a File

```bash
$ echo "Append some text" >> not_empty_file
$ cat not_empty_file
Some text
Append some text
```

### Reading a Long File

First, generate a long file:

```bash
$ for i in {1..1000000}; do echo "line $i"; done > long_file.txt
```

You can compare the file sizes using `ls -l` and `ls -lh` for a clearer view.

To read the file:

```bash
$ less long_file.txt   # Press 'q' to exit less
$ cat long_file.txt | less
```

To search within the file while using `less`, press `/` followed by the search term. Navigate results using `n` (next) or `Ctrl+n` (previous).

### Display the Beginning of a File

```bash
$ head long_file.txt
line 1
line 2
line 3
line 4
line 5
line 6
line 7
line 8
line 9
line 10
```

Or, display only the first three lines:

```bash
$ head -n 3 long_file.txt
line 1
line 2
line 3
```

**Exercise**: Try the same using the `tail` command to view the last lines.

### Searching for a Pattern in a File

One of the most useful tools for searching inside files is `grep`:

```bash
$ grep "12345" very_long_file
Line 12345
Line 112345
Line 123450
Line 123451
Line 123452
Line 123453
```

**Exercise**: familiarize with the options `-A` `-B` `-C`, search the meaning on the man.

### A Quirky Way to Write to a File

```bash
$ cat > fancy_file << EOT
> hi
> this is a very strange way to edit a file
> EOT
$ cat fancy_file
hi
this is a very strange way to edit a file
```

### Thankfully, We Have Text Editors

Common editors include:

- **GNU nano**: Easy to use, great for simple tasks.
- **vim**: A more complex, modal editor. To exit, press `Esc` and type `:q!`. Use `vimtutor` for a guided tutorial.
- **emacs**: Powerful editor. Start the tutorial with `Ctrl+h t`. To quit, press `Ctrl+x Ctrl+c`. For fun, try starting a game of Tetris with `Alt+x tetris`.

**Exercise**: Install all three editors using your package manager, then open, edit, and close a file in each.

## File Manager

`ranger` is a user-friendly CLI file manager. Some useful commands:

- Copy: `yy`
- Paste: `pp`
- Show hidden files: `:set show_hidden true`

Other options include `mc` and `broot`.

**Exercise**: Copy a file using `ranger`, paste it, and then open and edit it in one of the editors.

# Terminal Multiplexer

Suppose you have a script that runs indefinitely:


```bash
$ cd codes/00-multiplexing
$ sh slow_script.sh
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

### Share Your Terminal with Friends

```bash
$ tmux -S /tmp/shared_session_socket
$ chmod 777 /tmp/shared_session_socket
$ tmux server-access -a friend_username
```

Your friend can then join with:
```bash
$ tmux -S /tmp/shared_session_socket
```

# Software Installation

## Environment Variables

### The PATH Variable

The `PATH` variable tells the system where to find executable programs. When you type commands like `ls` or `grep`, the system looks through the directories listed in `PATH`.

**Exercise**: Explore your `PATH` variable:

```bash
$ echo $PATH
/home/user/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

**Do it with Caution**: Resetting your `PATH` can break things!
```bash
$ unset PATH
```

## Create and Install a Custom Command: `slowcat`

First, compile the `slowcat.c` file:

```bash
$ cd codes/01-compile
$ gcc slowcat.c -o slowcat
$ file slowcat
slowcat: ELF 64-bit LSB executable
```

Now you’ve turned `slowcat.c` into an executable!

### Compilation Breakdown



1. Compile to assembly: `gcc -S slowcat.c -o slowcat.s`
2. Compile to object code: `gcc -c slowcat.s -o slowcat.o`
3. Link and create the executable: `gcc slowcat.o -o slowcat`

**Exercise**: Reproduce these steps of the compilation process:

### Installing `slowcat`

To install globally, move the compiled executable to `/usr/local/bin`:

```bash
$ sudo cp slowcat /usr/local/bin/
```

If you lack `sudo` privileges, update your `PATH` variable so the OS knows where to find the `slowcat` command:

```bash
$ exporppt PATH=$(pwd):$PATH
$ which slowcat
/home/user/slowcat
```
Make this change permanent by adding it to your `.bashrc` file.

```bash
$ echo "export PATH=$(pwd):$PATH >> ~/.bashrc"
```


### Easy

- Use your system's package manager (e.g., `apt`, `dnf`).
- Search for the package you need either [here](https://pkgs.org) or using your package manager’s search function.

**Pros**: The software from official repositories is signed, ensuring its authenticity. You also get free, automatic updates.

**Limitations**: The version you need might not be available, or the version provided may be outdated or too new for your needs.

### Medium

Download or copy precompiled binaries and hope they work. However, several issues can arise:

1. The binaries may be compiled for a different architecture, leading to incompatible CPU instructions.

    ```bash
    $ cd codes/02-binaries
    $ ./illegal
    [1]    1888554 illegal hardware instruction (core dumped)  ./illegal
    ```

2. The binaries might depend on dynamic libraries that are missing, causing runtime errors.
    
    ```bash
    $ cd codes/02-errors
    $ ./missing_libraries
    ./missing_libraries.x: error while loading shared libraries: libmpi.so.40: cannot open shared object file: No such file or directory
    $ ldd missing_libraries
        linux-vdso.so.1 (0x00007f9cf373c000)
        libmpi.so.40 => **not found**
        libc.so.6 => /lib64/libc.so.6 (0x00007f9cf3532000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f9cf373e000)
    ```

3. **Risk of malware**: You could end up downloading malicious software. For example, running this fake version of nano:
   
    ```bash
    $ cd codes/02-errors
    $ ./nano
    ...
    ```

4. If none of these issues occur, you might be lucky enough to have a *static* binary that runs without additional dependencies.

    ```bash
    $ cd codes/02-errors
    $ ./nano-static
    ```

### Hard

If the software you need isn’t available via your package manager, you can compile it from source.

Building complex software usually involves at least three steps, with detailed instructions provided in the documentation about how to compile and install it, along with any dependencies you need to meet.

In this example, we will compile VIM from source following the instructions in its `README.md` file (always read the documentation first):

*If you obtained a binary distribution, you don't need to compile Vim. If you got a source distribution, all the compiling instructions are in the src directory. See src/INSTALL for details.*

You can find an example of typical installation steps [here](https://github.com/vim/vim/blob/master/src/INSTALL).

First, download the source code and check out the desired version:

```
$ git clone https://github.com/vim/vim.git && cd vim && git checkout v9.1.0733
```

#### Configure

The first step is configuration. This generates `Makefile` scripts, which handle the compilation, linking, and installation with the appropriate flags and paths. You can customize the software during this step, from basic options like installation paths to more advanced configurations. Configuration also checks if all dependencies are met.

You can see available configuration options by running the configure script with the `--help` flag:

```bash
$ ./configure --help
...
...
$ ./configure --prefix=/usr/local/  # Specifying the installation directory
....
```

#### Compile

This step usually just requires patience. The `-j` flag controls the level of parallelism (the number of cores used). The higher the number, the faster the compilation (up to the number of CPU cores).

```bash
$ make -j 4
```

#### Test

Serious software often includes tests to verify the success of the compilation.

```bash
$ make test
```

#### Install

Finally, the compiled binaries are installed in the specified location, such as `/usr/local/bin`. Depending on the location, the software might be installed system-wide or just for the current user. Installing system-wide usually requires root permissions.

```bash
$ sudo make install
```

# Exercises

## Basic Commands

- Open a manual page using `man` and practice navigating through it. Use `/` to search for terms within the manual.
- Combine two files into one using `cat` and redirect the output to a new file.
- Use `grep` together with the `|` operator to search for a specific term in `very_long_file` and save the search results to a separate file.
- Install `ranger` using your package manager. Once installed, use it to copy a file and explore the filesystem.
- If you're unfamiliar with CLI text editors, pick one (e.g., `nano`) and practice opening, editing, and saving a file.
- Follow the instructions above to install the `slowcat` command. If any dependencies are missing, install them using your package manager.
- Get comfortable with `tmux` by splitting the screen and opening multiple sessions. (If you're already experienced, try doing everything above inside a `tmux` session.)

## Advanced Exercises

### Uninstall and Rebuild Nano

Uninstall `nano` from your system, then rebuild and reinstall it from source.
Here the source code: [git](https://savannah.gnu.org/git/?group=nano)

### Introduction to HDF5 Files

HDF5 is a binary file format designed for high-performance I/O operations. You will encounter it later in your studies. Since it is binary, a text editor won’t work to view its contents.

Install the necessary tools to work with HDF5 files from your system's repository, so you can view and open HDF5 files, at the end you will be able to do:

```
$ cd codes/03-exercise
$ h5ls exercise.h5
ExerciseSolved           Dataset {100, 100}
```

### Building Your Own HDF5 Viewer Tool

As an exercise, imagine that the required HDF5 tools are not available in your repository. Download and build the tools from source.

**Hint**: Refer to the [HDF5 GitHub repository](https://github.com/HDFGroup/hdf5/tree/develop). Specifically, review the instructions found in the `release_docs/` directory for platform-specific details.

Starting point:

```bash
$ git clone https://github.com/HDFGroup/hdf5.git
$ cd hdf5 && git checkout 1.14.1
`****

Follow the instructions to build and install the HDF5 toolset.

*Super advanced exercise*(optional): `h5tools` also has a Cmake based build system, try to use it !
### Useful Packages

Depending on your system, you may need to install the following packages to compile software:

```bash
sudo apt install build-essential autoreconf autoconf automake autopoint pkgconf gettext libncurses-dev texinfo
```
