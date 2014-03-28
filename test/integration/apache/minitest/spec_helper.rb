# -*- coding: utf-8 -*-

# HACK: busser or busser-minitest messes with $: `require` ends up
# loading minitest-2.x from stdlib rather than fresh one from rubygems
$LOAD_PATH.shift if $LOAD_PATH.first == RbConfig::CONFIG['rubylibdir']

ENV['MT_NO_EXPECTATIONS'] = '1'

gem 'minitest'

require 'minitest/autorun'
require 'minitest/reporters'
require 'wrong'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

Wrong.config.alias_assert :expect, override: true

class Minitest::Spec
  include ::Wrong::Assert
  include ::Wrong::Helpers

  def increment_assertion_count
    self.assertions += 1
  end

  def failure_class
    Minitest::Assertion
  end
end
