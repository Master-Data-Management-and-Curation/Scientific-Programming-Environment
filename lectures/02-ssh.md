# SSH and Others

**SSH** (**S**ecure **S**hell) is a protocol used to remotely access machines.  
We will use it to connect to Orfeo and to your dedicated VMs. In general, SSH is the standard way to access Unix-based systems remotely.

---

## Password or Keys?

To log in to a remote machine, you can either use a **password** or a **public/private key pair**, depending on how the server is configured.  
Key pairs are usually preferred: they are more secure and avoid the need to share passwords.

---

## Generating a Key Pair

If you need access to a remote machine, you usually have to send your **public key** to the system administrator. You can generate a key pair with the `ssh-keygen` command:

```bash
ssh-keygen -t rsa -b 4096 -C 'your_email@example.com'
```

Example output:

```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/vagrant/.ssh/id_rsa
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:/5K6wVVNXuLAWYl2UFMspKOVerqwKneuLV9q6naMA4w your_email@example.com
```

### Explanation of options

- `-t`  Type of key. Possible values: `rsa`, `ed25519`, `ecdsa`, etc.  
	Recommended: `rsa` or `ed25519`.
- `-b`  Key length (for `rsa` keys, use **4096**).
- `-C`  Adds a comment/label to the public key.
- **Passphrase**  Adds an extra layer of protection. If your private key is stolen, it cannot be used without the passphrase.
- **Location and name**  You can choose a custom path/filename. Using the default location (`~/.ssh/id_rsa`) is recommended for everyday use, since SSH automatically looks there.

---

## Accessing Generated Keys

If you used the default location, your key pair will be stored in the hidden `.ssh` directory inside your home folder.

Example:

```bash
vagrant@ubuntu2204:~/.ssh$ ls -la
total 20
drwx------ 2 vagrant vagrant 4096 Sep 21 13:28 .
drwxr-x--- 4 vagrant vagrant 4096 Sep 21 13:52 ..
-rw------- 1 vagrant vagrant  389 Sep 21 13:23 authorized_keys
-rw------- 1 vagrant vagrant 3389 Sep 21 13:28 id_rsa
-rw-r--r-- 1 vagrant vagrant  748 Sep 21 13:28 id_rsa.pub
```

- `id_rsa` your **private key** (keep it secret, only accessible by you).
- `id_rsa.pub` your **public key** (safe to share).
**Important:**
- Private key (`id_rsa`) must be readable **only** by you.    
- If permissions are too loose, SSH will refuse to use the key.

---

## First SSH Login to Orfeo

To log in for the first time:

```bash
ssh username@195.14.102.215
```

By default, SSH looks in `~/.ssh` for your private key.

To specify a custom key:

```bash
ssh -i my_custom_key username@195.14.102.215
```

**Exercise:**

- Run with `-vvv` to see detailed logs of the SSH process.
- Generate a new key pair, try connecting, and observe what happens if the server doesn’t know your public key.
- Copy your key to a different location and connect using `-i`.

---

## Configuring SSH

Typing your username, IP address, and key path every time is inconvenient. You can simplify this with an SSH configuration file.

Create/edit `~/.ssh/config`:

```
Host orfeo
  HostName 195.14.102.215
  User your_username
  IdentityFile /absolute/path/to/your_private_key
```

Now you can log in with:

```bash
ssh orfeo
```

**Exercise:** Set up your SSH config to simplify your login.

---

## Adding New Keys

When you connect via SSH, the server checks your **authorized keys** in `~/.ssh/authorized_keys` (on the remote machine).  
To allow another key, simply add its **public key** as a new line in that file.
**Exercise:**
- Generate a second key pair.
- Add the public key to your remote `authorized_keys` file on Orfeo.

**Warning:**  
Do not overwrite or delete your existing key in `authorized_keys`, or you might lock yourself out!

--- 
Nice — I fixed and finished both sections. I corrected grammar, clarified commands and options, added useful tips and exercises, and completed the port-forwarding section with practical examples.

---
### Copy files

There are several ways to move files between machines using SSH. One simple tool is **Secure Copy** (`scp`). Its interface is almost the same as `cp`:

```bash
scp [options] [source] [destination]
```

Either `source`, `destination`, or both can be remote. Use the format `user@host:/path` for remote locations.

**Examples**

Copy a local file to Orfeo:
```bash
scp my_file username@195.14.102.215:/u/ipahome/yourusers/
```

Copy a whole directory (recursive):
```bash
scp -r my_folder username@195.14.102.215:/u/ipahome/yourusers/
```

Use a specific identity key:
```bash
scp -i /path/to/private_key my_file username@195.14.102.215:/u/ipahome/yourusers/
```

Use the `Host` alias from your `~/.ssh/config`:
```bash
scp my_file orfeo:/u/ipahome/yourusers/
```
**Useful options**
- `-r` : copy directories recursively.
- `-P <port>` : specify a nonstandard SSH port (note uppercase `-P` for `scp`).
- `-i <key>` : use a specific private key.
- `-p` : preserve modification times, access times, and modes.
- `-C` : enable compression (good for slow links).
-
**Tip:** For large syncs, bandwidth-efficient transfers, or resumable copies prefer `rsync -e ssh` (e.g. `rsync -avz -e "ssh -i /path/to/key" source/ user@host:/dest/`).

**Exercise**
1. Copy a file from your laptop to ORFEO.
2. Copy a file from ORFEO back to your laptop.
3. Copy a directory recursively with `-r`.
4. Try the same operations using the `orfeo` alias from your `~/.ssh/config`.

**Extra**: both source and destination can be remote, e.g.:
```bash
scp user1@hostA:/path/to/file user2@hostB:/path/to/destination
```

---
### Forwarding

SSH can forward ports so you can securely access services on a remote machine (or on your local machine) that are otherwise unreachable. There are three common types of forwarding:

1. **Local forwarding** (`-L`)  forward a local port to a remote address/port through the SSH server.
2. **Remote forwarding** (`-R`)  forward a remote port to a local address/port.
#### Local forwarding (`-L`)

Forward remote service `localhost:8080` (on the remote machine) to your local port `8080`:

```bash
ssh -L 8080:localhost:8080 username@195.14.102.215
```

**Exercise**: on ORFEO start a webserver with python `python3 -m http.server <portnumber>` and try to access it from your local machine using the browser and using `wget`/`curl`.

Use `-N` to run SSH without an interactive shell (only forwarding) and `-f` to put it in the background:

```bash
ssh -f -N -L 5432:localhost:5432 username@195.14.102.215
```

**Exercise** once that you run this in background, test if it is working and then use `ps` and `kill` to terminate the process.
#### Remote forwarding (`-R`)

Forward a port on the remote server back to your local machine. Useful if you want the remote host (or people on it) to access a service running on your laptop.

Expose your local web server at `localhost:3000` to port `9000` on the remote host:

```bash
ssh -R 9000:localhost:3000 username@195.14.102.215
```

Now someone on the remote host can access `http://localhost:9000` and reach your local `3000`.

**Note**: Remote forwarding can be restricted by the server’s SSH configuration (`GatewayPorts`, `AllowTcpForwarding`).

**Exercise** start a local web server, as above, but in your machine, the check it correct functionality with `curl`/`wget`. 

---
## SSH Jump Host (`-J`)

Sometimes, the machine you want to reach is **not directly accessible** from your local computer. It may be behind a firewall or only reachable from another machine (the **jump host** or **bastion host**).

SSH can **tunnel through an intermediate server** using the `-J` flag.

```bash
ssh -J user_jump@jump_host youruser@orfeo
```

- `youruser@orfeo`  the jump/bastion server you can connect to directly.
- `target_user@target_host`  the final server you want to reach.

SSH automatically connects to the jump host and then forwards traffic to the target host.

### Config file shortcut

You can simplify it in `~/.ssh/config`:

```text
Host jump
  HostName jump.example.com
  User alice
  IdentityFile ~/.ssh/id_jump

Host internal
  HostName internal.example.com
  User alice
  IdentityFile ~/.ssh/id_target
  ProxyJump jump
```

Now you can just run:

```bash
ssh internal
```

and SSH will automatically use the jump host.
