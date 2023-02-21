ARG BASE_IMG_TAG=nonroot 

FROM golang:1.18-bullseye as build

WORKDIR /keytom
COPY . /keytom

RUN make build

## Deploy image
FROM gcr.io/distroless/base-debian11:${BASE_IMG_TAG} 

COPY --from=build /keytom/build/keytomd /bin/keytomd

ENV HOME /
WORKDIR $HOME

EXPOSE 26656 
EXPOSE 26657
EXPOSE 1317

ENTRYPOINT ["keytomd"]
CMD [ "start" ]