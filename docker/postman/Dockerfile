FROM alpine:3.15.4
RUN apk update && apk add --no-cache tzdata=2022a-r0 nodejs=16.14.2-r0 npm=8.1.3-r0 && npm install -g newman@5.3.2
ENV TZ America/Lima
ENTRYPOINT ["newman"]