require 'spec_helper'

describe ZohoCrm::Configuration do
  it 'configures the gem using values from configuration file' do
    configuration = ZohoCrm::Configuration.new
    configuration.config_file_path = 'spec/fixtures/configuration.yml'
    configuration.environment = 'test'

    expect(configuration.config_file_path).to eq('spec/fixtures/configuration.yml')
    expect(configuration.environment).to eq('test')
    expect(configuration.url).to eq('https://crm.zoho.com/crm/private')
    expect(configuration.authtoken).to eq('my-zoho-auth-token')
  end

  context 'default configuration' do
    it 'returns a instance of zoho configuration with default config file path' do
      configuration = ZohoCrm::Configuration.new
      expect(configuration.config_file_path).to eq('config/zoho-crm.yml')
    end

    it 'sets RACK_ENV variable value as environment if is filled' do
      ENV['RACK_ENV'] = 'production'
      ENV['RAILS_ENV'] = nil
      configuration = ZohoCrm::Configuration.new
      expect(configuration.environment).to eq('production')
    end

    it 'sets RAILS_ENV variable value as environment if is filled' do
      ENV['RAILS_ENV'] = 'qa'
      ENV['RACK_ENV'] = nil
      configuration = ZohoCrm::Configuration.new
      expect(configuration.environment).to eq('qa')
    end
  end

  context 'when the config file has ERB blocks' do
    it 'processes the ERB code before parsing the configuration' do
      configuration = ZohoCrm::Configuration.new
      configuration.config_file_path = 'spec/fixtures/configuration.yml'
      configuration.environment = 'production'

      ENV['ZOHO_AUTH_TOKEN'] = 'AUTH_TOKEN_SET_THROUGH_ENV'
      expect(configuration.authtoken).to eq('AUTH_TOKEN_SET_THROUGH_ENV')
    end
  end
end
