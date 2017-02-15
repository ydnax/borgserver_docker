FROM alpine:latest
MAINTAINER ydnax
#Install Borg & SSH
VOLUME ["/data", "/config"]
RUN apk add openssh borgbackup supervisor --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/
RUN adduser -D -u 1000 -h /config/ borg && \
    passwd -u borg && \
    ssh-keygen -A && \
    chown -R borg.borg /data && \
    sed -i \
        -e 's/^#PasswordAuthentication yes$/PasswordAuthentication no/g' \
        -e 's/^PermitRootLogin without-password$/PermitRootLogin no/g' \
        /etc/ssh/sshd_config && \
    mkdir -p /config/.ssh && \
    touch /config/.ssh/authorized_keys && \
    chown -R borg.borg /data
COPY supervisord.conf /etc/supervisord.conf
EXPOSE 22
CMD ["/usr/bin/supervisord"]
