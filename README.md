# Alpine base image for php projects
[![devgeniem/alpine-php-base docker image](http://dockeri.co/image/devgeniem/alpine-php-base)](https://registry.hub.docker.com/u/devgeniem/alpine-php-base/)

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

Our base php project dependencies changes very little so it's divided into own image for better caching and building stability. If you want fullblown working wordpress image have look into: [devgeniem/alpine-wordpress](https://github.com/devgeniem/alpine-wordpress).

## What's inside container:
### For running PHP/WordPress
- php7
- php-fpm7
- nginx
- wp-cli
- composer

### For testing WordPress (Or any web application)
- phantomjs
- ruby
- poltergeist
- rspec
- capybara

### Other
- ssh client
