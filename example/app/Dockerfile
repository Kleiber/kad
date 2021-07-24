FROM golang

WORKDIR $GOPATH/src

RUN mkdir app

COPY go.mod app/go.mod
COPY main.go app/main.go

WORKDIR $GOPATH/src/app

RUN go mod tidy
RUN go install main.go

EXPOSE 8080

CMD ["main"]
