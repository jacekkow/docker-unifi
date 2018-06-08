# UniFi

This is a Docker image of UniFi controller
based on `openjdk:8-jre-slim`

## Tags

Container is created for each stable UniFi release and tagged as vX.X.X.
`:latest` tag is for latest 5.6 LTS release.
`:v5.7` tag is for latest 5.7 release.

## Usage

```bash
docker run -d --name=unifi \
	-p 8080:8080 -p 8443:8443 \
	jacekkow/unifi
```

UniFi interface should be available at https://127.0.0.1:8443/
(first run wizard is opened if the instance is unconfigured).

By default it uses Docker data volume for persistence.

You can update such installation by passing `--volumes-from` option
to `docker run`:

```bash
docker pull jacekkow/unifi
docker stop unifi
docker rename unifi unifi-old
docker run -d --name=unifi \
	-p 8080:8080 -p 8443:8443 \
	--volumes-from unifi-old \
	jacekkow/unifi
docker rm -v unifi-old
```

### Local storage

If you prefer to have direct access to container's data
from the host, you can use local storage instead of data volumes:

```bash
docker run -d --name=unifi \
	-p 8080:8080 -p 8443:8443 \
	-v /srv/unifi/data:/usr/lib/unifi/data \
	--user root \
	jacekkow/unifi
```

`/srv/unifi/data` directory will be automatically populated
with default configuration if necessary.

File ownership is recursively changed to `unifi:unifi` (`500:500`)
on each start, provided the container is run as root
(don't worry - unifi user will be used to start UniFi).

### Captive portal and STUN

Using captive portal requires forwarding of additional ports
(8880 and 8843):

```bash
docker run -d --name=unifi \
	-p 8080:8080 -p 8443:8443 \
	-p 8880:8880 -p 8843:8843 \
	jacekkow/unifi
```

For STUN (NAT traversal) UDP port 3478 must be available:

```bash
docker run -d --name=unifi \
	-p 8080:8080 -p 8443:8443 \
	-p 3478:3478/udp \
	jacekkow/unifi
```

Note that STUN was not tested in container-based environment!
This port is also not exposed in Dockerfile.

### Configuration

You can configure the instance by editing files 
in directory /usr/lib/unifi/data inside the container
(or appropriate host dir if local storage is used).

By default the JVM is started with option `-Xmx1024m`.
You can override this default using `JAVA_OPTS` environment
variable:

```bash
docker run -d --name=unifi \
	-p 8080:8080 -p 8443:8443 \
	-e "JAVA_OPTS=-Xmx512m" \
	jacekkow/unifi
```
