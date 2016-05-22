# ErrbitJiraEngine

This gem adds support for JIRA to Errbit. This is an enginified version of errbit_jira_plugin from https://github.com/codemancode/errbit_jira_plugin

## Installation

Add this line to your Errbit instances's Gemfile:

    gem 'errbit_jira_engine'

And then execute:

    $ bundle

## Usage

This plugin requires an Administrator of a JIRA account to initially setup, but can be used by 'normal' JIRA users once installed.

### Connect with JIRA OAuth

1. Create an Application Link in your JIRA administration panel
  - Under the "Administration" cog icon, click "Applications"
  - Under the "Integrations" section, click "Application links"
  - Follow the instructions to create a new link from a URL.
    - Generate a Public and Private Key Pair. Enter the Public Key when prompted.
    - Create a unique consumer key for your integration.
2. Register your environment variables
```
JIRA_AUTHENTICATION=true
JIRA_SITE_TITLE=JIRA
JIRA_CONSUMER_KEY=[the consumer key used for JIRA Application Hook]
JIRA_CONTEXT_PATH=/
JIRA_APPLICATION_URL=https://<company>.atlassian.net
JIRA_PRIVATE_KEY=-----BEGIN RSA PRIVATE KEY-----\nMII...\n-----END RSA PRIVATE KEY-----\n
```
3. Register Devise Omniauth link
```ruby
  if Errbit::Config.jira_authentication || Rails.env.test?
    Devise.omniauth :jira,
      *ErrbitJiraEngine.consumer_credentials.values,
      client_options: ErrbitJiraEngine.client_settings
  end
```

## Contributing

1. Fork it ( https://github.com/fattymiller/errbit_jira_engine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
