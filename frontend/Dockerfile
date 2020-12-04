FROM node:14.15.1

RUN apt-get update && \
    apt-get install -y --no-install-recommends vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV APP_ROOT /app/frontend
RUN mkdir -p /app/frontend
WORKDIR $APP_ROOT

RUN npm install -g @vue/cli@4.5.9

ENTRYPOINT []
