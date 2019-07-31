sqlite3 gbif.sqlite < schema.sql
echo "removing any quotes in Taxon.tsv"
sed -i 's/\"//g' Taxon.tsv
echo '.mode tabs\n.separator "\\t"\n.header off\n.import Taxon.tsv gbif' | sqlite3 gbif.sqlite
echo "CREATE UNIQUE INDEX id on gbif (taxonID);" | sqlite3 gbif.sqlite
echo "\nall done!"
