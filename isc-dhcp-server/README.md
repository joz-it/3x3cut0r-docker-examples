# isc-dhcp-server (dhcpd)

**A lightweight and secure dhcp-server (isc-dhcp-server)**

![Docker Image Version (latest by date)](https://img.shields.io/docker/v/3x3cut0r/isc-dhcp-server)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/3x3cut0r/isc-dhcp-server)
![Docker Pulls](https://img.shields.io/docker/pulls/3x3cut0r/isc-dhcp-server)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/3x3cut0r/docker/isc-dhcp-server.yml?branch=main)
![run as](https://img.shields.io/badge/run%20as-non--root-red)

`GitHub` - 3x3cut0r/isc-dhcp-server - https://github.com/3x3cut0r/docker/tree/main/isc-dhcp-server  
`DockerHub` - 3x3cut0r/isc-dhcp-server - https://hub.docker.com/r/3x3cut0r/isc-dhcp-server

## Index

1. [Usage](#usage)
   1. [docker run](#dockerrun)
   2. [docker-compose.yaml](#dockercompose)
2. [Environment Variables](#environment-variables)
3. [Volumes](#volumes)
4. [Ports](#ports)
5. [Find Me](#findme)
6. [License](#license)

## Usage <a name="usage"></a>

### docker run <a name="dockerrun"></a>

**Example 1 - IPV4 - run with custom dhcpd.conf**  
**This is the recommended way to use this container,**  
**otherwise you will not be able to use all options that dhcpd.conf supports**  
**Note: IFACE have to fit with your host-interface !!!**

```shell
docker run -d \
    --name isc-dhcp-server \
    --network=host \
    -e IFACE=eth0 \
    -v /path/to/your/dhcpd.conf:/etc/dhcp/dhcpd.conf:ro \
    3x3cut0r/isc-dhcp-server:latest
```

**Example 2 - IPV4 - run with specified environment variables**  
**Note: IFACE+SUBNET have to fit with your host-interface !!!**

```shell
docker run -d \
    --name isc-dhcp-server \
    --network=host \
    -e TZ="Europe/Berlin" \
    -e IFACE=eth0 \
    -e SUBNET=192.168.0.0 \
    -e NETMASK=255.255.255.0 \
    -e RANGE_BEGIN=192.168.0.100 \
    -e RANGE_END=192.168.0.200 \
    -e ROUTERS=192.168.0.1 \
    -e DOMAIN_NAME_SERVERS="8.8.8.8, 8.8.4.4" \
    3x3cut0r/isc-dhcp-server:latest
```

**Example 3 - IPV6 - run with custom dhcpd.conf**  
**Note: IFACE have to fit with your host-interface !!!**

```shell
docker run -d \
    --name isc-dhcp-server \
    --network=host \
    -e TZ="Europe/Berlin" \
    -e IFACE=eth0 \
    -e PROTOCOL=6 \
    -v /path/to/your/dhcpd.conf:/etc/dhcp/dhcpd.conf:ro \
    3x3cut0r/isc-dhcp-server:latest
```

**Example 4 - IPV6 - run with specified environment variables**  
**Note: IFACE+SUBNET6 have to fit with your host-interface !!!**

```shell
docker run -d \
    --name isc-dhcp-server \
    --network=host \
    -e TZ="Europe/Berlin" \
    -e IFACE=eth0 \
    -e PROTOCOL=6 \
    -e SUBNET6="fe80::0/64" \
    -e RANGE6_BEGIN="fe80::1" \
    -e RANGE6_END="fe80::ffff" \
    -e DHCP6_NAME_SERVERS="2001:4860:4860::8888, 2001:4860:4860::8844" \
    3x3cut0r/isc-dhcp-server:latest
```

### docker-compose.yaml <a name="docker-compose"></a>

```shell
version: '3'

services:
  isc-dhcp-server:
    network_mode: host
    environment:
        TZ: Europe/Berlin
        IFACE: eth0
        PROTOCOL: 4
    volumes:
        - /path/to/your/dhcpd.conf:/etc/dhcp/dhcpd.conf
    image: 3x3cut0r/isc-dhcp-server:latest

```

### Environment Variables <a name="environment-variables"></a>

**for more information, see https://manpages.debian.org/jessie/isc-dhcp-server/dhcpd.8.en.html**

**dhcpd Environment Variables**

- `IFACE` - Interface to listen on. **Have to fit with your host-interface! Default: eth0**
- `PROTOCOL` - IP Protocol. (IPv4=4, IPv6=6) **Default: 4**
- `QUIET` - Be quiet at startup. **Default: 0**
- `TZ` - Specifies the server timezone - **Default: UTC**

**Global dhcpd.conf Environment Variables**

- `DEFAULT_LEASE_TIME` - **Default: 3600**
- `MAX_LEASE_TIME` - **Default: 86400**
- `AUTHORITATIVE` - **Default: 1**
- `LOGFACILITY` - **Default: local7**

**IPv4 Environment Variables (PROTOCOL=4)**

- `SUBNET` - Network-Address. e.g.: `192.168.0.0`
- `NETMASK` - Subnet-Mask. e.g.: `255.255.255.0`
- `RANGE_BEGIN` - Subnet-Range (first host). e.g.: `192.168.0.10`
- `RANGE_END` - Subnet-Range (last host). e.g.: `192.168.0.200`
- `BROADCAST` - Broadcast-Address. e.g.: `192.168.0.255`
- `ROUTERS` - Gateway. e.g.: `192.168.0.1`
- `DOMAIN_NAME` - Domain-Name. e.g.: `domain.example`
- `DOMAIN_NAME_SERVERS` - DNS-Servers (up to 3). e.g.: `8.8.8.8,8.8.4.4` (avoid using spaces!)
- `DOMAIN_SEARCH` - Search-List of Domains (up to 3). e.g.: `example.com,sales.example.com` (avoid using spaces!)
- `NEXT_SERVER` - Next-Server (for PXE/TFTP-Boot). e.g.: `192.168.0.1`
- `TFTP_SERVER_NAME` - TFTP-Server (for PXE/TFTP-Boot). e.g.: `192.168.0.1`
- `BOOTFILE_NAME` - Bootfile-Name (for PXE/TFTP-Boot). e.g.: `bootcode.bin`
- `NTP_SERVERS` - NTP-Servers (up to 3). e.g.: `0.de.pool.ntp.org,1.de.pool.ntp.org` (avoid using spaces!)
- `ROOT_PATH` - Root-Path. e.g. NFS-Root-Path: `192.168.0.1:/nfs/client1`
- `VENDOR_ENCAPSULATED_OPTIONS` - String of vendor-specific information. e.g.: `Raspberry Pi Boot`

**IPv6 Environment Variables (PROTOCOL=6)**

- `SUBNET6` - Network-Address. e.g.: `fe80::0/64`
- `RANGE6_BEGIN` - Subnet-Range (first host). e.g.: `fe80::1`
- `RANGE6_END` - Subnet-Range (last host). e.g.: `fe80::ffff`
- `DHCP6_NAME_SERVERS` - DNS-Servers (up to 3). e.g.: `2001:4860:4860::8888,2001:4860:4860::8844` (avoid using spaces!)
- `DHCP6_DOMAIN_SEARCH` - Domain-Name. e.g.: `domain.example`
- `PREFIX6` - IPv6 Subnet-Deligation-Mask e.g.: `fe80:1:2:3:: fe80:1:2:f:: /60`

### Volumes <a name="volumes"></a>

- `/etc/dhcp/dhcpd.conf` - DHCP-Server configuration file - **recommended, otherwise configure your dhcp-server via environment variables**

### Ports <a name="ports"></a>

- No need for Port-Bindings because you need to specify network=host!

## Find Me <a name="findme"></a>

![E-Mail](https://img.shields.io/badge/E--Mail-julianreith%40gmx.de-red)

- [GitHub](https://github.com/3x3cut0r)
- [DockerHub](https://hub.docker.com/u/3x3cut0r)

## License <a name="license"></a>

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) - This project is licensed under the GNU General Public License - see the [gpl-3.0](https://www.gnu.org/licenses/gpl-3.0.en.html) for details.
