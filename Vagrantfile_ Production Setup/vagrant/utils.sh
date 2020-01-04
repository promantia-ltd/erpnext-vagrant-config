#!/bin/bash

base_dir="/vagrant"
PROPERTY_FILE=vagrant.properties

getProperty() {
   PROP_KEY=$1
   PROP_VALUE=`cat $base_dir/$PROPERTY_FILE | grep "$PROP_KEY" | cut -d'=' -f2`
   echo ${PROP_VALUE:-$2}
}
if [ ! -f "$base_dir/$PROPERTY_FILE" ]; then echo "File $PROPERTY_FILE does not exist";exit 1 ; fi
