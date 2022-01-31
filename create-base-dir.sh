#!/bin/sh

mkdir -p data/alfresco
mkdir -p data/solr/data
mkdir -p data/solr/contentstore
mkdir -p data/matomo/config
mkdir -p data/matomo/plugins
mkdir -p data/pes-viewer/pesPJ
mkdir -p data/transfer/data
mkdir -p data/vault/data
mkdir -p data/feeder/data
mkdir -p data/feeder/data/in
mkdir -p data/feeder/data/out


sudo chown 6789:6789 data/feeder/data
