# gRPC Gateway Builder

```bash
docker pull wotzhs/grpc-gateway-builder
```

This repo contains the Dockerfile to build the alpine based builder image for [grpc-gateway](https://github.com/grpc-ecosystem/grpc-gateway) to maximise the efficiency of gRPC application compilation.  

The following common tool are also included:

- `make` 
- `git`
- `protobuf`
- `googleapis`
- google well known types proto
- [`grpc_health_probe`](https://github.com/grpc-ecosystem/grpc-health-probe)
- [`gomock`](https://github.com/golang/mock)
- `jq` - for merging swagger.json

The docker image will have the following updated on a daily basis to ensure the latest version is used:

- `grpc-gateway` tooling
- `googleapis`
