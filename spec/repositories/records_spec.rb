require 'spec_helper'

describe ZohoCrm::Repositories::Records do
  it 'defines model' do
    expect(repository_class.model_class).to eq(model_class)
  end

  it 'defines record adapter by default' do
    expect(repository_class.adapter).to be_kind_of(ZohoCrm::Adapters::Record)
  end

  it 'sets adapter' do
    adapter = double
    repository_class.adapter = adapter

    expect(repository_class.adapter).to eq(adapter)
  end

  describe 'finding a record' do
    it 'delegates to adapter' do
      adapter = double
      repository_class.adapter = adapter

      expect(adapter).to receive(:get_record).with(1)

      result = repository_class.new.find(1)
    end
  end

  it 'creates a record' do
    adapter = double
    repository_class.adapter = adapter
    allow(adapter).to receive(:insert_record) { { id: 1 } }

    result = repository_class.new.create(model_class.new)
    expect(result.id).to eq(1)
  end

  it 'updates a record' do
    adapter = double
    repository_class.adapter = adapter
    allow(adapter).to receive(:update_record) { { id: 2 } }

    result = repository_class.new.update(model_class.new)
    expect(result.id).to eq(2)
  end

  describe 'saving' do
    context 'new record' do
      it 'creates record' do
        repo = repository_class.new
        expect(repo).to receive(:create)

        repo.save(model_class.new(id: nil))
      end
    end

    context 'existing record' do
      it 'updates record' do
        repo = repository_class.new
        expect(repo).to receive(:update)

        repo.save(model_class.new(id: 1))
      end
    end
  end

  describe 'searching' do
    context 'with conditions' do
      it 'fetches data by criteria' do
        adapter = spy('adapter')
        repository_class.adapter = adapter

        repo = repository_class.new
        repo.select(:id).from(0).to(10).order(:id, :asc).where(id: 1)

        result = repo.fetch
        
        expect(adapter).to have_received(:search_records).with({
          "selectColumns" => "MyModule(ID)",
          "fromIndex" => 0,
          "toIndex" => 10,
          "sortColumnString" => "ID",
          "sortOrderString" => "asc",
          "criteria"=>"((ID:1))"
        })
      end

      it 'fetches data without' do
        adapter = spy('adapter')
        repository_class.adapter = adapter

        repo = repository_class.new
        repo.select(:id).from(0).to(5).order(:id, :asc)

        result = repo.fetch

        expect(adapter).to have_received(:get_records).with({
          "selectColumns" => "MyModule(ID)",
          "fromIndex" => 0,
          "toIndex" => 5,
          "sortColumnString" => "ID",
          "sortOrderString" => "asc"
        }) { [{ id: 1 }] }
      end
    end

    context 'aliases' do
      it 'fetches and returns the first' do
        records = [double]

        repo = repository_class.new
        allow(repo).to receive(:fetch) { records }

        expect(repo.first).to eq(records.first)
      end

      it 'fetches through #to_a' do
        repo = repository_class.new
        expect(repo.method(:to_a)).to eq(repo.method(:fetch))
      end
    end
  end

  private

  def repository_class
    repositoy_model_class = model_class

    @repository_class ||= Class.new do
      include ZohoCrm::Repositories::Records
      model repositoy_model_class
    end
  end

  def model_class
    @model_class ||= Class.new do
      include ZohoCrm::Model
      custom_module_name 'MyModule'

      property :id, as: 'ID'
    end
  end
end
