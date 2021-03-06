FROM klokantech/tileserver-gl:v2.3.0

RUN set -x \
    && apt-get update \
    && apt-get install -y jq curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /config

ARG STYLES_ASSETS=https://github.com/Neo-Type/openmaptiles-styles/releases/download/v0.1.0/v0.1.0.tar.gz
RUN set -x \
    && curl -sL "${STYLES_ASSETS}" | tar -zxv

COPY config/config.json /config/config.json
COPY config/jq.sh /config/jq.sh
RUN /config/jq.sh

ARG MAP_TILES_VERSION=20180202
RUN mkdir -p /tiles \
    && curl -L https://github.com/Neo-Type/iOneMySgMap/releases/download/${MAP_TILES_VERSION}/singapore.mbtiles -o /tiles/singapore.mbtiles

EXPOSE 8080
RUN sed -e 's@ 80 @ 8080 @' -i /usr/src/app/run.sh

ENTRYPOINT []
CMD ["/usr/src/app/run.sh", "--config=/config/config.json"]
