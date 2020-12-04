FROM mysql:5.7.31

RUN touch /var/log/mysql/mysqld.log

RUN apt-get update && \
    apt-get install -y --no-install-recommends vim \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*
