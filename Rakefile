require 'securerandom'
require 'pathname'

desc 'Generate a new salt and put it in `.env`'
task :salt do
  salt = SecureRandom.hex(20)
  path = Pathname.new('../.env').expand_path(__FILE__)
  File.write(path, "SALT=#{salt}\n")
end
