require 'spec_helper'
require 'ostruct'

RSpec.describe ZohoCrm::Adapters::Api do
  it 'returns insert records url' do
    instance = class_with_api_adapter.new
    allow(instance).to receive(:config) { config }

    url = instance.insert_records_url('MyCustomModule')

    expect(url).to eq("#{config.url}/json/MyCustomModule/insertRecords?newFormat=1&scope=crmapi&authtoken=#{config.authtoken}")
  end

  it 'returns update records url' do
    instance = class_with_api_adapter.new
    allow(instance).to receive(:config) { config }

    url = instance.update_records_url('MyCustomModule')

    expect(url).to eq("#{config.url}/json/MyCustomModule/updateRecords?newFormat=1&scope=crmapi&authtoken=#{config.authtoken}")
  end

  it 'returns get records url' do
    instance = class_with_api_adapter.new
    allow(instance).to receive(:config) { config }

    url = instance.get_records_url('MyCustomModule')

    expect(url).to eq("#{config.url}/json/MyCustomModule/getRecords?newFormat=1&scope=crmapi&authtoken=#{config.authtoken}")
  end

  it 'returns get record url' do
    instance = class_with_api_adapter.new
    allow(instance).to receive(:config) { config }

    url = instance.get_record_url('MyCustomModule')

    expect(url).to eq("#{config.url}/json/MyCustomModule/getRecordById?newFormat=1&scope=crmapi&authtoken=#{config.authtoken}")
  end

  it 'returns search records url' do
    instance = class_with_api_adapter.new
    allow(instance).to receive(:config) { config }

    url = instance.search_records_url('MyCustomModule')

    expect(url).to eq("#{config.url}/json/MyCustomModule/searchRecords?newFormat=1&scope=crmapi&authtoken=#{config.authtoken}")
  end

  it 'returns get users url' do
    instance = class_with_api_adapter.new
    allow(instance).to receive(:config) { config }

    url = instance.get_users_url('MyCustomModule')

    expect(url).to eq("#{config.url}/json/MyCustomModule/getUsers?newFormat=1&scope=crmapi&authtoken=#{config.authtoken}")
  end

  it 'returns get fields url' do
    instance = class_with_api_adapter.new
    allow(instance).to receive(:config) { config }

    url = instance.get_fields_url('MyCustomModule')

    expect(url).to eq("#{config.url}/json/MyCustomModule/getFields?newFormat=1&scope=crmapi&authtoken=#{config.authtoken}")
  end

  it 'performs a get' do
    request = double(inspect: 'request')
    response = double(code: 200, headers: 'headers', body: "{\"result\":\"OK\"}")
    allow(RestClient).to receive(:get) { |&block| block.call(response, request) }

    expect(ZohoCrm.logger).to receive(:info).at_least(:once)
    expect(ZohoCrm.logger).to receive(:debug)

    instance = class_with_api_adapter.new
    response = instance.perform_get('https://crm.zoho.com/crm/private')

    expect(response).to eq({ 'result' => 'OK' })
  end

  it 'raises error on invalid response when performing get' do
    request = double(inspect: 'request')
    response = double(code: 200, headers: 'headers', body: "{\"response\":{\"error\":\"invalid response\"}}")
    allow(RestClient).to receive(:get) { |&block| block.call(response, request) }

    instance = class_with_api_adapter.new

    expect { instance.perform_get('https://crm.zoho.com/crm/private') }.to raise_error(RestClient::Exception)
  end

  it 'performs a post' do
    request = double(inspect: 'request')
    response = double(code: 200, headers: 'headers', body: "{\"result\":\"OK\"}")
    allow(RestClient).to receive(:post) { |&block| block.call(response, request) }

    expect(ZohoCrm.logger).to receive(:info).at_least(:once)
    expect(ZohoCrm.logger).to receive(:debug)

    instance = class_with_api_adapter.new
    response = instance.perform_post('https://crm.zoho.com/crm/private')

    expect(response).to eq({ 'result' => 'OK' })
  end

  it 'raises error on invalid response when performing post' do
    request = double(inspect: 'request')
    response = double(code: 200, headers: 'headers', body: "{\"response\":{\"error\":\"invalid response\"}}")
    allow(RestClient).to receive(:post) { |&block| block.call(response, request) }

    instance = class_with_api_adapter.new

    expect { instance.perform_post('https://crm.zoho.com/crm/private') }.to raise_error(RestClient::Exception)
  end

  def class_with_api_adapter
    @class ||= begin
      Class.new do
        include ZohoCrm::Adapters::Api
      end
    end
  end

  def config
    OpenStruct.new(url: 'https://crm.zoho.com/crm/private', authtoken: 'my-authtoken')
  end
end
