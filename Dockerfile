FROM golang:latest AS builder
WORKDIR /app

COPY *.mod ./
COPY *.sum ./
COPY *.go ./

ENV GOPROXY="direct"
#For corporative network only
ENV GOINSECURE="*.in,*.com,*.org"
ENV GONOSUMDB="*.in,*.com,*.org"
ENV GOOS=linux 
ENV GOARCH=amd64
#For corporative network only
RUN git config --global http.sslVerify false \ 
  && go mod download \
  && go build -o simple-app

FROM alpine:3.14  
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
WORKDIR /app
COPY --from=builder /app/simple-app .
EXPOSE 8000
CMD ["./simple-app"]  