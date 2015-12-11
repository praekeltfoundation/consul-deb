# consul-deb
Files for packaging [Consul](https://consul.io) as a .deb file for (at the moment) Ubuntu Trusty.

Builds a .deb package using Praekelt's packaging and deployment tool, [Sideloader](https://github.com/praekelt/sideloader/).

**NOTE:** Currently only Ubuntu 14.04 (a.k.a. Trusty) on amd64 platforms is supported. Other versions of Ubuntu on amd64 that use Upstart (e.g. Precise) should work too but are untested.

This includes only the basics:
* The Consul binary (no web UI)
* An Upstart init script
* The most basic config file to get things up and running

#### Some notes:
* The Consul binary is installed to `/usr/local/bin/consul`.
* Consul is run as `consul:consul`. This user has no rights except access to Consul's working directories.
* Runtime defaults:
  * `-pid-file`: `/var/run/consul/agent.pid`
  * `-data-dir`: `/var/lib/consul`
  * `-config-file`: `/etc/consul.json`
  * `-config-dir`: `/etc/consul.d`
* The above defaults can be overridden by overriding the `CONSUL_OPTS` variable in `/etc/default/consul`.
