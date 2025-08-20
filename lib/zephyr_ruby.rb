# frozen_string_literal: true

require_relative 'zephyr_ruby/client'
require_relative 'zephyr_ruby/version'

module ZephyrRuby
  class Error < StandardError; end
  
  # Load CLI functionality if Thor is available
  begin
    require 'thor'
    require_relative 'zephyr_ruby/cli'
  rescue LoadError
    # CLI functionality not available
  end
end
