# What is RudderStack?

[RudderStack](https://rudderstack.com/) is a **customer data pipeline** tool for collecting, routing and processing data from your websites, apps, cloud tools, and data warehouse.

More information on RudderStack can be found [here](https://github.com/rudderlabs/rudder-server).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rudder_analytics_sync'
```

Or install it yourself by running:

```sh
$ gem install rudder_analytics_sync
```

## Usage

Create a client instance:

```ruby
analytics = RudderAnalyticsSync::Client.new(
  write_key: <YOUR_WRITE_KEY>, # required
  data_plane_url: <DATA_PLANE_URL>
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

## Contact Us
If you come across any issues while configuring or using this SDK, please feel free to start a conversation on our [Slack](https://resources.rudderstack.com/join-rudderstack-slack) channel. We will be happy to help you.
