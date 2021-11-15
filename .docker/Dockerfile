FROM php:8.0-fpm-buster

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql

RUN apt update \
    && apt install -y -q --no-install-recommends \
    bash \
    git \
    nano \
    nginx \
    unzip \
    wget \
    zip \
    zsh

# Install oh-my-zsh
RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Get NVM & Install node
RUN mkdir -p /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.18.0

RUN curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

WORKDIR /var/www/statamic

COPY ./setup.sh /setup.sh
RUN chmod +x /setup.sh

# Forward access & error log to Docker log corrector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 8000

# Fixing stop signals
STOPSIGNAL SIGQUIT

# Trigger the entrypoint script
ENTRYPOINT ["/setup.sh"]
CMD []
