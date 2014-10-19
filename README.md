# ahri/darp

Docker App Reverse Proxy

When linked to other apps it'll check for HTTP ports and reverse-proxy them,
providing an index at the base host (provided as a runtime param) and exposing
each app as a vhost under that domain, e.g.

Providing ahri.net as the base host, linking with --link torrent:transmission,
transmission.ahri.net will be exposed.

For example usage, see:
* Build: ./build.sh
* Run: ./run.sh

## TODO
* Refuse to reverse proxy if more than one port exposes HTTP
