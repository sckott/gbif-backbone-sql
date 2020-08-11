require 'aws-sdk'
require 'faraday'
require 'sqlite3'
require 'date'
require 'zip'
require_relative 'sql'

Aws.config.update({
  region: 'us-west-2',
  credentials: Aws::Credentials.new(ENV['AWS_S3_WRITE_ACCESS_KEY'], ENV['AWS_S3_WRITE_SECRET_KEY'])
})
$s3 = Aws::S3::Client.new

$backbone_zip = 'https://hosted-datasets.gbif.org/datasets/backbone/backbone-current.zip'

module Backbone

	def self.fetch
		puts 'fetching/unzipping backbone from GBIF servers'
		fetch_backbone()
		unzip_backbone()
	end

	def self.sql
		puts 'creating SQLite database, and loading GBIF taxonomic backbone'
		system('sh dogbif.sh')
	end

	def self.zip
		puts 'zipping sqlite db file into a zip file'
		zip_up()
	end
	
	def self.s3
		puts 'uploading SQLite database to Amazon S3'
		to_s3()
	end

	def self.spine
		if is_backbone_new?
			puts 'new backbone, updating'
			fetch_backbone()
			unzip_backbone()
			system('sh dogbif.sh')
			zip_up()
			to_s3()
			clean_up()
		else
			puts 'backbone is old, not updating'
		end
	end

	def self.clean
		clean_up()
	end

end

def is_backbone_new?
	# initialize Faraday connection object
	conn = Faraday.new do |x|
	  x.adapter Faraday.default_adapter
	end

	# check last-modified header
	res = conn.head $backbone_zip;
	lm = DateTime.parse(res.headers['date']).to_time

	# file last modified
	begin
		fm = File.stat("backbone-current.zip").mtime
	rescue Exception => e
		fm = nil
	end

	if fm.nil?
		return true
	end

	# return boolean
	return lm > fm
end

def fetch_backbone
	if !File.exist?('backbone-current.zip')
		# initialize Faraday connection object
		conn = Faraday.new do |x|
		  x.adapter Faraday.default_adapter
		end

		# get zip file
		## FIXME - this GET request takes a long time
		res = conn.get $backbone_zip;

		# write zip file to disk
		File.open('backbone-current.zip', 'wb') { |fp| fp.write(res.body) }
	else
		puts "'backbone-current.zip' found, skipping download"
	end
end

def unzip_backbone
	Zip::File.open('backbone-current.zip') do |zip_file|
	  zip_file.glob("Taxon.tsv") do |f|
			begin
				zip_file.extract(f, f.name) unless File.exist?(f.name)
			end
	  end
	end
end

def zip_up
	Zip::File.open('gbif.zip', Zip::File::CREATE) do |zip|
	  zip.add("gbif.sqlite", "gbif.sqlite")
	end
end

def to_s3
	File.open("gbif.zip", 'rb') do |f|
  		$s3.put_object(bucket: 'taxize-dbs', key: 'gbif.zip', body: f)
	end
end

def clean_up
	files_to_clean = ["Taxon.tsv", "backbone-current.zip", "gbif.sqlite", "gbif.zip"]
	files_to_clean.each { |x| File.unlink(x) unless !File.exists?(x) }
end
