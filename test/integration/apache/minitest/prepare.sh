#!/bin/sh
set -e -x

gem_install () {
    /opt/chef/embedded/bin/gem install "${@}" --no-rdoc --no-ri --conservative
}

gem_install minitest -v '~> 5.0'
gem_install minitest-reporters
gem_install wrong -v 0.7.1
# gem_install pry
