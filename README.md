### docker-wine-vcpython27


#### Why

Why run Microsoft's compiler inside a docker container running Wine?
So you can get rid of your Windows build workers, and live in operational
bliss. No more patch tuesdays, or daily reboots via Adobe PDF reader.

#### How

We're running Ubuntu 14.04 with the latest Wine (1.7) installed. On
top of this we use Microsoft's amazing standalone compiler package (the
best kept secret ever!) VCForPython27.msi. This was specifically built
to let you compile Python pip package, but obviously it can compile
anything.


#### Setup

The first time you ssh into the container, you have to run `/usr/bin/vcinstall.sh`
to set up your ~/.wine directory and run the actual installer. I tried
to automate this via the Dockerfile or on first login, but wine's setup
somehow gets messed up and cl.exe refuses to run properly. Make sure
you have X11 forwarding working (see below), then run:

```sh
    [dev@wine] /usr/bin/vcinstall.sh
```

After that you can run `docker save` so you don't have to keep doing it,
or better yet make `/home/dev/.wine` a docker volume.


#### Try it

Try compiling something.

```sh
    $ echo '#include <windows.h>' > a.c
    $ echo 'int main() { printf("hello world"); return 0; }' >> a.c
    $ cl.exe a.c
    $ wine a.exe

### X11 forwarding

The `run` target forwards your Xsession to the container. You shouldn't
need to do anything extra for this to work. To check if it's working, try:

```sh
    $ make HOST=c6 xeyes
```


#### Details

The container has some scripts in your `~dev/bin` that wrapper the
various executable like `~dev/bin/cl.exe`. You can call these directly
from anywhere on your system. The wrapper script `/usr/bin/vcwrap.sh`
ensures everything's set up right.

The default user (dev) has password-less sudo, and all the PAM session
annoyances when trying to use a container without a proper tty have
been taken care of. By default the container runs /sshd.sh which grabs
your public keys from Github or Launchpad before running sshd in
foreground mode. This is encapsulated via make with the `run` target.

```sh
    $ make build
    $ make GH_USER=ambakshi HOST=c6 run
```

##### Amit Bakshi, Jan/2015

