# Bash Scripting

## 1. Exit Codes & Arguments

```bash
#!/bin/bash
# Script that checks if exactly one argument is given

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1    # non-zero = error
fi

echo "You gave me the argument: $1"
exit 0        # zero = success
```

### Key Concepts

* `$#` - number of arguments (like argc)
* `$0` - script name (like argv\[0])
* `$1`, `$2`, ... - arguments
* `echo $?` - check exit code of last command

**Exercise:** Introduce a bug in the script and check exit code with `echo $?`.

---

## 3. Debugging Scripts

Buggy script:

```bash
#!/bin/bash
# A script with a hidden bug

echo "Starting script..."
mkdir /tmp/mytestdir
cd /tmp/mytestdir
touch file1.txt file2.txt
rm file3.txt    # file does not exist
echo "All done!"
```

### Debugging Options

* `set -x`:  print commands before running them (trace)
* `set -e`: exit immediately if a command fails
* `set -xe`: combine both

**Exercise:** Add `set -xe` after the shebang and find the bug.

---

## 4. Conditionals & Loops

First we can write a program that generate `n` empty `txt` files in the current directory.

```bash
#!/bin/bash
# Script to generate N empty .txt files in current directory

# Default number of files
DEFAULT=5

# If no argument is given, use default
if [ "$#" -eq 0 ]; then
    N=$DEFAULT
else
    N=$1
fi

# Create files
for i in $(seq 1 $N); do
    touch "file${i}.txt"
done

echo "Created $N empty .txt files in $(pwd)"
```

Now create a program that count the amount of `txt` files in a given directory.

```bash
#!/bin/bash
# List .txt files in a given directory

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

DIR=$1

if [ ! -d "$DIR" ]; then
    echo "Error: $DIR is not a directory"
    exit 2
fi

count=0
for file in "$DIR"/*.txt; do
    [ -e "$file" ] || continue
    echo "Found: $file"
    count=$((count + 1))
done

echo "Total .txt files: $count"
```

**Exercise:**  Modify the first script to refure to write exeisting files, use the check `if [-e filename]`.


---

## 5. Automate a task

Backup a directory into `tar.gz`:

```bash
#!/bin/bash
# Backup a directory with date stamp

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

DIR=$1
DATE=$(date +%Y-%m-%d)

tar -czf "${DIR##*/}_backup_$DATE.tar.gz" "$DIR"
```

**Exercise:**

* Run it on your home directory.
* Check archive size.
* Extract with:

  ```bash
  tar -xzf backup.tar.gz
  ```

---


