#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'zephyr_ruby'
require 'json'

# This script tests the updated Zephyr Ruby gem functionality
# Replace these values with your actual API credentials and project information
API_KEY = ENV['ZEPHYR_API_KEY'] || 'your_api_key_here'
PROJECT_KEY = 'TEST' # Replace with your project key

# Initialize the client
client = ZephyrRuby::Client.new(api_key: API_KEY)

# Test 1: Create a test cycle with project key
puts "=== Test 1: Creating a test cycle ==="
test_cycle_payload = {
  name: "Test Cycle #{Time.now.to_i}",
  description: "Test cycle created by API test script",
  plannedStartDate: Date.today.to_s,
  plannedEndDate: (Date.today + 7).to_s,
  projectKey: PROJECT_KEY
}

begin
  response = client.create_test_cycle(test_cycle_payload)
  puts "Success! Test cycle created:"
  puts JSON.pretty_generate(response)
  test_cycle_key = response['key']
  puts "Test cycle key: #{test_cycle_key}"
rescue => e
  puts "Error creating test cycle: #{e.message}"
end

# Test 2: Get test cycle by key
if defined?(test_cycle_key)
  puts "\n=== Test 2: Getting test cycle by key ==="
  begin
    response = client.get_test_cycle(test_cycle_key)
    puts "Success! Test cycle retrieved:"
    puts JSON.pretty_generate(response)
  rescue => e
    puts "Error getting test cycle: #{e.message}"
  end
end

# Test 3: Update test cycle by key
if defined?(test_cycle_key)
  puts "\n=== Test 3: Updating test cycle by key ==="
  update_payload = {
    name: "Updated Test Cycle #{Time.now.to_i}",
    description: "Updated test cycle description",
    plannedStartDate: Date.today.to_s,
    plannedEndDate: (Date.today + 14).to_s,
    projectKey: PROJECT_KEY
  }
  
  begin
    response = client.update_test_cycle(test_cycle_key, update_payload)
    puts "Success! Test cycle updated:"
    puts JSON.pretty_generate(response)
  rescue => e
    puts "Error updating test cycle: #{e.message}"
  end
end

# Test 4: List test cycles
puts "\n=== Test 4: Listing test cycles ==="
begin
  params = { projectKey: PROJECT_KEY, maxResults: 5 }
  response = client.list_test_cycles(params)
  puts "Success! Test cycles listed:"
  puts JSON.pretty_generate(response)
rescue => e
  puts "Error listing test cycles: #{e.message}"
end

# Test 5: Get test cycle links
if defined?(test_cycle_key)
  puts "\n=== Test 5: Getting test cycle links ==="
  begin
    response = client.get_test_cycle_links(test_cycle_key)
    puts "Success! Test cycle links retrieved:"
    puts JSON.pretty_generate(response)
  rescue => e
    puts "Error getting test cycle links: #{e.message}"
  end
end

puts "\nAll tests completed!"
