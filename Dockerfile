FROM alpine

RUN apk add --no-cache sudo
ARG USERNAME=alpinedev
RUN adduser --gecos "$USERNAME" \
    --disabled-password \
    --shell /bin/sh \
    --uid 10001 \
    ${USERNAME} && \
    echo "$USERNAME:1234" | chpasswd && \
    echo "$USERNAME ALL=(ALL) ALL" > /etc/sudoers.d/$USERNAME && chmod 0440 /etc/sudoers.d/$USERNAME

# creates a group: docker with gid:1001
RUN addgroup --gid 1001 docker

# add user:alpinedev to ["docker","alpinedev","wheel"] groups
RUN addgroup ${USERNAME} docker
RUN addgroup ${USERNAME} wheel
RUN addgroup ${USERNAME} ${USERNAME}

USER ${USERNAME}
EXPOSE 1234
WORKDIR /app
COPY gows /app/
COPY report_thread /app/
CMD [ "/app/gows" ]
