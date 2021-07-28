FROM golang

WORKDIR $GOPATH/src

RUN mkdir my-app

COPY go.mod my-app/go.mod
COPY main.go my-app/main.go

WORKDIR $GOPATH/src/my-app

RUN go mod tidy
RUN go install main.go

EXPOSE 8080

CMD ["main"]
