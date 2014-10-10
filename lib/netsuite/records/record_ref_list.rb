module NetSuite
  module Records
    class RecordRefList
      include Support::Fields
      include Support::Records
      include Namespaces::PlatformCore

      fields :record_ref

      def initialize(attrs = {})
        initialize_from_attributes_hash(attrs)
      end

      def record_ref=(items)
        case items
        when Hash
          self.record_ref << RecordRef.new(items)
        when Array
          items.each { |ref| self.record_ref << RecordRef.new(ref) }
        end
      end

      def record_ref
        @record_ref ||= []
      end

      def to_record
        { "#{record_namespace}:recordRef" => record_ref.map(&:to_record) }
      end

    end
  end
end
