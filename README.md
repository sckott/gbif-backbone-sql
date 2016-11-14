gbif-backbone-sql
=================

gbif backbone taxonomy as SQLite DB

## how we do

* download GBIF backbone taxonomy from <http://www.gbif.org/dataset/d7dddbf4-2cf0-4f39-9b2a-bb099caae36c> as Darwin Core Archive
* unzip
* create sqlite DB `gbif.sqlite`
* import `taxon.txt` into sqlite DB
* upload `gbif.sqlite` to Amazon S3
* exit

## Backbone as sqlite

<https://s3-us-west-2.amazonaws.com/gbif-backbone/gbif.sqlite>

## info

* GBIF backbone taxonomy citation:

> GBIF Secretariat: GBIF Backbone Taxonomy. doi:10.15468/39omei
Accessed via http://www.gbif.org/dataset/d7dddbf4-2cf0-4f39-9b2a-bb099caae36c on 2016-08-16

* GBIF backbone taxonomy license: `CC BY 3.0`

## note to self

* `aws-sdk` docs <http://docs.aws.amazon.com/sdkforruby/api/Aws.html>
