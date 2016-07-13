require 'gyoku'

module ZohoCrm::Adapters
  class Record
    include ZohoCrm::Adapters::Api

    def initialize(module_name)
      @module_name = module_name
    end

    def get_record(id)
      body = perform_get(get_record_url(@module_name, id: id))

      return parse_record(body)
    end

    def get_records(params = {})
      body = perform_get(get_records_url(@module_name, params))

      return parse_records(body)
    end

    def search_records(criteria, params = {})
      body = perform_get(search_records_url(@module_name, params.merge(criteria: criteria)))

      return parse_records(body)
    end

    def insert_record(record_data)
      data = persist_params(record_data)
      body = perform_post(insert_records_url(@module_name), xmlData: Gyoku.xml(data))

      return parse_record_detail(body)
    end

    def update_record(id, record_data)
      data = persist_params(record_data)
      body = perform_post(update_records_url(@module_name), xmlData: Gyoku.xml(data), id: id)

      return parse_record_detail(body)
    end

    private

    def persist_params(record_data)
      params = {
        :@no => '1',
        :content! => {
          'FL' => record_data.map { |k, v| { :@val => k, :content! => v } if !v.nil? }.compact
        }
      }

      { @module_name => { 'row' => params } }
    end

    def parse_record(body)
      return nil if body.dig('response').has_key?('nodata')

      contents = body.dig('response', 'result', @module_name, 'row', 'FL')

      Hash[contents.map { |content| [content['val'], content['content']] }]
    end

    def parse_records(body)
      return [] if body.dig('response').has_key?('nodata')

      contents = [body.dig('response', 'result', @module_name, 'row')].flatten.map { |row| row['FL'] }

      contents.map do |content|
        Hash[content.map { |value| [value['val'], value['content']] }]
      end
    end

    def parse_record_detail(body)
      contents = body.dig('response', 'result', 'recorddetail', 'FL')

      Hash[contents.map { |content| [content['val'].downcase.tr(' ', '_').to_sym, content['content']] }]
    end
  end
end
