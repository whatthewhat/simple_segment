require 'rudder_analytics_sync'

include RudderAnalyticsSync

analytics = RudderAnalyticsSync::Client.new(
  write_key: '1aJDXU7xlQpUp6qW1ppTJTvkgSi', # required
  data_plane_url: 'https://86143ed0.ngrok.io',
  on_error: proc { |error_code, error_body, exception, response|
    # defaults to an empty proc
  }
)

# analytics.track(
#   user_id: 'test_user_id',
#   event: 'Created Account'
# )

analytics.batch do |batch|
  batch.track(
    user_id: 'test_user_id',
    event: 'Created Account'
  )
  batch.page(
    user_id: 'test_user_id',
    name: 'Created Account',
    properties: {
      k1: 'v1'
    }
  )
  batch.track(
    user_id: 'test_user_id',
    event: 'Closed Account'
  )
  batch.identify(
    user_id: 'test_user_id_1',
    traits: {
      name: 'test'
    }
  )
  batch.group(
    user_id: 'test_user_id',
    group_id: 'group_id'
  )
end