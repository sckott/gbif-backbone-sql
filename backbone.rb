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

	def self.s3
		puts 'uploading SQLite database to Amazon S3'
		to_s3()
	end

	def self.spine
		if is_backbone_new?
			puts 'new backbone, updating'
			fetch_backbone()
			system('sh dogbif.sh')
			to_s3()
		else
			puts 'backbone is old, not updating'
		end
	end

end

def is_backbone_new?
	# initialize Faraday connection object
	conn = Faraday.new do |x|
	  x.adapter Faraday.default_adapter
	end

	# check last-modified header
	res = conn.head 'http://rs.gbif.org/datasets/backbone/backbone-current.zip';
	lm = DateTime.parse(res.headers['last-modified']).to_time

	# file last modified
	fm = File.stat("backbone-current.zip").mtime

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
		res = conn.get 'http://rs.gbif.org/datasets/backbone/backbone-current.zip';

		# write zip file to disk
		File.open('backbone-current.zip', 'wb') { |fp| fp.write(res.body) }
	else
		puts "'backbone-current.zip' found, skipping download"
	end
end

def unzip_backbone
	Zip::File.open('backbone-current.zip') do |zip_file|
	  zip_file.glob("taxon.txt") do |f|
			begin
				zip_file.extract(f, f.name) unless File.exist?(f.name)
			end
	  end
	end
end

def to_s3
	File.open("gbif.sqlite", 'rb') do |file|
  	$s3.put_object(bucket: 'gbif-backbone', key: 'gbif.sqlite', body: file)
	end
end
