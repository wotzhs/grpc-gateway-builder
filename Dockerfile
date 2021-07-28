FROM golang:alpine AS base

ARG PROTO_VERSION=3.17.3
ARG PROTO_ZIP_FILE=protoc-${PROTO_VERSION}-linux-x86_64.zip
ARG PROTO_BIN_URL=https://github.com/protocolbuffers/protobuf/releases/download/v${PROTO_VERSION}/${PROTO_ZIP_FILE}
ARG GOOGLE_APIS_URL=https://github.com/googleapis/googleapis.git

RUN apk update && apk upgrade && apk add git
COPY tools.go ~/
WORKDIR ~/
RUN go mod init tmpmod && go mod tidy && go install \
	github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway \
	github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2 \
	google.golang.org/protobuf/cmd/protoc-gen-go \
	google.golang.org/grpc/cmd/protoc-gen-go-grpc

RUN wget $PROTO_BIN_URL && unzip $PROTO_ZIP_FILE -d protoc && mv protoc/include /usr/local
RUN git clone $GOOGLE_APIS_URL && mv googleapis/google/* /usr/local/include/google/

FROM golang:alpine
COPY --from=base /go/bin /go/bin
COPY --from=base /usr/local/include /usr/local/include
RUN apk update && apk upgrade && apk add make git protobuf
