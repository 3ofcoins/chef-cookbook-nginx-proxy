# -*- coding: utf-8 -*-

require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'

module Helpers
  def expect_site(name, *contents)
    if contents.empty?
      expect(chef_run).to(render_file("/etc/nginx/sites-available/#{name}"))
    else
      contents.each do |content|
        expect(chef_run).to(
          render_file("/etc/nginx/sites-available/#{name}")
            .with_content(content))
      end
    end
  end
end

RSpec.configure do |config|
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '12.04'
  config.include Helpers
end
