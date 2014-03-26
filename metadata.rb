name             'silverstripe_cookbook'
maintainer       'Matt Bower'
maintainer_email 'matt@webbower.com'
license          'All rights reserved'
description      'Installs/Configures silverstripe_cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

depends "apt", "~> 2.3"
depends "build-essential", "~> 1.4"
depends "openssl", "~> 1.1"
depends "php", "~> 1.4"
depends "apache2", "~> 1.9"
depends "mysql", "~> 4.1"
depends "database", "~> 2.0"
