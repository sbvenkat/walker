FROM debian:latest
COPY valsink.deb /tmp/
RUN apt-get update && \
    apt-get install -y supervisor
RUN dpkg -i /tmp/valsink.deb && \
    cp /opt/valsink/cfg/*.supervisor.conf /etc/supervisor/conf.d/
CMD ["/usr/bin/supervisord"]
