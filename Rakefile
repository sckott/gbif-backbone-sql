require_relative 'backbone'

desc "get backone, convert to sql, upload to amazon s3"
task :spine do
  # Octokit.configure do |c|
  #   c.login = ENV['GITHUB_USERNAME']
  #   c.password = ENV['GITHUB_PAT_OCTOKIT']
  # end

  begin
    Backbone.spine()
  rescue Exception => e
    raise e
  end
end
