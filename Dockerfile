ARG HUGO_VERSION=0.68.3

FROM acend/hugo:${HUGO_VERSION} AS builder

EXPOSE 8080

# add git - required for Hugo GitInfo
RUN apk add git && rm -rf /var/cache/apk/*

RUN mkdir -p /opt/app/src/static && \
    chmod -R og+rwx /opt/app

WORKDIR /opt/app/src

ARG HUGO_BASE_URL
ENV HUGO_BASE_URL $HUGO_BASE_URL

COPY . /opt/app/src

RUN hugo --baseURL=${HUGO_BASE_URL:-http://localhost/} \
  --theme ${HUGO_THEME:-dot} --minify

FROM nginxinc/nginx-unprivileged:alpine

COPY --from=builder  /opt/app/src/public /usr/share/nginx/html
