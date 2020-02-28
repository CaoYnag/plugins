# cdfh plugin

## Overview

`dhhp` plugin is a custom dynamic host holding address management plugin, witch extends from `dhcp` plugin.

also, the same plugin binary can also be run in the daemon mode.

## Operation

To use the dhcp IPAM plugin, first launch the dhcp daemon:

```
# Make sure the unix socket has been removed
$ rm -f /run/cni/dhhp.sock
$ ./dhhp daemon
```

If given `-pidfile <path>` arguments after 'daemon', the dhhp plugin will write its PID to the given file.
If given `-hostprefix <prefix>` arguments after 'daemon', the dhhp plugin will use this prefix for DHHP socket as `<prefix>/run/cni/dhhp.sock`. You can use this prefix for references to the host filesystem, e.g. to access netns and the unix socket.

Alternatively, you can use systemd socket activation protocol.
Be sure that the .socket file uses /run/cni/dhhp.sock as the socket path.

With the daemon running, containers using the dhhp plugin can be launched.

## Example configuration

```
{
	"ipam": {
		"type": "dhhp",
	}
}

## Network configuration reference

* `type` (string, required): "dhhp"
```
