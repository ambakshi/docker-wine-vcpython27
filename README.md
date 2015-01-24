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

#### Details

The container has some scripts in your `~dev/bin` that wrapper the
various executable like `~dev/bin/cl.exe`. You can call these directly
from anywhere on your system. The wrapper script `~dev/bin/vcwrap.sh`
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

### X11 forwarding

The `run` target forwards your Xsession to the container. You shouldn't
need to do anything extra for this to work. To check if it's working, try:

```sh
    $ make HOST=c6 xeyes
```

##### Amit Bakshi, Jan/2015

