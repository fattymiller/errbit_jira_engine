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
  - Follow the instructions to create a new link from a URL. You will require public and private keys to continue.
2. 


## Contributing

1. Fork it ( https://github.com/fattymiller/errbit_jira_engine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
