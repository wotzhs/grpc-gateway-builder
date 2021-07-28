FROM golang:alpine

ARG PROTO_VERSION=3.17.3
ARG PROTO_ZIP_FILE=protoc-${PROTO_VERSION}-linux-x86_64.zip
ARG PROTO_BIN_URL=https://github.com/protocolbuffers/protobuf/releases/download/v${PROTO_VERSION}/${PROTO_ZIP_FILE}
ARG GOOGLE_APIS_URL=https://github.com/googleapis/googleapis.git

RUN apk update && apk upgrade && apk add make git protobuf
RUN go get -u github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway
RUN go get -u github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2
RUN go get -u google.golang.org/protobuf/cmd/protoc-gen-go
RUN go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc

RUN wget $PROTO_BIN_URL && unzip $PROTO_ZIP_FILE -d protoc && mv protoc/include /usr/local
RUN git clone $GOOGLE_APIS_URL && mv googleapis/google/* /usr/local/include/google/
