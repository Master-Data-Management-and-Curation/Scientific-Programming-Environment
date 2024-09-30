# Jupyter lab installation

Prerequisites: have a port forwarding working from your VM to your laptop with a proper config file.

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
$ jupyter lab --port=8000
```

And connect from you browser to the url suggested by jupyter lab:

```
 To access the server, open this file in a browser:
    Or copy and paste one of these URLs:
        http://localhost:8888/lab?token=aa84abc...
     or http://127.0.0.1:8888/lab?token=aa84abc...

```

## Open a sample jupyter notebook

Download this repository:

```
$ git clone 
```

You will find the notebook on this folder: `Scientific-Programming-Environment/codes/05-jupyterlab/` . 
