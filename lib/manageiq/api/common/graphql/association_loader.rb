module ManageIQ
  module API
    module Common
      module GraphQL
        class AssociationLoader < ::GraphQL::Batch::Loader
          attr_reader :model, :association_name, :args

          def initialize(model, association_name, args = {})
            @model            = model
            @association_name = association_name
            @args             = args
          end

          def cache_key(record)
            record.object_id
          end

          def perform(records)
            records.each { |record| fulfill(record, read_association(record)) }
          end

          private

          def read_association(record)
            recs = ::ManageIQ::API::Common::GraphQL::AssociatedRecords.new(record.public_send(association_name).to_a)
            recs = ::ManageIQ::API::Common::GraphQL.ordered_search(recs, args)
            ::ManageIQ::API::Common::GraphQL.paged_search(recs, args)
          end
        end
      end
    end
  end
end
