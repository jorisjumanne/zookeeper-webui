FROM 192.168.173.195:5000/openshift/s2i-oracle-java-dev-rhel:latest
MAINTAINER tobilg <fb.tools.github@gmail.com>

USER 0

ENV APP_PATH    /app \
    CONFIG_FILE $APP_PATH/zk-web/conf/zk-web-conf.clj \
    LEIN_ROOT   true

COPY *.sh .

RUN mkdir -p $APP_PATH \
    yum install -y curl openssl \
    curl -sSL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein >/usr/local/bin/lein \
    curl -sSL https://github.com/qiuxiafei/zk-web/archive/v1.0.zip |jar -C $APP_PATH -xvf /dev/stdin \
    chmod a+rwX $APP_PATH \
    chmod +x *.sh \
    cd $APP_PATH/zk-web && \
    lein deps \
    rm $CONFIG_FILE

USER 48

CMD ["./bootstrap.sh"]
