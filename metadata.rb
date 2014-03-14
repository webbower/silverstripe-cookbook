name             'silverstripe_cookbook'
maintainer       'Matt Bower'
maintainer_email 'matt@webbower.com'
license          'All rights reserved'
description      'Installs/Configures silverstripe_cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "apt"
depends "openssl"
depends "php"
depends "mysql"
depends "apache2"
depends "database"