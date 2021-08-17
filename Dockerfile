FROM golang:alpine3.13 AS base

ARG PROTO_VERSION=3.17.3
ARG PROTO_ZIP_FILE=protoc-${PROTO_VERSION}-linux-x86_64.zip
ARG PROTO_BIN_URL=https://github.com/protocolbuffers/protobuf/releases/download/v${PROTO_VERSION}/${PROTO_ZIP_FILE}
ARG GOOGLE_APIS_URL=https://github.com/googleapis/googleapis.git
ARG GRPC_GATEWAY_REPO_URL=https://github.com/grpc-ecosystem/grpc-gateway.git

RUN apk update && apk upgrade && apk add git
COPY tools.go /home
WORKDIR /home
RUN go mod init tmpmod && go mod tidy && go install \
	github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway \
	github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2 \
	google.golang.org/protobuf/cmd/protoc-gen-go \
	google.golang.org/grpc/cmd/protoc-gen-go-grpc

RUN go install github.com/golang/mock/mockgen@v1.6.0

RUN wget $PROTO_BIN_URL && unzip $PROTO_ZIP_FILE -d protoc && mv protoc/include /usr/local
RUN git clone $GOOGLE_APIS_URL && mv googleapis/google/* /usr/local/include/google/
RUN git clone $GRPC_GATEWAY_REPO_URL && \
	mkdir -p /usr/local/include/protoc-gen-openapiv2 && \
	find grpc-gateway/protoc-gen-openapiv2/options/ -type f -not -name '*.proto' -delete && \
	mv grpc-gateway/protoc-gen-openapiv2/options /usr/local/include/protoc-gen-openapiv2

RUN wget https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/v0.4.4/grpc_health_probe-linux-amd64 && \
	chmod +x grpc_health_probe-linux-amd64

FROM golang:alpine3.13
COPY --from=base /go/bin /go/bin
COPY --from=base /usr/local/include /usr/local/include
COPY --from=base /home/grpc_health_probe-linux-amd64 /go/bin/grpc_health_probe
RUN apk update && apk upgrade && apk add make git protobuf
