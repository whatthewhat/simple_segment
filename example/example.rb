$LOAD_PATH << './lib/rudder_analytics_sync'

require 'rudder_analytics_sync'

include RudderAnalyticsSync

analytics = RudderAnalyticsSync::Client.new(
  write_key: 'YOUR_WRITE_KEY', # required
  data_plane_url: 'https://a14c63e1.ngrok.io',
  on_error: proc { |error_code, error_body, exception, response|
    # defaults to an empty proc
  }
)

analytics.track(
  user_id: 'test_user_id',
  event: 'Created Account'
)

analytics.batch do |batch|
  batch.track(
    user_id: 'test_user_id',
    event: 'Created Account'
  )
  batch.track(
    user_id: 'test_user_id',
    event: 'Closed Account'
  )
end