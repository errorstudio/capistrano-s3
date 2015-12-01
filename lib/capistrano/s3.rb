require "capistrano"
require "capistrano/s3/publisher"
require "capistrano/s3/version"
require "capistrano/s3/defaults"

if Gem::Specification.find_by_name('capistrano').version >= Gem::Version.new('3.0.0')
  load File.expand_path('../tasks/capistrano_3.rb', __FILE__)
else
  require_relative 'tasks/capistrano_2'
end
