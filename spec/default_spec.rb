# -*- coding: utf-8 -*-

require 'chefspec'

describe 'nginx-proxy::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge 'nginx-proxy::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
