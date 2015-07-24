require 'spec_helper'

describe NetSuite::Records::AssemblyBuild do
  let(:assembly_build) { described_class.new }

  [
    :bin_numbers, :buildable, :component_list, :created_date, :expiration_date,
    :inventory_detail, :last_modified_date, :memo, :quantity,
    :serial_numbers, :total, :tran_date, :tran_id
  ].each do |field|
    it "has the #{field} field" do
      expect(assembly_build).to have_field(field)
    end
  end

  describe '.get' do
    context 'when the response is successful' do
      let(:buildable) { 100 }
      let(:response) { NetSuite::Response.new(:success => true, :body => { :buildable => buildable }) }

      it 'returns an AssemblyBuild instance populated with the data from the response object' do
        expect(NetSuite::Actions::Get).to receive(:call).with([described_class, :external_id => 1], {}).and_return(response)
        salesorder = described_class.get(:external_id => 1)
        expect(salesorder).to be_kind_of(described_class)
        expect(salesorder.buildable).to eql(buildable)
      end
    end

    context 'when the response is unsuccessful' do
      let(:response) { NetSuite::Response.new(:success => false, :body => {}) }

      it 'raises a RecordNotFound exception' do
        expect(NetSuite::Actions::Get).to receive(:call).with([described_class, :external_id => 1], {}).and_return(response)
        expect {
          described_class.get(:external_id => 1)
        }.to raise_error(NetSuite::RecordNotFound,
          /NetSuite::Records::AssemblyBuild with OPTIONS=(.*) could not be found/)
      end
    end
  end
end
