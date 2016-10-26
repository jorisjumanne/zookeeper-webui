FROM docker-registry.apps.ota.ose.rabobank.nl/openshift/s2i-oracle-java-dev-rhel:latest
MAINTAINER tobilg <fb.tools.github@gmail.com>

EXPOSE 8080

USER 0

ENV APP_PATH=/app \
    CONFIG_FILE=/app/zk-web/conf/zk-web-conf.clj \
    LEIN_ROOT=true

WORKDIR $APP_PATH
COPY *.sh .

RUN mkdir -p $APP_PATH && \
    yum install -y curl openssl && \
    curl -sSL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein >/usr/local/bin/lein && \
    curl -sSL https://github.com/qiuxiafei/zk-web/archive/master.zip |jar -xvf /dev/stdin && \
    ln -s zk-web-* zk-web && \
    chmod +x *.sh /usr/local/bin/lein && \
    cd zk-web && \
    lein deps && \
    cd .. && \
    rm -f $CONFIG_FILE && \
    chmod -R a+rwX .

COPY log4j.properties $APP_PATH/zk-web/conf/

USER 48

CMD ["./bootstrap.sh"]
