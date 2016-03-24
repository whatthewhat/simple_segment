$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simple_segment'
require 'webmock/rspec'
require 'timecop'

WebMock.disable_net_connect!
