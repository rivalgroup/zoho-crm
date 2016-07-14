Zoho::Crm
=========

Wrapping zoho crm resources with class

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'zoho-crm'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zoho-crm

How to use
----------

### Model

Your model should include ```ZohoCrm::Model``` to represent the resource, use the method ```custom_module_name``` to define the resource name listed on Zoho CRM and the method ```property``` to define the resource fields.

```ruby
class MyLead
  include ZohoCrm::Model

  custom_module_name 'Leads'

  property :first_name, as: 'First Name'
  property :last_name, as: 'Last Name'
end
```

The ```as:``` option on property should be used to map the field name on Zoho CRM resource.

### Record Repository

So far, the record repository represents the following api methods:

- [getRecords](https://www.zoho.com/crm/help/api/getrecords.html)
- [getRecordById](https://www.zoho.com/crm/help/api/getrecordbyid.html)
- [insertRecords](https://www.zoho.com/crm/help/api/insertrecords.html)
- [updateRecords](https://www.zoho.com/crm/help/api/updaterecords.html)
- [searchRecords](https://www.zoho.com/crm/help/api/searchrecords.html)


The repository should include ```ZohoCrm::Repositories::Records``` and associate your model using ```model``` method.

```ruby
class MyLeadRepository
  include ZohoCrm::Repository::Records
  
  model MyLead
end
```

#### Find record
```ruby
lead_repo = MyLeadRepository.new

lead = lead_repo.find(1)
```

#### Create record

```ruby
lead = MyLead.new(first_name: 'Rocky', last_name: 'Balboa')

lead_repo = MyLeadRepository.new
lead_repo.create(lead)
```

#### Update record

```ruby
lead_repo = MyLeadRepository.new

lead = lead_repo.find(1)

lead.first_name = "Sylvester"
lead.last_name = "Stallone"

lead_repo.update(lead)
```

#### Save record

```ruby
lead = MyLead.new(first_name: 'Rocky', last_name: 'Balboa')

lead_repo = MyLeadRepository.new
lead_repo.save(lead)

lead.first_name = 'Sylvester'
lead.last_name = 'Stallone'

lead_repo.save(lead)
```

#### Query record

```ruby
lead_repo = MyLeadRepository.new

leads = lead_repo.select(:first_name).order(:last_name, :desc).from(0).to(10).where(first_name: 'Rocky')
```

Note that Zoho has a limit by 200 records for request, so it's necessary to control the result range using those methods #from and #to.

Contributing
------------

1. Fork it ( https://github.com/[my-github-username]/zoho-crm/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
