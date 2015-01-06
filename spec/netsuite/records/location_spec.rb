require 'spec_helper'

describe NetSuite::Records::Location do
  let(:location) { NetSuite::Records::Location.new }

  it 'has all the right attributes' do
    [
      :addr1, :addr2, :addr3, :addr_phone, :addr_text, :addressee, :attention, :city, :country, :include_children, :is_inactive,
      :make_inventory_available, :make_inventory_available_store, :name, :override, :state, :tran_prefix, :zip
    ].each do |field|
      location.should have_field(field)
    end
  end

  it 'has all the right record refs' do
    [
      :logo, :parent
    ].each do |record_ref|
      location.should have_record_ref(record_ref)
    end
  end

  describe '#class_translation_list' do
    it 'can be set from attributes'
    it 'can be set from a ClassTranslationList object'
  end

  describe '#subsidiary_list' do
    it 'creates record refs from attributes' do
      item = described_class.new({
        subsidiary_list: {
          record_ref: [
            { internal_id: 1 },
            { internal_id: 2 },
          ]
        }
      })

      expect(item.subsidiary_list.record_ref[0].internal_id).to eq(1)
      expect(item.subsidiary_list.record_ref[1].internal_id).to eq(2)
    end

    it 'can be set from a RecordRefList object' do
      item = described_class.new
      record_ref_list = NetSuite::Records::RecordRefList.new
      record_ref_list.record_ref = [ { internal_id: 1 } ]
      item.subsidiary_list = record_ref_list

      expect(item.subsidiary_list.record_ref[0].internal_id).to eq(1)
    end
  end

  describe '#custom_field_list' do
    it 'can be set from attributes'
    it 'can be set from a CustomFieldList object'
  end

  describe '.get' do
    context 'when the response is successful' do
      let(:response) { NetSuite::Response.new(:success => true, :body => { :city => 'Los Angeles' }) }

      it 'returns a Location instance populated with the data from the response object' do
        NetSuite::Actions::Get.should_receive(:call).with([NetSuite::Records::Location, {:external_id => 1}], {}).and_return(response)
        location = NetSuite::Records::Location.get(:external_id => 1)
        location.should be_kind_of(NetSuite::Records::Location)
        location.city.should eql('Los Angeles')
      end
    end

    context 'when the response is unsuccessful' do
      let(:response) { NetSuite::Response.new(:success => false, :body => {}) }

      it 'raises a RecordNotFound exception' do
        NetSuite::Actions::Get.should_receive(:call).with([NetSuite::Records::Location, {:external_id => 1}], {}).and_return(response)
        lambda {
          NetSuite::Records::Location.get(:external_id => 1)
        }.should raise_error(NetSuite::RecordNotFound,
          /NetSuite::Records::Location with OPTIONS=(.*) could not be found/)
      end
    end
  end

end
