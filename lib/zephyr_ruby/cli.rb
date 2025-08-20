# frozen_string_literal: true

require 'thor'
require 'nokogiri'
require_relative 'cli/helpers/cli_helpers'
require_relative 'cli/test_cycles'
require_relative 'cli/test_plans'

module ZephyrRuby
  module CLI
    # Main CLI class for zephyr_ruby
    class Main < Thor
      class_option :api_key, type: :string, desc: 'Zephyr API Key (can also be set via ZEPHYR_API_KEY env var)'
      
      def initialize(*args)
        super
        # Only check for API key if we're not showing help
        return if ARGV.include?('help') || ARGV.include?('--help') || ARGV.empty?
        
        api_key = options[:api_key] || ENV['ZEPHYR_API_KEY']
        unless api_key
          puts "Error: API key is required. Set it with --api-key option or ZEPHYR_API_KEY env var"
          exit(1)
        end

        @zephyr_client = ZephyrRuby::Client.new(api_key)
      end

      desc "test_cycles", "Test cycles commands"
      subcommand "test_cycles", TestCycles

      desc "test_plans", "Test plans commands"
      subcommand "test_plans", TestPlans
      
      # Make the client accessible to subcommands
      no_commands do
        def zephyr_client
          @zephyr_client
        end
      end
    end
  end
end
