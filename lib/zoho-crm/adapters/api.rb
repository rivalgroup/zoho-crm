require 'rest-client'

module ZohoCrm::Adapters
  module Api
    def insert_records_url(module_name)
      @insert_records_url ||= url(module_name, 'insertRecords')
    end

    def update_records_url(module_name)
      @insert_records_url ||= url(module_name, 'updateRecords')
    end

    def get_records_url(module_name, params = {})
      @get_records_url = url(module_name, 'getRecords', params)
    end

    def get_record_url(module_name, params = {})
      @get_record_url = url(module_name, 'getRecordById', params)
    end

    def search_records_url(module_name, params = {})
      @search_records_url = url(module_name, 'searchRecords', params)
    end

    def get_users_url(module_name, params = {})
      @get_users_url = url(module_name, 'getUsers', params)
    end

    def get_fields_url(module_name, params = {})
      @get_fields_url = url(module_name, 'getFields', params)
    end

    def perform_get(url)
      RestClient.get(url) do |response, request, result, &block|
        build_response(request, response)
      end
    end

    def perform_post(url, data = {})
      puts __LINE__
      puts data.inspect
      RestClient.post(url, data) do |response, request|
        build_response(request, response)
      end
    end

    private

    def url(module_name, method, params = {})
      uri = URI.parse("#{config.url}/json/#{module_name}/#{method}")
      uri.query = URI.encode_www_form(default_params.merge(params))
      uri.to_s
    end

    def default_params
      @default_params ||= { "newFormat" => 1, scope: 'crmapi', authtoken: config.authtoken }
    end

    def config
      @config ||= ZohoCrm::Configuration.new
    end

    def log_request(request, response)
      ZohoCrm.logger.info "# REQUEST => #{request.inspect}"
      ZohoCrm.logger.info "# RESPONSE => #{response.code} - #{response.headers}"

      ZohoCrm.logger.debug "# RESPONSE Body => #{response.body}"
    end

    def build_response(request, response)
      log_request(request, response)

      body = JSON.parse(response.body)
      puts __LINE__
      puts request.inspect
      puts body.inspect
      raise RestClient::Exception.new(response) if body.dig('response', 'error')

      body
    end
  end
end
