# frozen_string_literal: true

require 'thor'

module ZephyrRuby
  module CLI
    # Subcommand for creating and updating test plans
    class TestPlans < Thor
      include Helpers
      
      desc "create", "Create test plan"
      method_option :name, type: :string, required: true
      method_option :project_id, type: :numeric, required: true
      method_option :description, type: :string
      method_option :objective, type: :string
      method_option :folder_id, type: :string
      method_option :status_name, type: :string
      method_option :owner_id, type: :string
      method_option :labels, type: :string
      def create_test_plan(name, project_id, description, objective, folder_id, status_name, owner_id, labels)
        testplan_payload = generate_test_plan_payload(project_id, name, objective, folder_id, status_name, owner_id, labels)
        parent_command.zephyr_client.create_testplan(testplan_payload)
      end
    end
  end
end
