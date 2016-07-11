require 'spec_helper'

RSpec.describe 'ZohoCrm' do
  describe '.config' do
    it 'yields the current configuration object' do
      yielded = nil

      ZohoCrm.config do |config|
        yielded = config
      end

      expect(yielded).to eq(ZohoCrm.config)
    end
  end

  describe '.logger' do
    it 'returns a unique logger instance' do
      logger = ZohoCrm.logger

      expect(logger).to eq(ZohoCrm.logger)
      expect(logger.level).to eq(Logger::WARN)
    end

    it 'sets a new logger' do
      logger = Logger.new(STDOUT)
      ZohoCrm.logger = logger

      expect(ZohoCrm.logger).to eq(logger)
    end
  end
end
