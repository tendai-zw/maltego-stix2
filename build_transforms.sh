#!/bin/bash

echo "Clear old results"
rm output/transforms.mtz 2> /dev/null
rm -R mtz/Servers/ mtz/TransformSets/ mtz/TransformSetsTDS/ mtz/TransformRepositories/ 2> /dev/null
find ./trx/gunicorn/transforms -name 'stix2*' -exec rm -f {} \; 2> /dev/null
mkdir mtz/ 2> /dev/null
mkdir mtz/Servers/
mkdir mtz/TransformSets/
mkdir mtz/TransformSetsTDS/
mkdir mtz/TransformRepositories/
mkdir mtz/TransformRepositories/Local/
mkdir output/ 2> /dev/null

echo "Generate Maltego transforms config"
if [ $# -eq 0 ] ;
then
	python3 build-transforms.py transforms.csv
else
	python3 build-transforms.py transforms.csv --with-opencti
fi

echo "Create MTZ package"
cd mtz
zip -q -x .empty -r ../output/transforms.mtz ./Servers ./TransformRepositories ./TransformSets
cd ../

echo "All done. MTZ packages can be imported in Maltego and don't forget to copy ./trx/gunicorn/ at the execution path provided in the configuration."
