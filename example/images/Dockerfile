FROM golang

COPY ../app $GOPATH/src/app

WORKDIR $GOPATH/src/app

RUN go mod

RUN go install main.go

EXPOSE 8080

CMD ["main"]