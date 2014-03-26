# -*- coding: utf-8 -*-

require_relative './spec_helper'

describe 'nginx-proxy::default' do
  let(:chef_run) { ChefSpec::Runner.new }

  it 'should install nginx' do
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe('nginx::default')
  end
end
