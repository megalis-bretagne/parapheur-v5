#!/bin/sh

rm -rf ./data
mkdir -p data/alfresco
mkdir -p data/solr/data
mkdir -p data/solr/contentstore
mkdir -p data/vault/data
chmod -R 777 data
