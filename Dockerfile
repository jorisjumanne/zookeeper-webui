FROM docker-registry.apps.ota.ose.rabobank.nl/openshift/s2i-oracle-java-dev-rhel:latest
MAINTAINER tobilg <fb.tools.github@gmail.com>

USER 0

ENV APP_PATH    /app \
    CONFIG_FILE $APP_PATH/zk-web/conf/zk-web-conf.clj \
    LEIN_ROOT   true

WORKDIR $APP_PATH
COPY *.sh .

RUN mkdir -p $APP_PATH && \
    yum install -y curl openssl && \
    curl -sSL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein >/usr/local/bin/lein && \
    curl -sSL https://github.com/qiuxiafei/zk-web/archive/v1.0.zip |jar -xvf /dev/stdin && \
    ln -s zk-web-* zk-web && \
    chmod a+rwX . && \
    chmod +x *.sh /usr/local/bin/lein && \
    cd zk-web && \
    lein deps && \
    cd .. && \
    rm -f /app/zk-web/conf/zk-web-conf.clj

USER 48

CMD ["./bootstrap.sh"]
