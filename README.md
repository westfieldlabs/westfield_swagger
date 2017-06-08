# Westfield Swagger

## Overview

Westfield Swagger is a mountable Rails engine which provides everything needed to create and serve Swagger 2.0 API specifications & documentation.

### Installation
Add it to your Gemfile:
```ruby
gem 'westfield_swagger', git: "git@github.com:westfield/westfield_swagger.git"
```

Then bundle:

```bash
$ bundle install
```

### Usage

WestfieldSwagger will add a new route at /swagger which provides three things:

1. An API endpoint allowing access to the swagger at '/swagger/<revision>.json'
2. An HTML endpoint at '/swagger/<revision>'
3. An API endpoint allowing access to the swagger at '/swagger/<service>/<revision>.json'
4. An HTML endpoint at '/swagger/<service>/<revision>'

External routing for (1, 2) access the swagger in api.xxx.westfield.io or secure.xxx.westfield.io. This is the swagger rollup of all the services.

External routing to the service endpoint for (3, 4) accesses the swagger for the service where the gem is installed. The JavaScript executes without the service in the path, thus loading as in (2).

Your specification can be fully-formatted in JSON at `lib/swagger/{version}.json` or in YAML with embedded Ruby (ERB) at `lib/swagger/{version}.yml`. This will be converted to JSON on-demand when requested.

Additionally, the swagger files can be split across files and directories and will be reconstructed on the fly.

To generate the required files, run:

```bash
$ rails generate swagger
```

This will add an example specification (`lib/swagger/0.1.yml`), example tests (`spec/requests/swagger_spec.rb`) and will mount the engine in your `routes.rb` file.

### References
* Swagger: http://swagger.io/
* Specs (2.0): https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md
