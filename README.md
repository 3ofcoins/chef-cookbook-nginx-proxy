nginx-proxy cookbook
====================

Automatically set up Nginx as a proxy to backend application servers
or Apache. Provides a definition to use in recipes, and automatically
configures proxies based on attributes.

This cookbook's home is at https://github.com/3ofcoins/chef-cookbook-nginx-proxy/

Requirements
------------

 * nginx
 * apache2 (included only if apache backend is used)

Usage
-----

This cookbook provides an `nginx_proxy` definition that can be used
directly in recipes, and uses it to automatically configure proxies
based on attributes.

To use the definition, include the cookbook in your cookbook's
`depends`, optionally add `recipe[nginx-proxy::setup]` to the run
list, and use `nginx_proxy` in your recipes.

### `nginx_proxy` definition

#### Parameters:

 * `name` - name of the file in `sites-available/`; default value for
   `server_name`
 * `server_name` - server name for nginx
 * `ssl_key` - basename of SSL key
 * `ssl_key_path` - full path to SSL private key, defaults to
   `"#{ssl_key}.key"` in `node['nginx_proxy']['ssl_key_dir']`
 * `ssl_certificate_path` - full path to SSL certificate (full PEM
   file including intermediate certificates). Defaults to
   `"#{ssl_key}.pem"` in `node['nginx_proxy']['ssl_certificate_dir]`
 * `port` - port on localhost for the backend
 * `apache` (value optional) - if provided and true, configure Apache
   to listen on `node['nginx_proxy']['apache_port']` and use it as a
   backend
 * `url` - full URL to backend, can be used instead of `port` or
   `apache`
 * `redirect` - if true, redirect to the `url` rather than proxy its
   content
 * `aka` - can be set to one or more aliases that will redirect to the
   proxy. Last parameter may be a hash specifying parameters for
   `nginx_proxy` calls for the aliases (e.g. SSL keys)
 * `custom_config` - string, or a list of strings (lines), to include
   verbatim in the configuration.

#### Examples

```ruby
nginx_proxy 'icinga.example.com' do
  apache
  ssl_key 'star.example.com'
end
```

```ruby
nginx_proxy 'nagios.example.com' do
  url 'https://icinga.example.com'
  redirect true
end
```

```ruby
nginx_proxy 'new.example.com' do
  apache
  ssl_key 'star.example.com'
  aka 'old.example.com', 'yet-older.example.com',
      ssl_key: 'star.example.com'
end
```

```ruby
nginx_proxy 'example.info' do
  url 'http://example.com/'
end
```

```ruby
nginx_proxy 'site.example.com' do
  port 4000
end
```

### Data-driven recipe

If you include `nginx-proxy` in your run list, it will process the
`node['nginx_proxy']['proxies']` attribute hash to call the `nginx_proxy`
definition: each key will be passed as a name, and values are
interpreted in the following way:

 * if value is `'apache'` or `:apache`, then `apache` parameter is set
 * if value is a number or a string that is a number, then `port`
   parameter is set to the provided value
 * if value is a string that's not a number, then `url` parameter is
   set to the value
 * if value is a dictionary, it's applied as parameters

#### Example

```ruby
node['nginx_proxy']['proxies']['nagios.example.com'] = :apache
node['nginx_proxy']['proxies']['site.example.com'] = 4000
node['nginx_proxy']['proxies']['example.info'] = 'http://example.com'
node['nginx_proxy']['proxies']['new.example.com']['apache'] = true
node['nginx_proxy']['proxies']['new.example.com']['ssl_key'] = 'star.example.com
node['nginx_proxy']['proxies']['new.example.com']['aka'] = [
  'old.example.com', 'yet-older.example.com',
  ssl_key: 'star.example.com' ]
```

Attributes
----------

 * `node['nginx_proxy']['proxies']['…']` -- proxies for data-driven
   recipe (see above)
 * `node['nginx_proxy']['apache_port']` (default: 81) -- port to have
   Apache listen on when used as a backend
 * `node['nginx_proxy']['ssl_key_dir']` (default: `/etc/ssl/private`)
   -- directory holding private SSL keys
 * `node['nginx_proxy']['ssl_certificate_dir']` (default:
   `/etc/ssl/certificates`) -- directory holding public SSL certificates

Author
------

Author:: Maciej Pasternacki <maciej@3ofcoins.net>
