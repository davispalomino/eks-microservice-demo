FROM alpine:3.15
RUN apk add --no-cache python3 py3-pip && ln -sf /usr/bin/python3 /usr/bin/python && ln -sf /usr/bin/pip3 /usr/bin/pip && pip install pylint
COPY docker/pylint /etc
WORKDIR app
RUN chmod +x /etc/init.sh
CMD ["sh", "/etc/init.sh"]