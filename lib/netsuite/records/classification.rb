module NetSuite
  module Records
    class Classification
      include Support::Fields

      fields :name, :include_children, :is_inactive, :class_translation_list, :subsidiary_list, :custom_field_list

      attr_reader :internal_id, :external_id

      def initialize(attributes = {})
        @internal_id = attributes.delete(:internal_id) || attributes.delete(:@internal_id)
        @external_id = attributes.delete(:external_id) || attributes.delete(:@external_id)
        initialize_from_attributes_hash(attributes)
      end

      def self.get(id)
        response = Actions::Get.call(id, self)
        if response.success?
          new(response.body)
        else
          raise RecordNotFound, "#{self} with ID=#{id} could not be found"
        end
      end

    end
  end
end
