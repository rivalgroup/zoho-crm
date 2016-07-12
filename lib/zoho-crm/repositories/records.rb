module ZohoCrm
  module Repositories
    module Records
      def self.included(base)
        base.class_eval do
          include InstanceMethods
          extend ClassMethods
        end
      end

      module ClassMethods
        attr_reader :model_class

        def model(model)
          @model_class = model
        end

        def adapter=(adapter)
          @adapter = adapter
        end

        def adapter
          @adapter = ZohoCrm::Adapters::Record.new(@model_class.module_name) unless @adapter

          @adapter
        end
      end

      module InstanceMethods
        def adapter
          self.class.adapter
        end

        def model_class
          self.class.model_class
        end

        def conditions
          @conditions ||= {}
        end

        def select(*columns)
          return if Array(columns).empty?

          select_columns = columns.map { |column| model_class.property_aliases[column] }
          conditions[:select_columns] = "#{model_class.module_name}(#{select_columns.join(',')})" if select_columns

          self
        end

        def from(index)
          conditions[:from_index] = index

          self
        end

        def to(index)
          conditions[:to_index] = index

          self
        end

        def order(sort_column, order = :asc)
          conditions[:sort_column] = model_class.property_aliases[sort_column]
          conditions[:order] = order.to_s

          self
        end

        def where(criteria = {})
          query = criteria.inject("") do |query, (k,v)|
            query.concat('AND') unless query.empty?

            key = model_class.property_aliases[k]
            query.concat("(#{model_class.property_aliases[k]}:#{v})") if key

            query
          end

          conditions[:criteria] = "(#{query})" unless query.empty?

          self
        end

        def find(id)
          record = adapter.get_record(id)

          map_record(record) if record
        end

        def save(record)
          if record.id
            update(record)
          else
            create(record)
          end
        end

        def create(record)
          adapter.insert_record(record.to_h(aliases: true)).tap do |data|
            record.update(data)
          end

          record
        end

        def update(record)
          adapter.update_record(record.id, record.to_h(aliases: true)).tap do |data|
            record.update(data)
          end

          record
        end

        def fetch
          if conditions.has_key?(:criteria)
            adapter.search_records(translate_conditions).map(&method(:map_record))
          else
            adapter.get_records(translate_conditions).map(&method(:map_record))
          end
        ensure
          clear_conditions!
        end

        def first
          fetch.first
        end

        alias to_a fetch

        private

        def map_record(record)
          model_class.new(record)
        end

        def translate_conditions
          translate_hash = {
            select_columns: 'selectColumns',
            from_index: 'fromIndex',
            to_index: 'toIndex',
            sort_column: 'sortColumnString',
            order: 'sortOrderString',
            criteria: 'criteria'
          }

          Hash[conditions.map { |k, v| [translate_hash[k], v] }]
        end

        def clear_conditions!
          @conditions.clear
        end
      end
    end
  end
end
