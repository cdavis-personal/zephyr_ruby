#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'zephyr_ruby'
require 'json'

# This script tests backward compatibility of the Zephyr Ruby gem
# Replace these values with your actual API credentials and project information
API_KEY = ENV['ZEPHYR_API_KEY'] || 'your_api_key_here'
PROJECT_ID = 12345 # Replace with a numeric project ID
PROJECT_KEY = 'TEST' # Replace with your project key
TEST_CYCLE_ID = 67890 # Replace with a numeric test cycle ID
TEST_CYCLE_KEY = 'TEST-R123' # Replace with a test cycle key

# Initialize the client
client = ZephyrRuby::Client.new(api_key: API_KEY)

puts "=== Testing Backward Compatibility ==="

# Test 1: Using old method names (aliases)
puts "\n=== Test 1: Using old method names (aliases) ==="
begin
  puts "Calling create_testcycle (old name)..."
  test_cycle_payload = {
    name: "Test Cycle Old Method #{Time.now.to_i}",
    description: "Testing backward compatibility with old method names",
    plannedStartDate: Date.today.to_s,
    plannedEndDate: (Date.today + 7).to_s,
    projectKey: PROJECT_KEY
  }
  response = client.create_testcycle(test_cycle_payload)
  puts "Success! Test cycle created with old method name."
  puts "Response contains key: #{response['key'] ? 'Yes' : 'No'}"
rescue => e
  puts "Error using old method name: #{e.message}"
end

# Test 2: Using numeric project_id instead of project_key
puts "\n=== Test 2: Using numeric project_id instead of project_key ==="
begin
  puts "Creating test cycle with numeric project_id..."
  test_cycle_payload = {
    name: "Test Cycle Project ID #{Time.now.to_i}",
    description: "Testing backward compatibility with numeric project ID",
    plannedStartDate: Date.today.to_s,
    plannedEndDate: (Date.today + 7).to_s,
    projectId: PROJECT_ID
  }
  response = client.create_test_cycle(test_cycle_payload)
  puts "Success! Test cycle created with numeric project ID."
  puts "Response contains key: #{response['key'] ? 'Yes' : 'No'}"
rescue => e
  puts "Error using numeric project ID: #{e.message}"
end

# Test 3: Using numeric test_cycle_id instead of test_cycle_key
puts "\n=== Test 3: Using numeric test_cycle_id instead of test_cycle_key ==="
begin
  puts "Getting test cycle with numeric ID..."
  response = client.get_test_cycle(TEST_CYCLE_ID)
  puts "Success! Got test cycle with numeric ID."
  puts "Response contains name: #{response['name'] ? 'Yes' : 'No'}"
rescue => e
  puts "Error using numeric test cycle ID: #{e.message}"
end

# Test 4: Using string test_cycle_key
puts "\n=== Test 4: Using string test_cycle_key ==="
begin
  puts "Getting test cycle with string key..."
  response = client.get_test_cycle(TEST_CYCLE_KEY)
  puts "Success! Got test cycle with string key."
  puts "Response contains name: #{response['name'] ? 'Yes' : 'No'}"
rescue => e
  puts "Error using string test cycle key: #{e.message}"
end

# Test 5: CLI with positional arguments (using CLI class directly for testing)
puts "\n=== Test 5: CLI with positional arguments ==="
begin
  require 'zephyr_ruby/cli/test_cycles'
  
  # Mock parent command with zephyr_client
  class MockParent
    attr_reader :zephyr_client
    
    def initialize(client)
      @zephyr_client = client
    end
  end
  
  # Create a CLI instance with our client
  cli = ZephyrRuby::CLI::TestCycles.new
  cli.define_singleton_method(:parent_command) { MockParent.new(client) }
  
  # Test create with positional arguments
  puts "Testing CLI create with positional arguments..."
  name = "CLI Test Cycle #{Time.now.to_i}"
  description = "Testing CLI backward compatibility"
  start_date = Date.today.to_s
  end_date = (Date.today + 7).to_s
  
  # Call with positional arguments (old style)
  result = cli.create(name, description, start_date, end_date, PROJECT_ID)
  puts "Success! CLI create with positional arguments works."
  puts "Response contains key: #{result['key'] ? 'Yes' : 'No'}"
  
  # Test get with positional arguments
  puts "Testing CLI get with positional arguments..."
  test_cycle_id = result['id']
  result = cli.get(test_cycle_id)
  puts "Success! CLI get with positional arguments works."
  puts "Response contains name: #{result['name'] ? 'Yes' : 'No'}"
  
  # Test list with positional arguments
  puts "Testing CLI list with positional arguments..."
  result = cli.list(PROJECT_KEY, 10)
  puts "Success! CLI list with positional arguments works."
  puts "Response contains test cycles: #{result['values'] && !result['values'].empty? ? 'Yes' : 'No'}"
rescue => e
  puts "Error testing CLI with positional arguments: #{e.message}"
  puts e.backtrace.join("\n")
end

puts "\nAll backward compatibility tests completed!"
