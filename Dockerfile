FROM golang:1.21 as build

WORKDIR /src
COPY . .
RUN go build -o ./bin/go-transip-dyndns

FROM alpine:latest
COPY --from=build /src/bin/go-transip-dyndns /usr/bin/go-transip-dyndns
COPY --from=build /src/go-transip-dyndns.toml /go-transip-dyndns.toml
COPY ./start /usr/local/bin/start
RUN chmod 775 /usr/local/bin/start

RUN apk add --no-cache tzdata
RUN apk add --no-cache libc6-compat

# Run the cron every minute
RUN echo '*  *  *  *  *    /usr/local/bin/start' > /etc/crontabs/root

CMD ["crond", "-f"]