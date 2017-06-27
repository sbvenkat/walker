FROM debian:latest
RUN apt-get update && apt-get install -y \
	supervisor
COPY {app_name}.deb /tmp/
RUN dpkg -i /tmp/app_name.deb && \
    cp /opt/{app_name}/cfg/*.supervisor.conf /etc/supervisor/conf.d/
CMD ["/usr/bin/supervisord"]
