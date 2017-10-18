#!/bin/bash

if [ -z "$JAVA_OPTS" ]; then
	JAVA_OPTS="-Xmx1024m"
fi

if [ `id -u` -eq 0 ]; then
	chown -Rf unifi:unifi /usr/lib/unifi/data

	exec sudo -u unifi java $JAVA_OPTS -jar /usr/lib/unifi/lib/ace.jar start
else
	exec java $JAVA_OPTS -jar /usr/lib/unifi/lib/ace.jar start
fi
