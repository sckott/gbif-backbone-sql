require_relative 'backbone'

desc "say hello"
task :hello do
  puts "hello world"
end

desc "get backbone, convert to sql, upload to amazon s3"
task :spine do
  begin
    Backbone.spine()
  rescue Exception => e
    raise e
  end
end

desc "get and unzip backbone"
task :fetch do
  begin
    Backbone.fetch()
  rescue Exception => e
    raise e
  end
end

desc "create sql database"
task :sql do
  begin
    Backbone.sql()
  rescue Exception => e
    raise e
  end
end

desc "upload database to s3"
task :s3 do
  begin
    Backbone.s3()
  rescue Exception => e
    raise e
  end
end
