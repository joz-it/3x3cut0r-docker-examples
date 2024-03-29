# pyload

**pyload from writl/pyload with python-openssl for SSL/HTTPS support**

![Docker Image Version (latest by date)](https://img.shields.io/docker/v/3x3cut0r/pyload)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/3x3cut0r/pyload)
![Docker Pulls](https://img.shields.io/docker/pulls/3x3cut0r/pyload)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/3x3cut0r/docker/pyload.yml?branch=main)

`GitHub` - 3x3cut0r/pyload - https://github.com/3x3cut0r/docker/tree/main/pyload  
`DockerHub` - 3x3cut0r/pyload - https://hub.docker.com/r/3x3cut0r/pyload

## Documentation

`GitHub (source code)` - pyload/pyload - https://github.com/pyload/pyload

`GitHub` - writl/pyload - https://github.com/obi12341/docker-pyload  
`DockerHub` - writl/pyload - https://hub.docker.com/r/writl/pyload

## Usage for Synology Users

**locations to your SSL certificates**  
`ssl.crt` - /usr/syno/etc/certificate/system/default/cert.pem  
`ssl.key` - /usr/syno/etc/certificate/system/default/privkey.pem

### docker run

```shell
docker container run -d --restart=unless-stopped \
    --name=pyload \
    -e UID=1024 \
    -e GID=100 \
    -p 8000:8000 \
    -v /volume1/docker/pyload:/opt/pyload/pyload-config:rw \
    -v /volume1/downloads:/opt/pyload/Downloads:rw \
    -v /usr/syno/etc/certificate/system/default/cert.pem:/opt/pyload/pyload-config/ssl.crt:ro \
    -v /usr/syno/etc/certificate/system/default/privkey.pem:/opt/pyload/pyload-config/ssl.key:ro \
    3x3cut0r/pyload:latest
```

## Find Me <a name="findme"></a>

![E-Mail](https://img.shields.io/badge/E--Mail-julianreith%40gmx.de-red)

- [GitHub](https://github.com/3x3cut0r)
- [DockerHub](https://hub.docker.com/u/3x3cut0r)
