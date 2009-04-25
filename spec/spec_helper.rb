
require File.expand_path(
    File.join(File.dirname(__FILE__), %w[.. lib slate]))

Spec::Runner.configure do |config|
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

def stats(array)
  sum = array.inject(&:+)
  mean = sum.to_f / array.length
  stddev = Math.sqrt(array.inject(0) {|memo, val| memo + (val - mean)**2}.to_f / array.length)
  {:sum => sum, :mean => mean, :stddev => stddev}
end

# EOF
