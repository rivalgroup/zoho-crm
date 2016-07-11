require 'yaml'

module ZohoCrm
  class Configuration
    attr_accessor :environment, :config_file_path

    def config_file_path
      @config_file_path ||'config/zoho-crm.yml'
    end

    def url
      config['url']
    end

    def authtoken
      config['authtoken']
    end

    def environment
      @environment || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || raise('You must set the environment!')
    end

    private

    def config
      @config ||= YAML.load(ERB.new(File.read(config_file_path)).result)[environment]
    end
  end
end
