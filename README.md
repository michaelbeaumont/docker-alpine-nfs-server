# nfs-server-alpine

A handy NFS Server image comprising Alpine Linux and NFS v4 only, over TCP on port 2049.

## Overview

The image comprises of;

- [Alpine Linux](http://www.alpinelinux.org/) v3.12. Alpine Linux is a security-oriented, lightweight Linux distribution based on [musl libc](https://www.musl-libc.org/) (v1.1.24) and [BusyBox](https://www.busybox.net/).
- NFS v4 only, over TCP on port 2049. Rpcbind is enabled for now to overcome a bug with slow startup, it shouldn't be required.

You'll need to mount your own `/etc/exports` file with the options you require
pointing to the directories mounted into the container:

```
/mnt *(rw,fsid=0,async,no_subtree_check,no_auth_nlm,insecure,no_root_squash)
```

### Privileged Mode

Privileged mode is required. Yes, this is a security risk but an unavoidable one it seems. You could try these instead: `--cap-add SYS_ADMIN --cap-add SETPCAP --security-opt=no-new-privileges` but I've not had any luck with them myself. You may fare better with your own combination of Docker and OS. The SYS_ADMIN capability is very, very broad in any case and almost as risky as privileged mode.

See the following sub-sections for information on doing the same in non-interactive environments.

#### Kubernetes

As reported here https://github.com/sjiveson/nfs-server-alpine/issues/8 it appears Kubernetes requires the `privileged: true` option to be set:

```
spec:
  containers:
  - name: ...
    image: ...
    securityContext:
      privileged: true
```

### Acknowlegements

Thanks to Torsten Bronger @bronger for the suggestion and help around implementing a multistage Docker build to better handle the inclusion of Confd (since removed).
