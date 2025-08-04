#
# Rundeck server Dockerfile
#
# https://github.com/
#

# Pull base image.
FROM debian:latest

LABEL org.opencontainers.image.authors="hihouhou < hihouhou@hihouhou.com >"

ENV RUNDECK_VERSION=v5.14.0

# Update & install packages for rundeck
RUN apt-get update && \
    apt-get install -y curl gnupg

RUN curl -L https://packages.rundeck.com/pagerduty/rundeck/gpgkey | apt-key add -
COPY rundeck.list /etc/apt/sources.list.d/rundeck.list

RUN apt-get update && \
    apt-get install -y rundeck

RUN usermod -u 1000 rundeck

COPY rundeck-config.properties /var/lib/rundeck/bootstrap/server/config/rundeck-config.properties

RUN chown -R rundeck: /var/lib/rundeck

USER rundeck

RUN PLAIN_VERSION=$(echo ${RUNDECK_VERSION} | sed 's/^v//') && \
    WAR_FILE=$(find /var/lib/rundeck/bootstrap/ -name "rundeck*${PLAIN_VERSION}*.war") && \
    ln -s $WAR_FILE /var/lib/rundeck/bootstrap/rundeck.war

WORKDIR /var/lib/rundeck

CMD ["java", "-jar", "/var/lib/rundeck/bootstrap/rundeck.war"]
