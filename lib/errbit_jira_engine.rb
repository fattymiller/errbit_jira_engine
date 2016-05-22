require 'errbit_jira_engine/engine'
require 'errbit_jira_engine/error'
require 'errbit_jira_engine/issue_tracker'

module ErrbitJiraEngine
  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.read_static_file(file)
    File.read(File.join(self.root, 'app/assets/images/errbit_jira_engine', file))
  end
  
  def self.private_key_contents
    @private_key_contents ||= Errbit::Config.jira_private_key.to_s.gsub('\n', "\n")
  end
  
  def self.private_key_certificate
    @private_key_certificate ||= OpenSSL::PKey::RSA.new(private_key_contents)
  end
  
  def self.certificate_file
    unless @certificate_file && File.exist?(@certificate_file)
      File.open(Rails.root.join('./tmp/jira_private_key.pem'), 'w') do |f|
        f.write(private_key_contents)
        @certificate_file = f.path
      end
    end
    
    @certificate_file
  end
  
  def self.consumer_credentials
    @consumer_credentials ||= {
      consumer_key: Errbit::Config.jira_consumer_key,
      consumer_secret: private_key_certificate
    }
  end
  
  def self.client_settings
    unless @client_settings
      context_path = Errbit::Config.jira_context_path
      context_path = '' if context_path == '/'
    
      @client_settings = {
        site: Errbit::Config.jira_application_url,
        context_path: context_path,
        private_key_file: certificate_file
      }
    end
    
    @client_settings
  end
  
  def self.create_client
    JIRA::Client.new(**consumer_credentials, **client_settings)
  end
end

ErrbitPlugin::Registry.add_issue_tracker(ErrbitJiraEngine::IssueTracker)
