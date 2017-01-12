FROM debian:jessie

ARG 3.1.1

ENV GF_PATHS_DATA=/var/lib/grafana
ENV GF_PATHS_LOGS=/var/log/grafana
ENV GF_PATHS_PLUGINS=/var/lib/grafana/plugins

RUN apt-get update && \
    apt-get -y --no-install-recommends install libfontconfig curl ca-certificates && \
    apt-get clean && \
    curl https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb > /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb && \
    curl -L https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 > /usr/sbin/gosu && \
    chmod +x /usr/sbin/gosu && \
    apt-get remove -y curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    chown -R grafana:0 "$GF_PATHS_DATA" "$GF_PATHS_LOGS" && \
    chown -R grafana:0 /etc/grafana

VOLUME ["$GF_PATHS_DATA", "$GF_PATHS_LOGS", "/etc/grafana"]

EXPOSE 3000

COPY ./run.sh /run.sh

ENTRYPOINT ["/run.sh"]
