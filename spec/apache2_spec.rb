# -*- coding: utf-8 -*-

require_relative './spec_helper'

describe 'nginx-proxy::apache2' do
  before do
    stub_command('which nginx').and_return(true)
    stub_command('/usr/sbin/apache2 -t').and_return(true)
  end
  let(:chef_run) { ChefSpec::SoloRunner.new }

  it 'should install Apache and have it listen on a non-standard port' do
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('nginx-proxy::default')
    expect(chef_run).to include_recipe('nginx::default')
    expect(chef_run).to include_recipe('apache2::default')
    expect(chef_run.node['apache']['listen_ports']).to be == [81]
    expect(chef_run.node['apache']['listen_addresses']).to be == %w(127.0.0.1)
  end

  it "can override apache's non-standard port via attribute" do
    chef_run.node.set['nginx_proxy']['apache_port'] = 88
    chef_run.converge(described_recipe)
    expect(chef_run.node['apache']['listen_ports']).to be == [88]
    expect(chef_run.node['apache']['listen_addresses']).to be == %w(127.0.0.1)
  end
end
