# Jupyter lab installation

Prerequisites: have a port forwarding working from your VM to your laptop.

## Create virtual environment

```
$ python3 -m venv jupyter_environment
$ source jupyter_environment/bin/activate
```

## Install jupyter lab 

```
$ python3 -m pip install jupyter
```

## Start the notebook

Do this inside a tmux session:
```
$ tmux 
$ jupyter lab
```

And connect from you browser to the url suggested by jupyter lab:

```
 To access the server, open this file in a browser:
    Or copy and paste one of these URLs:
        http://localhost:8888/lab?token=aa84abc...
     or http://127.0.0.1:8888/lab?token=aa84abc...

```
