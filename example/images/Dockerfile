FROM golang

COPY ../app $GOPATH/src/app

WORKDIR $GOPATH/src/app

RUN go mod verdor

RUN go install main.go

EXPOSE 8080

CMD ["main"]