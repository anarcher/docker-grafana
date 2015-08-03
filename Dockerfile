FROM golang:1.4.2

WORKDIR /go/src/github.com/grafana/

RUN apt-get -y install git

# Node JS
RUN curl -sL https://deb.nodesource.com/setup_0.10 | bash -
RUN apt-get -y install nodejs
RUN apt-get -y install bzip2 libfreetype6 libfontconfig 
RUN npm install -g grunt-cli

RUN mkdir -p /go/src/github.com/grafana/
RUN git clone  -b feature/disable-keepalives https://github.com/anarcher/grafana.git

WORKDIR /go/src/github.com/grafana/grafana/

RUN go run build.go setup
RUN godep restore

RUN npm install
RUN go run build.go build
RUN grunt release

RUN cd dist/ ; tar xzvf grafana-2.1.0-pre1.linux-x64.tar.gz
RUN cp dist/grafana-*.tar.gz /opt/
RUN cd /opt/ ; tar xzvf grafana*.tar.gz 

WORKDIR /opt/grafana-2.1.0-pre1/
CMD ["/opt/grafana-2.1.0-pre1/bin/grafana-server"]

