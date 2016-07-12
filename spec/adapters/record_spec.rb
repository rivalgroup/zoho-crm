require 'spec_helper'

RSpec.describe ZohoCrm::Adapters::Record do
  it 'parses get record response' do
    id = 1
    adapter = described_class.new('MyModule')

    allow(adapter).to receive(:get_record_url).with('MyModule', id: id) { 'get-record-url' }
    allow(adapter).to receive(:perform_get) { JSON.parse(fixture('get-record.json')) }

    result = adapter.get_record(id)

    expect(result['ID'].to_i).to eq(id)
  end

  it 'parses get records response' do
    adapter = described_class.new('MyModule')

    allow(adapter).to receive(:get_records_url).with('MyModule', {}) { 'get-records-url' }
    allow(adapter).to receive(:perform_get) { JSON.parse(fixture('get-records.json')) }

    results = adapter.get_records
    expect(results.size).to be(2)
    expect(results.map { |result| result['ID'] }).to eq(['1', '2'])
  end

  it 'parses search records response' do
    criteria = "(Name:Teste)"
    adapter = described_class.new('MyModule')

    allow(adapter).to receive(:search_records_url).with('MyModule', { criteria: criteria }) { 'search-records-url' }
    allow(adapter).to receive(:perform_get) { JSON.parse(fixture('search-records.json')) }

    results = adapter.search_records(criteria)
    expect(results.size).to be(2)
    expect(results.map { |result| result['ID'] }).to eq(['1', '2'])
  end

  it 'inserts record' do
    adapter = described_class.new('MyModule')

    xml = "<MyModule><row no=\"1\"><FL val=\"name\">register name</FL></row></MyModule>"

    allow(adapter).to receive(:insert_records_url).with('MyModule') { 'insert-record-url' }
    allow(adapter).to receive(:perform_post).with('insert-record-url', { xmlData: xml }) { 
      JSON.parse(fixture('insert-record.json'))
    }

    result = adapter.insert_record({ 'name' => 'register name' })
    expect(result[:id]).to eq('1')
  end

  it 'updates record' do
    adapter = described_class.new('MyModule')

    id = 1
    xml = "<MyModule><row no=\"1\"><FL val=\"name\">register name</FL></row></MyModule>"

    allow(adapter).to receive(:update_records_url).with('MyModule') { 'update-record-url' }
    allow(adapter).to receive(:perform_post).with('update-record-url', { xmlData: xml, id: id }) { 
      JSON.parse(fixture('update-record.json'))
    }

    result = adapter.update_record(id, { 'name' => 'register name' })

    expect(result[:id]).to eq('1')
  end
end
