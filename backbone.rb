require 's3'
require 'faraday'

module Backbone

	def self.spine

	end

end

# initialize Faraday connection object
conn = Faraday.new do |x|
  x.adapter Faraday.default_adapter
end

# get zip file
res = conn.get 'http://rs.gbif.org/datasets/backbone/backbone-current.zip';

# write zip file to disk
File.open('backbone-current.zip', 'wb') { |fp| fp.write(res.body) }
