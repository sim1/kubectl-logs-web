FROM node:alpine

ENV FRONTAIL_VERSION="4.9.2" \
    STERN_VERSION="1.11.0"
RUN yarn global add frontail@${FRONTAIL_VERSION} && \
    apk add --virtual=.run-deps tini bash && \
    wget -O /usr/local/bin/stern "https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64" && \
    chmod +x /usr/local/bin/stern

ENV STERN_ARGS="." \
    FRONTAIL_DEFAULT_ARGS="- -p 80 --disable-usage-stats" \
    FRONTAIL_ARGS="-t dark"
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["bash", "-c", "stern ${STERN_ARGS} 2>&1 | frontail ${FRONTAIL_DEFAULT_ARGS} ${FRONTAIL_ARGS}"]
