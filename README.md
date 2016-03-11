# zconfig

A client for (re)loading ZConfig-managed configurations.

## Requirements

This gem is currently only compatible with unix-based systems with inotify installed. Support for more will be coming soon...

## Usage

The client needs to know where your ZConfig-managed configuration is stored, and what environment you're running in. 

```ruby
ZConfig.setup do |s|
  s.base_path   = "/etc/zconfig"
  s.environment = :production # default is development
end
```

If you wish to automatically reload the configuration as soon as it's updated, you'll need to tell ZConfig to watch:

```ruby
ZConfig.watch!
```

Retrieving values is easy. The following example assumes you have a `servers.yml` with a key called `db`.

```ruby
ZConfig.get(:servers, :db) # returns nil if not found
```
