### source build ###
FROM golang:1.10 as build

WORKDIR /src

RUN set -ex ;\
    mkdir /src;\
    git clone https://github.com/bitly/oauth2_proxy.git;\
    git checkout $(git describe --abbrev=0);\
    go get -d -v -t;\
    CGO_ENABLED=0 GOOS=linux go build -v -o /files/usr/local/bin/oauth2_proxy

### runtime build ###
FROM scratch

COPY --from=build /files /

EXPOSE 8080 4180

ENTRYPOINT [ "/usr/local/bin/oauth2_proxy" ]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
