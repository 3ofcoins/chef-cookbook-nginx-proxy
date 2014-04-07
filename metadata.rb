# -*- coding: utf-8 -*-

name             'nginx-proxy'
maintainer       'Maciej Pasternacki'
maintainer_email 'maciej@3ofcoins.net'
license          'MIT'
description      'Nginx Proxy'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.1'

depends 'apache2'
depends 'nginx'
