#!/bin/bash

DOCKER_ENV=.docker/docker.env
STATAMIC_ENV=.env

main() {
    setup
    run
}

setup() {
    h1 'Preparing'

    task "Set environment"                  "task:env"
    task "Install composer dependencies"    "task:composer"
    task "Install npm dependencies"         "task:npm"
    task "Setting up statamic"              "task:statamic"

    success 'Statamic is ready'
}

run() {
    php-fpm -d listen=localhost:9000 &  # Start php-fpm
    nginx -g "daemon off;" &            # Start nginx

#    NOTE: We could use artisan serve without the need for nginx
#    php artisan serve --host 0.0.0.0 --port 8000
}

task:env() {
    if [ ! -f $DOCKER_ENV ]; then
        failure "${DOCKER_ENV} not found"
    fi

    cp $DOCKER_ENV $STATAMIC_ENV
}

task:statamic() {
    subtask 'Generating application key'
    php artisan key:generate --quiet

    subtask 'Run the database migrations'
    php artisan migrate --quiet

    subtask 'Create super user'
    php artisan db:seed --class=SuperUserSeeder
}

task:composer() {
    composer install --no-ansi &>.docker/logs/composer.log
}

task:npm() {
    npm i --inclue=dev --silent &>.docker/logs/npm.log
    npm run build
}

##############################################################
# Messages helper                                            #
##############################################################
h1() { echo "################## ${1} ##################"; }

success() { echo "✨ ${1}"; }
failure() { echo "🛑 ${1}" & exit; }

task() {
    printf "\E[?25l"

    CL="\e[2K"

    printf "${CL}⠿ %s\n" "$1";

    $2 & while :; do
        jobs %1 > /dev/null 2>&1
        [ $? = 0 ] || {
            printf "${CL}✔ %s\n" "Done";
            break
        }
    done

    printf "\E[?12l\E[?25h"
}

subtask() {
    printf "${CL}  - %s\n" "$1";
}

main
