# frozen_string_literal: true

require 'thor'

module ZephyrRuby
  module CLI
    # Subcommand for creating and updating test cycles as well as uploading results in junit and cucumber format
    class TestCycles < Thor
      include Helpers
      
      desc "upload_junit_results", "Upload test results in junit format"
      method_option :project_key, type: :string, desc: "Project key (e.g. PROJ)"
      method_option :project_id, type: :numeric, desc: "Project ID (numeric, deprecated but supported for backward compatibility)"
      method_option :file, type: :string, desc: "Path to JUnit XML results file"
      method_option :name, type: :string, desc: "Test cycle name"
      method_option :description, type: :string, desc: "Test cycle description"
      method_option :auto_create_test_cases, type: :boolean, desc: "Auto-create test cases if they don't exist"
      method_option :auto_close_cycle, type: :boolean, desc: "Auto-close the test cycle after uploading"
      def upload_junit_results(*args)
        # Support both positional args and options hash for backward compatibility
        if args.length >= 5
          # Old style: positional arguments
          project_id_or_key, file, auto_close_cycle, name, description, auto_create_test_cases = args
          
          # Convert project_id to project_key if needed for API
          project_key = project_id_or_key.is_a?(Integer) || project_id_or_key.to_s.match?(/^\d+$/) ? 
                       project_id_or_key.to_s : project_id_or_key
        else
          # New style: options hash
          # Priority: project_id (for backward compatibility) > project_key
          project_key = options[:project_id] ? options[:project_id].to_s : options[:project_key]
          raise "Either project_key or project_id must be provided" unless project_key
          
          file = options[:file]
          raise "file is required" unless file
          
          name = options[:name]
          raise "name is required" unless name
          
          description = options[:description]
          auto_close_cycle = options[:auto_close_cycle]
          auto_create_test_cases = options[:auto_create_test_cases]
        end
        
        payload = generate_automations_payload(
          project_key,
          file,
          auto_close_cycle,
          name,
          description,
          auto_create_test_cases
        )
        
        parent_command.zephyr_client.create_automation_junit(payload)
      end

      desc "upload_cucumber_results", "Upload test results in cucumber format"
      method_option :project_key, type: :string, desc: "Project key (e.g. PROJ)"
      method_option :project_id, type: :numeric, desc: "Project ID (numeric, deprecated but supported for backward compatibility)"
      method_option :file, type: :string, desc: "Path to Cucumber JSON results file"
      method_option :name, type: :string, desc: "Test cycle name"
      method_option :description, type: :string, desc: "Test cycle description"
      method_option :auto_create_test_cases, type: :boolean, desc: "Auto-create test cases if they don't exist"
      method_option :auto_close_cycle, type: :boolean, desc: "Auto-close the test cycle after uploading"
      def upload_cucumber_results(*args)
        # Support both positional args and options hash for backward compatibility
        if args.length >= 5
          # Old style: positional arguments
          project_id_or_key, file, auto_close_cycle, name, description, auto_create_test_cases = args
          
          # Convert project_id to project_key if needed for API
          project_key = project_id_or_key.is_a?(Integer) || project_id_or_key.to_s.match?(/^\d+$/) ? 
                       project_id_or_key.to_s : project_id_or_key
        else
          # New style: options hash
          # Priority: project_id (for backward compatibility) > project_key
          project_key = options[:project_id] ? options[:project_id].to_s : options[:project_key]
          raise "Either project_key or project_id must be provided" unless project_key
          
          file = options[:file]
          raise "file is required" unless file
          
          name = options[:name]
          raise "name is required" unless name
          
          description = options[:description]
          auto_close_cycle = options[:auto_close_cycle]
          auto_create_test_cases = options[:auto_create_test_cases]
        end
        
        payload = generate_automations_payload(
          project_key,
          file,
          auto_close_cycle,
          name,
          description,
          auto_create_test_cases
        )
        
        parent_command.zephyr_client.create_automation_cucumber(payload)
      end

      desc "create", "Create test cycle"
      method_option :project_key, type: :string, desc: "Project key (e.g. PROJ)"
      method_option :project_id, type: :numeric, desc: "Project ID (numeric, deprecated but supported for backward compatibility)"
      method_option :name, type: :string, desc: "Test cycle name"
      method_option :description, type: :string, desc: "Test cycle description"
      method_option :start_date, type: :string, desc: "Planned start date (YYYY-MM-DD)"
      method_option :end_date, type: :string, desc: "Planned end date (YYYY-MM-DD)"
      def create(*args)
        # Support both positional args and options hash for backward compatibility
        if args.length >= 5
          # Old style: positional arguments
          name, description, start_date, end_date, project_id_or_key = args
          
          # Convert project_id to project_key if needed
          project_identifier = project_id_or_key.is_a?(Integer) || project_id_or_key.to_s.match?(/^\d+$/) ? 
                              { projectId: project_id_or_key.to_i } : 
                              { projectKey: project_id_or_key }
          
          payload = generate_test_cycle_payload(name, description, start_date, end_date, project_identifier.keys.first.to_s.sub('project', '') => project_identifier.values.first)
        else
          # New style: options hash
          project_identifier = if options[:project_id]
                               { projectId: options[:project_id].to_i }
                             elsif options[:project_key]
                               { projectKey: options[:project_key] }
                             else
                               raise "Either project_key or project_id must be provided"
                             end
          
          payload = generate_test_cycle_payload(
            options[:name],
            options[:description],
            options[:start_date],
            options[:end_date],
            project_identifier.keys.first.to_s.sub('project', '') => project_identifier.values.first
          )
        end
        
        parent_command.zephyr_client.create_test_cycle(payload)
      end

      desc "update", "Update test cycle"
      method_option :test_cycle_id_or_key, type: :string, desc: "Test cycle ID or key (format: PROJECT-R123)"
      method_option :name, type: :string, desc: "Test cycle name"
      method_option :description, type: :string, desc: "Test cycle description"
      method_option :start_date, type: :string, desc: "Planned start date (YYYY-MM-DD)"
      method_option :end_date, type: :string, desc: "Planned end date (YYYY-MM-DD)"
      method_option :project_key, type: :string, desc: "Project key (e.g. PROJ)"
      method_option :project_id, type: :numeric, desc: "Project ID (numeric, deprecated but supported for backward compatibility)"
      def update(*args)
        # Support both positional args and options hash for backward compatibility
        if args.length >= 6
          # Old style: positional arguments
          test_cycle_id_or_key, name, description, start_date, end_date, project_id_or_key = args
          
          # Convert project_id to project_key if needed
          project_identifier = project_id_or_key.is_a?(Integer) || project_id_or_key.to_s.match?(/^\d+$/) ? 
                              { projectId: project_id_or_key.to_i } : 
                              { projectKey: project_id_or_key }
          
          payload = generate_test_cycle_payload(name, description, start_date, end_date, project_identifier.keys.first.to_s.sub('project', '') => project_identifier.values.first)
        else
          # New style: options hash
          raise "test_cycle_id_or_key is required" unless options[:test_cycle_id_or_key]
          
          project_identifier = if options[:project_id]
                               { projectId: options[:project_id].to_i }
                             elsif options[:project_key]
                               { projectKey: options[:project_key] }
                             else
                               raise "Either project_key or project_id must be provided"
                             end
          
          payload = generate_test_cycle_payload(
            options[:name],
            options[:description],
            options[:start_date],
            options[:end_date],
            project_identifier.keys.first.to_s.sub('project', '') => project_identifier.values.first
          )
          
          test_cycle_id_or_key = options[:test_cycle_id_or_key]
        end
        
        parent_command.zephyr_client.update_test_cycle(test_cycle_id_or_key, payload)
      end
      
      desc "get", "Get test cycle details"
      method_option :test_cycle_id_or_key, type: :string, desc: "Test cycle ID or key (format: PROJECT-R123)"
      def get(*args)
        # Support both positional args and options hash for backward compatibility
        test_cycle_id_or_key = if args.length > 0
                               # Old style: positional argument
                               args.first
                             else
                               # New style: options hash
                               raise "test_cycle_id_or_key is required" unless options[:test_cycle_id_or_key]
                               options[:test_cycle_id_or_key]
                             end
        
        parent_command.zephyr_client.get_test_cycle(test_cycle_id_or_key)
      end
      
      desc "list", "List test cycles"
      method_option :project_key, type: :string, required: false, desc: "Filter by project key"
      method_option :project_id, type: :numeric, required: false, desc: "Filter by project ID (numeric, deprecated but supported for backward compatibility)"
      method_option :max_results, type: :numeric, required: false, desc: "Maximum number of results to return"
      def list(*args)
        params = {}
        
        # Support both positional args and options hash for backward compatibility
        if args.length > 0
          # Old style: positional arguments - project_id or project_key
          project_id_or_key = args.first
          
          if project_id_or_key
            if project_id_or_key.is_a?(Integer) || project_id_or_key.to_s.match?(/^\d+$/)
              params[:projectId] = project_id_or_key.to_i
            else
              params[:projectKey] = project_id_or_key
            end
          end
          
          # Second arg could be max_results
          params[:maxResults] = args[1].to_i if args.length > 1 && args[1]
        else
          # New style: options hash
          # Priority: project_id (for backward compatibility) > project_key
          if options[:project_id]
            params[:projectId] = options[:project_id]
          elsif options[:project_key]
            params[:projectKey] = options[:project_key]
          end
          
          params[:maxResults] = options[:max_results] if options[:max_results]
        end
        
        parent_command.zephyr_client.list_test_cycles(params)
      end
      
      desc "get_links", "Get test cycle links"
      method_option :test_cycle_id_or_key, type: :string, desc: "Test cycle ID or key (format: PROJECT-R123)"
      def get_links(*args)
        # Support both positional args and options hash for backward compatibility
        test_cycle_id_or_key = if args.length > 0
                               # Old style: positional argument
                               args.first
                             else
                               # New style: options hash
                               raise "test_cycle_id_or_key is required" unless options[:test_cycle_id_or_key]
                               options[:test_cycle_id_or_key]
                             end
        
        parent_command.zephyr_client.get_test_cycle_links(test_cycle_id_or_key)
      end
    end
  end
end
