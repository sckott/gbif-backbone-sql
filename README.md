gbif-backbone-sql
=================

gbif backbone taxonomy as SQLite DB

__Note:__ The backbone as sqlite is up at <https://s3-us-west-2.amazonaws.com/gbif-backbone/gbif.sqlite> -
You can continue reading if you want to know the details of how it got there, and/or if you want to
run this darwin-core to sql conversion yourself.

## how we do

* download GBIF backbone taxonomy from <http://www.gbif.org/dataset/d7dddbf4-2cf0-4f39-9b2a-bb099caae36c> as Darwin Core Archive
* unzip
* create sqlite DB `gbif.sqlite`
* import `taxon.txt` into sqlite DB
* upload `gbif.sqlite` to Amazon S3
* exit

## Usage

download

```
git clone https://github.com/ropensci/gbif-backbone-sql.git
cd gbif-backbone-sql
```

bundle it

```
bundle install
```

```
rake --tasks
```

```
rake fetch  # get and unzip backbone
rake s3     # upload database to s3
rake spine  # get backbone, convert to sql, upload to amazon s3
rake sql    # create sql database
```

`rake spine` does all the things

Or, you can do each separately with `rake fetch` then `rake sql`, then `rake s3`

### Env vars

`rake s3` requires AWS keys. If you want to upload to AWS, make sure you have env vars
with the names `AWS_S3_WRITE_ACCESS_KEY` and `AWS_S3_WRITE_SECRET_KEY`

## Backbone as sqlite

<https://s3-us-west-2.amazonaws.com/gbif-backbone/gbif.sqlite>

## info

* GBIF backbone taxonomy citation:

> GBIF Secretariat: GBIF Backbone Taxonomy. doi:10.15468/39omei
Accessed via http://www.gbif.org/dataset/d7dddbf4-2cf0-4f39-9b2a-bb099caae36c on 2016-08-16

* GBIF backbone taxonomy license: `CC BY 3.0`

## note to self

* `aws-sdk` docs <http://docs.aws.amazon.com/sdkforruby/api/Aws.html>
