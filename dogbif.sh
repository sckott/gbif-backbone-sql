sqlite3 gbif.sqlite < schema.sql
echo ".mode tabs\n.header off\n.import taxon.txt gbif" |  sqlite3 gbif.sqlite
echo "\nall done!"
