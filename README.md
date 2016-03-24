# SimpleSegment

**Warning** The project is in development and is not ready for production use yet!

[![Build Status](https://travis-ci.org/whatthewhat/simple_segment.svg?branch=master)](https://travis-ci.org/whatthewhat/simple_segment)

A simple synchronous Ruby API client for [segment.io](segment.io).

SimpleSegment allows for manual control of when and how the events are sent to Segment. This can be useful if you want to leverage an existing queueing system like Sidekiq or Resque for sending events or need to send events synchronously. If this is not the case you will be better off using the [official segment gem](https://github.com/segmentio/analytics-ruby) that handles queuing for you.

## Status

### Implemented

- `analytics.track(...)`
- `analytics.identify(...)`
- `analytics.group(...)`
- `analytics.page(...)`
- `analytics.alias(...)`
- `analytics.flush` (no op for backwards compatibility with the official gem)

### Planned

- Ability to manually batch events, https://segment.com/docs/libraries/http/#import
- Configurable network error handling
- Configurable logging

The plan is to be an drop in replacement for the official gem, so all the APIs will stay the same whenever possible.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_segment'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_segment

## Usage

Create a client instance:

```ruby
analytics = SimpleSegment::Client.new({
  write_key: 'YOUR_WRITE_KEY'
})
```

Use it as you would use `analytics-ruby`:

```ruby
analytics.track(
  {
    user_id: user.id,
    event: 'Created Account'
  }
)
```

If you find inconsistencies with `analytics-ruby` feel free to file an issue.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/whatthewhat/simple_segment.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
