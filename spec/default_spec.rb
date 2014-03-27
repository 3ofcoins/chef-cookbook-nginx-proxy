# -*- coding: utf-8 -*-

require_relative './spec_helper'

describe 'nginx-proxy::default' do
  let(:chef_run) { ChefSpec::Runner.new }

  it 'should install nginx' do
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('nginx::default')
  end

  it 'creates proxy given a port' do
    chef_run.node.set['nginx_proxy']['proxies']['example.com'] = 8000
    chef_run.converge(described_recipe)
    expect_site 'example.com', 'proxy_pass http://127.0.0.1:8000;'
  end

  it 'creates proxy given a port as string' do
    chef_run.node.set['nginx_proxy']['proxies']['example.com'] = '8000'
    chef_run.converge(described_recipe)
    expect_site 'example.com', 'proxy_pass http://127.0.0.1:8000;'
  end

  it 'creates proxy to apache' do
    chef_run.node.set['nginx_proxy']['proxies']['example.com'] = 'apache'
    chef_run.converge(described_recipe)
    expect_site 'example.com', 'proxy_pass http://127.0.0.1:81;'
  end

  it 'creates proxy to apache from keyword' do
    chef_run.node.set['nginx_proxy']['proxies']['example.com'] = :apache
    chef_run.converge(described_recipe)
    expect_site 'example.com', 'proxy_pass http://127.0.0.1:81;'
  end

  it 'creates proxy given a full spec' do
    exmpl = chef_run.node.set['nginx_proxy']['proxies']['example.com']
    exmpl['apache'] = true
    exmpl['ssl_key'] = 'example.com'
    exmpl['aka'] = ['old.example.com', ssl_key: 'old.example.com']
    chef_run.converge(described_recipe)
    expect_site 'example.com',
                'proxy_pass http://127.0.0.1:81;',
                'ssl_certificate_key /etc/ssl/private/example.com.key;'
    expect_site 'old.example.com',
                'rewrite ^ https://example.com$request_uri? permanent;',
                'ssl_certificate_key /etc/ssl/private/old.example.com.key;'
  end
end
