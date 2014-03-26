# -*- ruby -*-
site :opscode

metadata
cookbook 'apache2'              # recommended

group :integration do
  cookbook "minitest-handler"
  cookbook "nginx-proxy-test", :path => "./test/cookbooks/nginx-proxy-test"
end
