APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=gcr.io/jstashk
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

install:
	go get

build: format install
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o jbot -ldflags "-X="github.com/jstashk/jbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
tag:
	docker tag ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} 	

clean:
	rm -rf jbot
	docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}