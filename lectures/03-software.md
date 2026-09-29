# Software managing

### The `PATH` Variable

The `PATH` variable tells the system where to find executable programs. When you type commands like `ls` or `grep`, the system looks through the directories listed in `PATH`.

**Exercise 1**: Explore your `PATH` variable:

```bash
$ echo $PATH
/home/user/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

**Do it with Caution**: Resetting your `PATH` can break things!
```bash
$ unset PATH
```

If you issued the previous command, your current shell is probably broken, you need to close it and reopen in order to fix it.
## Create and Install a Custom Command: `slowcat`

*Prerequisite:* clone the repository in order to have the folder `code` to experiment:
```bash
git clone https://github.com/Master-Data-Management-and-Curation/Scientific-Programming-Environment.git
```

First, compile the `slowcat.c` file:

```bash
$ cd Scientific-Programming-Environment/codes
$ gcc slowcat.c -o slowcat
$ file slowcat
slowcat: ELF 64-bit LSB executable
```

Now you’ve turned `slowcat.c` into an executable!

### Compilation Breakdown

1. Compile to assembly: `gcc -S slowcat.c -o slowcat.s`
2. Compile to object code: `gcc -c slowcat.s -o slowcat.o`
3. Link and create the executable: `gcc slowcat.o -o slowcat`

**Exercise 2**: Reproduce these steps of the compilation process.

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
echo 'export PATH="'$PWD':$PATH"' >> ~/.bashrc
```
Or add it with an editor: `export PATH="/new/path/etc/:$PATH"`

**Exercise 3**: install `slowcat` in your `.local/bin` folder, if not present create it in your home. Then add it to the `PATH`.
### Easy

- Use your system's package manager (e.g., `apt`, `dnf`).
- Search for the package you need either [here](https://pkgs.org) or using your package manager’s search function.

**Pros**: The software from official repositories is signed, ensuring its authenticity. You also get free, automatic updates.

**Limitations**: The version you need might not be available, or the version provided may be outdated or too new for your needs.

**Exercise 4** (package manager):

1. Search for a tool of your choice with `apt search <name>` (or `dnf search`), and read the description of the candidate package.
2. Show detailed info about an installed package, e.g. `apt show htop` (or `apt info`).
3. Install `htop` and run it. Find the equivalent of `top`/`htop` in your distribution.
4. Remove it afterwards with `apt remove` (or `dnf remove`).

### Medium

Download or copy precompiled binaries and hope they work.

However, several issues can arise:
1. The binaries may be compiled for a different architecture, leading to incompatible CPU instructions.

    ```bash
    $ cd codes/02-binaries
    $ ./illegal
    [1]    1888554 illegal hardware instruction (core dumped)  ./illegal
    ```

2. The binaries might depend on dynamic libraries that are missing, causing runtime errors.

    ```bash
    $ cd codes/02-binaries
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
    $ cd codes/02-binaries
    $ ./nano
    ...
    ```

4. If none of these issues occur, you might be lucky enough to have a *static* binary that runs without additional dependencies.

    ```bash
    $ cd codes/02-binaries
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

### Exercise 5 — Uninstall and rebuild Nano

Uninstall `nano` from your system, then rebuild and reinstall it from source.
Here the source code: [git](https://savannah.gnu.org/git/?group=nano)

Alternatively you can download the source code from this url as compressed archive:

```bash
wget https://www.nano-editor.org/dist/v8/nano-8.6.tar.gz
```

Then you can extract this:

```bash
tar -xvf nano-x.y.tar.gz
```
### Exercise 6 — Introduction to HDF5 files

HDF5 is a binary file format designed for high-performance I/O operations. You will encounter it later in your studies. Since it is binary, a text editor won’t work to view its contents.

Install the necessary tools to work with HDF5 files from your system's repository, so you can view and open HDF5 files, at the end you will be able to do:

```
$ cd codes/03-exercise
$ h5ls exercise.h5
ExerciseSolved           Dataset {100, 100}
```

#### Building Your Own HDF5 Viewer Tool

As an exercise, imagine that the required HDF5 tools are not available in your repository. Download and build the tools from source.

**Hint**: Refer to the [HDF5 GitHub repository](https://github.com/HDFGroup/hdf5/tree/develop). Specifically, review the instructions found in the `release_docs/` directory for platform-specific details.

Starting point:

```bash
$ git clone https://github.com/HDFGroup/hdf5.git
$ cd hdf5 && git checkout 1.14.1
```

Follow the instructions to build and install the HDF5 toolset.

**Exercise 7 (super advanced, optional)**: `h5tools` also has a CMake based build system, try to use it !

### Useful Packages

Depending on your system, you may need to install the following packages to compile software:

```bash
sudo apt install build-essential autoconf automake autopoint pkgconf gettext libncurses-dev texinfo
```


---

## Managing `python` environments

In the following section, we illustrate various approaches for managing scientific software within a Python-based environment to prevent the scenario depicted in the figure below.

!["https://xkcd.com/1987"](..//assets/python-env.png  "https://xkcd.com/1987")

### Conda


####  Installation

Retrieve the most recent conda installer and execute it:

```bash
$ wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
$ bash Miniforge3-$(uname)-$(uname -m).sh
```
And you can select the installation path:

```bash

    Miniconda3 will now be installed into this location:
    /u/group/user//miniconda3

    - Press ENTER to confirm the location
    - Press CTRL-C to abort the installation
    - Or specify a different location below

    [/u/group/user//miniconda3] >>> /u/group/user/scratch/miniconda
  PREFIX=/u/group/user/scratch/miniconda

```
**Note**:a fter the installation your `.bashrc` will be modified in order to have conda command available and by default `base` env is activated. Automatically loading the `base` env **can slow down your login procedure**, so disable it: `conda config --set auto_activate_base false`. Setting this flag to `false` can significantly speedup your login.

If you select to not auto-activate conda you will see the following prompt:

```
You have chosen to not have conda modify your shell scripts at all.
To activate conda's base environment in your current shell session:

eval "$(/u/group/user/scratch/miniconda3/bin/conda shell.YOUR_SHELL_NAME hook)"

To install conda's shell functions for easier access, first activate, then:

conda init

Thank you for installing Miniconda3!
```

The default shell in orfeo is `bash` so the command to activate and init the base environment is:

```
eval "$(/u/group/user/scratch/miniconda3/bin/conda shell.bash hook)"
conda init
```


### Python `virtualenv`

Instead of using conda, you have the option to utilize virtual environments to manage your Python packages without affecting your main workspace.
Two main implementation are available:

- [Official `virtualenv` docs](https://virtualenv.pypa.io/en/latest/)

- [Official `venv` docs](https://docs.python.org/3/library/venv.html)


The workflow is similar to the one of conda:

1.  Create an environment
2.  Activate the environment
3.  Install packages and work within it
4.  Deactivate the environment

### Creation

To create a new environment:
```
python3 -m virtualenv mySuperEnv
```

###  *[de]* activation

```
$ ls
mySuperEnv
$ source mySuperEnv/bin/activate
(mySuperEnv)$
... some work ...
... some pip install ...
(mySuperEnv)$ deactivate
$

```
*Note*: The Python version within the virtual environment is identical to the one used for its creation.

### Python version

Yes but: *"conda let me choose the python version"*, conda allows you to do the following 'conda create -n  old_python python=3.9'.

```
$ wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz
$ tar -xzf Python-3.8.0.tgz
$ cd Python-3.8.0/
$ ./configure --enable-optimizations CC="gcc -pthread" CXX="g++ -pthread"
$ make -j 24
```

 Create `virtualenv` with your favourite python version

```
$ python3 -m virtualenv --python="Python-3.8.0/python" mySuperEnv3.8
$ source mySuperEnv3.8/bin/activate
(mySuperEnv3.8) [user@epyc007 pyenv]$ python
Python 3.8.0 (default, Jan 15 2024, 12:07:47)
[GCC 12.2.1 20221121 (Red Hat 12.2.1-4)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

[](../)

## Install packages with `pip`

To install Python packages you usually use `pip`.
To install packages globally (i.e., visible to all users), you need administrator rights.

In a shared environment, such as a cluster, you will typically install packages only for your user in a _local_ path.


**Exercise 8** (virtual environments):

1. Create a virtual environment called `myenv`, activate it and confirm the prompt now shows `(myenv)`.
2. Install two packages inside it, e.g. `pip install numpy requests`.
3. Check that `pip list` shows them *only* inside the environment, not system-wide.
4. Export the environment to `requirements.txt` and inspect the file.
5. Deactivate, create a second environment `myenv2`, and reproduce the same environment with `pip install -r requirements.txt`.
6. Delete `myenv` and `myenv2` (removing the folder is enough: an environment is just a folder).
