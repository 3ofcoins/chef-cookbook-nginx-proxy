# -*- coding: utf-8 -*-

require File.expand_path('../support/helpers', __FILE__)

describe 'recipe[nginx-proxy::default]' do
  it 'does run tests' do
    expect { 2 * 2 == 4 }
  end
end
