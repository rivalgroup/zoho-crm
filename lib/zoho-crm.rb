module ZohoCrm
  class << self
    attr_accessor :logger

    def config
      @config ||= ZohoCrm::Configuration.new

      yield @config if block_given?

      @config
    end

    def logger
      @logger ||= begin
        logger = Logger.new(STDOUT)
        logger.level = Logger::WARN
        logger
      end
    end
  end
end

require 'logger'
require 'zoho-crm/configuration'
require 'zoho-crm/model'
require 'zoho-crm/adapters/api'
require 'zoho-crm/adapters/record'
require 'zoho-crm/adapters/user'
require 'zoho-crm/repositories/records'
