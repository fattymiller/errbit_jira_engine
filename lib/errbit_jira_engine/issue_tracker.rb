require 'jira'

module ErrbitJiraEngine
  class IssueTracker < ErrbitPlugin::IssueTracker
    LABEL = 'jira'

    NOTE = 'Please configure Jira by entering the information below.'

    FIELDS = {
      :project_id => {
        :label => 'Project Key',
        :placeholder => 'The project Key where the issue will be created'
      },
      :issue_type => {
        :optional => true,
        :label => 'Issue Type',
        :placeholder => 'Default: Bug'
      },
      :issue_priority => {
        :optional => true,
        :label => 'Priority',
        :placeholder => 'Default: Medium'
      },
      :base_url => {
        :optional => true,
        :label => 'Jira URL without trailing slash',
        :placeholder => "Example: 'https://<company>.atlassian.net'. Default: `ENV['JIRA_APPLICATION_URL']`."
      }
    }

    def self.label
      LABEL
    end

    def self.note
      NOTE
    end

    def self.fields
      FIELDS
    end

    def self.icons
      @icons ||= {
        create: [
          'image/png', ErrbitJiraEngine.read_static_file('jira_create.png')
        ],
        goto: [
          'image/png', ErrbitJiraEngine.read_static_file('jira_goto.png'),
        ],
        inactive: [
          'image/png', ErrbitJiraEngine.read_static_file('jira_inactive.png'),
        ]
      }
    end

    def configured?
      errors.empty?
    end

    def errors
      errors = []
      
      if missing_option = self.class.fields.detect { |key, detail| !detail[:optional] && options[key].blank? }
        errors << [:base, "You must specify all non optional values! Found: '#{missing_option}'"]
      end
      
      errors
    end
    
    def client(user_details)
      if jira_token_expired?(user_details)
        raise ErrbitJiraEngine::IssueError.new('Your Jira credentials have expired. Please reconnect your account and try again.')
      end
      
      client = ErrbitJiraEngine.create_client
      client.set_access_token(user_details['jira_token'], user_details['jira_secret'])
      
      client
    end

    def create_issue(title, body, user: {})
      begin
        issue = {
          "fields" => {
            "summary" => title.split("\n").join(' '),
            "description" => body,
            "project" => {"key" => options['project_id']},
            "issuetype" => {"name" => issue_type},
            "priority" => {"name" => issue_priority}
          }
        }
        
        client = client(user)
        issue_build = client.Issue.build
        issue_build.save(issue)
        
        if issue_build.respond_to?(:errors) && issue_build.errors.any?
          raise ErrbitJiraEngine::IssueError.new(issue_build.errors.values.join('\r\n'))
        end
        
        jira_url(issue_build.key)
      rescue JIRA::HTTPError
        raise ErrbitJiraEngine::IssueError.new("Could not create an issue with Jira. Please check your credentials.")
      end
    end
    
    def jira_token_expired?(user_details)
      user_details['jira_token'].blank? ||
        user_details['jira_secret'].blank? ||
        user_details['jira_expires_at'].blank? ||
        user_details['jira_expires_at'] < Time.now
    end

    def jira_url(project_id)
      "#{url}#{ctx_path}browse/#{project_id}"
    end

    def url
      options['base_url'].presence || ENV['JIRA_APPLICATION_URL']
    end

    def ctx_path
      path = options['context_path'].to_s
      path += '/' unless path.end_with?('/')
      
      path
    end
    
    def issue_type
      options['issue_type'].presence || 'Bug'
    end
    
    def issue_priority
      options['issue_priority'].presence || 'Medium'
    end
  end
end
