# zconfig

[![Build Status](https://travis-ci.org/itszootime/zconfig-ruby.svg?branch=master)](https://travis-ci.org/itszootime/zconfig-ruby)

A library for accessing ZConfig-managed configurations within Ruby. It includes a watcher to automatically reload configurations when files are modified by the daemon.

## Requirements

This gem is currently only compatible with UNIX-based systems with inotify installed. Support for more will be coming soon.

## Usage

The gem needs to know the path to your ZConfig-managed configuration files, and what environment you're running in.

```ruby
ZConfig.setup do |s|
  s.base_path   = "/etc/zconfig"
  s.environment = :production # default is development
end
```

If you wish to automatically reload the configuration as soon as it's modified, you'll need to tell ZConfig to watch:

```ruby
ZConfig.watch!
```

Retrieving values is easy. The following example assumes you have a `servers.yml` with a key called `db`.

```ruby
ZConfig.get(:servers, :db) # returns nil if not found
```
