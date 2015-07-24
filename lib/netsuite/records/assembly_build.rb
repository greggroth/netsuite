module NetSuite
  module Records
    class AssemblyBuild
      include Support::Fields
      include Support::RecordRefs
      include Support::Records
      include Support::Actions
      include Namespaces::TranInvt

      actions :add, :delete, :get, :initialize, :search, :update, :upsert,
        :upsert_list

      fields :bin_numbers, :buildable, :component_list, :created_date,
        :expiration_date, :inventory_detail, :last_modified_date, :memo,
        :quantity, :serial_numbers, :total, :tran_date, :tran_id

      field :custom_field_list, CustomFieldList

      record_refs :created_from, :custom_form, :department, :item,
        :location, :posting_period, :revision, :subsidiary, :units

      attr_reader   :internal_id
      attr_accessor :external_id

      def initialize(attributes = {})
        @internal_id = attributes.delete(:internal_id) || attributes.delete(:@internal_id)
        @external_id = attributes.delete(:external_id) || attributes.delete(:@external_id)
        initialize_from_attributes_hash(attributes)
      end
    end
  end
end
