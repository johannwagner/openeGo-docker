#!/bin/bash

set -e

psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
    CREATE DATABASE dataedit;
    CREATE DATABASE openego;
    CREATE DATABASE tests;
EOSQL

psql -d dataedit -c 'create extension hstore;'
psql -d dataedit -c 'create extension postgis;'
psql -d dataedit -c 'create extension postgis_topology;'

psql -d openego -c 'create extension hstore;'
psql -d openego -c 'create extension postgis;'
psql -d openego -c 'create extension postgis_topology'

psql -d tests -c 'create extension hstore;'
psql -d tests -c 'create extension postgis;'
psql -d tests -c 'create extension postgis_topology;'

psql -d dataedit -f /oedb_test.dump