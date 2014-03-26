# -*- coding: utf-8 -*-

require_relative './spec_helper'

describe 'nginx-proxy/definitions/default.rb' do
  let(:chef_run) { ChefSpec::Runner.new }

  def render_site(site_name)
    render_file("/etc/nginx/sites-available/#{site_name}")
  end

  it 'should install nginx' do
    chef_run.converge('apache2', 'nginx-proxy::_example')
    expect(chef_run).to include_recipe('nginx-proxy::default')

    expect(chef_run).to render_site('trivial.example.com')
      .with_content('proxy_pass http://127.0.0.1:8000;')
      .with_content('server_name trivial.example.com')

    expect(chef_run).to render_site('server-name-property')
      .with_content('proxy_pass http://127.0.0.1:8000;')
      .with_content('server_name server-name-property.example.com;')

    expect(chef_run).to render_site('explicit-url.example.com')
      .with_content('proxy_pass https://1.2.3.4:8002;')

    expect(chef_run).to render_site('apache.example.com')
      .with_content('proxy_pass http://127.0.0.1:81;')

    expect(chef_run).to render_site('secure-by-name.example.com')
      .with_content('proxy_pass http://127.0.0.1:81;')
      .with_content('listen 443 ssl;')
      .with_content('ssl_certificate /etc/ssl/certs/example.pem;')
      .with_content('ssl_certificate_key /etc/ssl/private/example.key;')

    expect(chef_run).to render_site('secure-by-path.example.com')
      .with_content('listen 443 ssl;')
      .with_content('ssl_certificate /path/to/certificate.pem;')
      .with_content('ssl_certificate_key /path/to/key.pem;')
  end
end
