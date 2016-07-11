require 'spec_helper'

RSpec.describe ZohoCrm::Model do
  it 'defines a module name' do
    model_class.custom_module_name 'MyModelCustomName'
    expect(model_class.module_name).to eq 'MyModelCustomName'
  end

  it 'sets property a its alias' do
    model_class.property :model_name, as: 'MyCustomModelName'
    model = model_class.new

    expect(model.respond_to?(:model_name)).to be_truthy
    expect(model.respond_to?('MyCustomModelName')).to be_truthy
  end

  it 'initializes with property assigment' do
    model_class.property :model_name, as: 'MyCustomModelName'
    model = model_class.new(model_name: 'MyModelName')

    expect(model.model_name).to eq('MyModelName')
  end

  it 'initializes with property alias assigment' do
    model_class.property :model_name, as: 'MyCustomModelName'
    model = model_class.new(MyCustomModelName: 'MyModelName')

    expect(model.model_name).to eq('MyModelName')
    expect(model.public_send(:MyCustomModelName)).to eq('MyModelName')
  end

  it 'defines accessors for property' do
    model_class.property :model_name, as: 'MyCustomModelName'
    model = model_class.new
    model.model_name = 'MyModelName'

    expect(model.model_name).to eq('MyModelName')
  end

  it 'defines accessors for property alias' do
    model_class.property :model_name, as: 'MyCustomModelName'
    model = model_class.new
    model.public_send(:MyCustomModelName=, 'MyModelName')

    expect(model.model_name).to eq('MyModelName')
    expect(model.public_send(:MyCustomModelName)).to eq('MyModelName')
  end

  it 'list defined property names' do
    model_class.property :model_name, as: 'MyCustomModelName'
    expect(model_class.property_names).to include(:model_name)
  end

  it 'list defined property names with aliases' do
    model_class.property :model_name, as: 'MyCustomModelName'
    expect(model_class.property_aliases).to eq(model_name: 'MyCustomModelName')
  end

  it 'returns a Hash with property values' do
    model_class.property :model_name, as: 'MyCustomModelName'
    model = model_class.new(model_name: 'MyModelName')

    expect(model.to_h).to eq(model_name: 'MyModelName')
  end

  it 'returns a Hash with property aliases values' do
    model_class.property :model_name, as: 'MyCustomModelName'
    model = model_class.new(model_name: 'MyModelName')

    expect(model.to_h(aliases: true)).to eq('MyCustomModelName' => 'MyModelName')
  end

  def model_class
    @model_class ||= Class.new do
      include ZohoCrm::Model
    end
  end
end
