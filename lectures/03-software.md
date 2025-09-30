# Software managing

### The `PATH` Variable

The `PATH` variable tells the system where to find executable programs. When you type commands like `ls` or `grep`, the system looks through the directories listed in `PATH`.

**Exercise**: Explore your `PATH` variable:

```bash
from$ echo $PATH
/home/user/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

**Do it with Caution**: Resetting your `PATH` can break things!
```bash
$ unset PATH
```

If you issued the previous command, you current shell is probably broken, you need to close it and reopen in order to fix it. 
## Create and Install a Custom Command: `slowcat`

First, compile the `slowcat.c` file:

```bash
$ curl -o slowcat.c "https://raw.githubusercontent.com/Master-Data-Management-and-Curation/Scientific-Programming-Environment/refs/heads/main/codes/01-compile/slowcat.c"
$ gcc slowcat.c -o slowcat
$ file slowcat
slowcat: ELF 64-bit LSB executable
```

Now you’ve turned `slowcat.c` into an executable!

### Compilation Breakdown

1. Compile to assembly: `gcc -S slowcat.c -o slowcat.s`
2. Compile to object code: `gcc -c slowcat.s -o slowcat.o`
3. Link and create the executable: `gcc slowcat.o -o slowcat`

**Exercise**: Reproduce these steps of the compilation process.

### Installing `slowcat`

To install globally, move the compiled executable to `/usr/local/bin`:

```bash
$ sudo cp slowcat /usr/local/bin/
```

If you lack `sudo` privileges, update your `PATH` variable so the OS knows where to find the `slowcat` command:

```bash
$ export PATH=$(pwd):$PATH
$ which slowcat
/home/user/slowcat
```
Make this change permanent by adding it to your `.bashrc` file.

```bash
$ echo "export PATH=$(pwd):$PATH >> ~/.bashrc"
```
Or add with an editor `export PATH="/new/path/etc/:$PATH"`

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


## Advanced Exercises on software installation

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
```

Follow the instructions to build and install the HDF5 toolset.

*Super advanced exercise*(optional): `h5tools` also has a Cmake based build system, try to use it !

### Useful Packages

Depending on your system, you may need to install the following packages to compile software:

```bash
sudo apt install build-essential autoconf automake autopoint pkgconf gettext libncurses-dev texinfo
```

# Managing python environment

## Install packages `pip`
To installa python packages usually you will use `pip`. To install packages visible golgally, (e.g, to all user) you need administrator right. 

In a shared environment like a cluster you will install packages just for your user in a *local* path.


## Environment concept
Is possible to have different packages for different projects (for instance different version of `numpy`) thanks to environment. They could be implmemented by `conda`, `venv` or `virtualenv`.  Many other could be possible.

Exploiting environment is a good practice to handle depdendencys
## Virtual environment

You can create virtual environment with built-in python `venv` module as follow:
```bash
python3 -m venv mysuperenv
```
This command will create a folder called `mysuperenv` with inside all the necessary to run python3 and to installa additional libraries.

And you can activate it with:

```bash
source mysuperenv/bin/activate
```

Your shell will notify the active environment prepenrding `(mysuperenv)` in your console ! 

All the subsequent command `pip install` will install inside the folder mysuperenv, will not affect your system.


## Conda

