# frozen_string_literal: true

module ZephyrRuby
  module CLI
    # Helpers module to share common methods among the CLI classes
    module Helpers
      def generate_automations_payload(project_identifier, file, auto_close_cycle, name, description, auto_create_test_cases)
        # Convert to boolean if it's not already
        auto_create_test_cases = auto_create_test_cases.to_s.downcase == 'true' unless [true, false].include?(auto_create_test_cases)
        
        payload = {
          file: file,
          autoCreateTestCases: auto_create_test_cases,
          testCycle: {
            name: name,
            description: description || ""
          }
        }
        
        # Handle different formats of project identifier for backward compatibility
        if project_identifier.is_a?(Integer) || project_identifier.to_s.match?(/^\d+$/)
          # Old style: numeric project_id - convert to string for new API
          payload[:projectKey] = project_identifier.to_s
          # Also include projectId for backward compatibility with any custom integrations
          payload[:projectId] = project_identifier.to_i
        else
          # New style: string project_key
          payload[:projectKey] = project_identifier
        end
        
        # Add autoCloseCycle if provided
        if auto_close_cycle
          auto_close_cycle = auto_close_cycle.to_s.downcase == 'true' unless [true, false].include?(auto_close_cycle)
          payload[:autoCloseCycle] = auto_close_cycle
        end
        
        payload
      end

      def generate_test_cycle_payload(name, description, start_date, end_date, project_identifier)
        payload = {
          name: name,
          description: description,
          plannedStartDate: start_date,
          plannedEndDate: end_date
        }
        
        # Handle different formats of project identifier for backward compatibility
        if project_identifier.is_a?(Hash)
          # New style: {key: value} format from refactored code
          payload.merge!(project_identifier)
        elsif project_identifier.is_a?(Integer) || project_identifier.to_s.match?(/^\d+$/)
          # Old style: numeric project_id
          payload[:projectId] = project_identifier.to_i
        else
          # New style: string project_key
          payload[:projectKey] = project_identifier
        end
        
        payload
      end

      def generate_test_plan_payload(project_key, name, objective, folder_id, status_name, owner_id, labels, custom_fields = {})
        {
          projectKey: project_key,
          name: name,
          objective: objective,
          folderId: folder_id,
          statusName: status_name,
          ownerId: owner_id,
          labels: labels,
          customFields: custom_fields
        }
      end
    end
  end
end
