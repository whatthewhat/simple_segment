# SimpleSegment

[![Build Status](https://travis-ci.org/whatthewhat/simple_segment.svg?branch=master)](https://travis-ci.org/whatthewhat/simple_segment)

A simple synchronous Ruby API client for [segment.io](segment.io).

SimpleSegment allows for manual control of when and how the events are sent to Segment. This can be useful if you want to leverage an existing queueing system like Sidekiq or Resque for sending events or need to send events synchronously. If this is not the case you will be better off using the [official segment gem](https://github.com/segmentio/analytics-ruby) that handles queuing for you.

## Status

The gem supports all existing functionality of analytics-ruby:

- `analytics.track(...)`
- `analytics.identify(...)`
- `analytics.group(...)`
- `analytics.page(...)`
- `analytics.alias(...)`
- `analytics.flush` (no op for backwards compatibility with the official gem)

In addition it offers the ability to manually batch events with [analytics.batch](#batching).

The plan is to be an drop in replacement for the official gem, so if you find inconsistencies with `analytics-ruby` feel free to file an issue.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_segment'
```

Or install it yourself as:

```sh
$ gem install simple_segment
```

## Usage

Create a client instance:

```ruby
analytics = SimpleSegment::Client.new(
  write_key: 'YOUR_WRITE_KEY', # required
  on_error: proc { |error_code, error_body, exception, response|
    # defaults to an empty proc
  }
)
```

Use it as you would use `analytics-ruby`:

```ruby
analytics.track(
  user_id: user.id,
  event: 'Created Account'
)
```

### Batching

You can manually batch events with `analytics.batch`:

```ruby
analytics.batch do |batch|
  batch.context = {...}       # shared context for all events
  batch.integrations = {...}  # shared integrations hash for all events
  batch.identify(...)
  batch.track(...)
  batch.track(...)
  ...
end
```

### Stub API calls

You can stub your API calls avoiding unecessary requests in development and automated test environments (backwards compatible with the official gem):

```ruby
analytics = SimpleSegment::Client.new(
  write_key: 'YOUR_WRITE_KEY',
  stub: true
)
```

### Configurable Logger

When used in stubbed mode all calls are logged to STDOUT, this can be changed by providing a custom logger object:

```ruby
analytics = SimpleSegment::Client.new(
  write_key: 'YOUR_WRITE_KEY',
  logger: Rails.logger
)
```

### Set HTTP Options

You can set [options](https://docs.ruby-lang.org/en/2.0.0/Net/HTTP.html#method-c-start) that are passed to `Net::HTTP.start`.

```ruby
analytics = SimpleSegment::Client.new(
  write_key: 'YOUR_WRITE_KEY',
  http_options: {
    open_timeout: 42,
    read_timeout: 42,
    close_on_empty_response: true,
    # ...
  }
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/whatthewhat/simple_segment.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
