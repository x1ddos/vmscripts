#!/bin/bash

BASE_DIR=/apps
APP_NAME=$1
APP_DIR=$BASE_DIR/$APP_NAME
APP_SCRIPT=$APP_DIR/server.js

META_URL=http://metadata/computeMetadata/v1/instance/attributes

function get_meta {
    v=$(curl -f -s -H 'Metadata-Flavor: Google' $META_URL/$1)
    echo $v
}


if [ ! -d $APP_DIR ]; then
    echo "App dir $APP_DIR does not exist."
    exit 1
fi

pushd $APP_DIR
git reset --hard origin/master && git pull
npm install
forever stop --plain $APP_SCRIPT
forever start --plain $APP_SCRIPT
popd
