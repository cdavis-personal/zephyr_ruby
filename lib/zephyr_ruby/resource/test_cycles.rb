# frozen_string_literal: true

module ZephyrRuby
  class Client
    module Resource
      # Operations related to Test Cycles
      module TestCycles
        # Create a new test cycle
        def create_test_cycle(body)
          post '/testcycles', body
        end

        # Get a test cycle by ID or key
        # @param test_cycle_id_or_key [String, Integer] The ID or key of the test cycle
        def get_test_cycle(test_cycle_id_or_key)
          get "/testcycles/#{test_cycle_id_or_key}"
        end

        # Update an existing test cycle
        # @param test_cycle_id_or_key [String, Integer] The ID or key of the test cycle
        # @param params [Hash] The parameters to update
        def update_test_cycle(test_cycle_id_or_key, params = {})
          put "/testcycles/#{test_cycle_id_or_key}", params
        end

        # List all test cycles with optional filtering
        # @param params [Hash] Optional parameters for filtering
        def list_test_cycles(params = {})
          get '/testcycles', params
        end

        # Get links for a test cycle
        # @param test_cycle_id_or_key [String, Integer] The ID or key of the test cycle
        def get_test_cycle_links(test_cycle_id_or_key)
          get "/testcycles/#{test_cycle_id_or_key}/links"
        end

        # Create a link between a test cycle and a Jira issue
        # @param test_cycle_id_or_key [String, Integer] The ID or key of the test cycle
        # @param body [Hash] The issue link details
        def create_test_cycle_issue_link(test_cycle_id_or_key, body)
          post "/testcycles/#{test_cycle_id_or_key}/links/issues", body
        end

        # Create a link between a test cycle and a generic URL
        # @param test_cycle_id_or_key [String, Integer] The ID or key of the test cycle
        # @param body [Hash] The web link details
        def create_test_cycle_web_link(test_cycle_id_or_key, body)
          post "/testcycles/#{test_cycle_id_or_key}/links/weblinks", body
        end
        
        # Maintain backward compatibility with old method names
        alias create_testcycle create_test_cycle
        alias get_testcycle get_test_cycle
        alias update_testcycle update_test_cycle
        alias list_testcycles list_test_cycles
        alias get_testcycle_links get_test_cycle_links
        alias create_testcycle_issue_link create_test_cycle_issue_link
        alias create_testcycle_web_link create_test_cycle_web_link
      end
    end
  end
end
