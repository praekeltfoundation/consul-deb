# consul-deb
Files for packaging [Consul](https://consul.io) as a .deb file for (at the moment) Ubuntu Trusty.

Builds a .deb package using Praekelt's packaging and deployment tool, [Sideloader](https://github.com/praekelt/sideloader/).

**NOTE:** Currently only Ubuntu 14.04 (a.k.a. Trusty) on amd64 platforms is supported. Other versions of Ubuntu on amd64 that use Upstart 1.4+ (i.e. 12.04 - 14.10) should work too but are untested.

Consul binary signatures are verified using Hashicorp's PGP public key. The key is available [here](https://hashicorp.com/security.html) and needs to be added to the build user's default keyring for builds to complete.

The built package will include:
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
