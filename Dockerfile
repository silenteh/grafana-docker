FROM debian:jessie

RUN apt-get update && \
    apt-get -y --no-install-recommends install libfontconfig curl ca-certificates && \
    apt-get clean && \
    # curl https://grafanarel.s3.amazonaws.com/builds/grafana_3.1.1-1470047149_amd64.deb > /tmp/grafana.deb && \
    curl https://grafanarel.s3.amazonaws.com/builds/grafana_4.1.1-1484211277_amd64.deb > /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb && \
    curl -L https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 > /usr/sbin/gosu && \
    chmod +x /usr/sbin/gosu && \
    apt-get remove -y curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    chown -R grafana:0 /var/lib/grafana /var/log/grafana && \
    chown -R grafana:0 /etc/grafana && \
    chown -R grafana:0 /usr/share/grafana

VOLUME ["/var/lib/grafana", /var/log/grafana, "/etc/grafana"]

EXPOSE 3000

COPY ./run.sh /run.sh

USER grafana

ENTRYPOINT ["/run.sh"]
