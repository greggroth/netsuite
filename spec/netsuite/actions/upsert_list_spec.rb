require 'spec_helper'

describe NetSuite::Actions::UpsertList do
  before(:all) { savon.mock! }
  after(:all) { savon.unmock! }

  context 'Customers' do
    let(:customers) do
      [
        NetSuite::Records::Customer.new(external_id: 'ext1', entity_id: 'Shutter Fly', company_name: 'Shutter Fly, Inc.'),
        NetSuite::Records::Customer.new(external_id: 'ext2', entity_id: 'Target', company_name: 'Target')
      ]
    end

    before do
      savon.expects(:upsert_list).with(:message => [
        {
          'record' => {
            :content! => {
              'listRel:entityId'    => 'Shutter Fly',
              'listRel:companyName' => 'Shutter Fly, Inc.'
            },
            '@xsi:type' => 'listRel:Customer',
            '@externalId' => 'ext1'
          }
        },
        {
          'record' => {
            :content! => {
              'listRel:entityId'    => 'Target',
              'listRel:companyName' => 'Target'
            },
            '@xsi:type' => 'listRel:Customer',
            '@externalId' => 'ext2'
          }
        }
      ]).returns(File.read('spec/support/fixtures/upsert_list/upsert_list_customers.xml'))
    end

    it 'makes a valid request to the NetSuite API' do
      NetSuite::Actions::UpsertList.call(customers)
    end

    it 'returns a valid Response object' do
      response = NetSuite::Actions::UpsertList.call(customers)
      response.should be_kind_of(NetSuite::Response)
      response.should be_success
    end

    context 'with errors' do
      let(:customers) do
        [
          NetSuite::Records::Customer.new(external_id: 'ext2', entity_id: 'Target', company_name: 'Target')
        ]
      end

      before do
        savon.expects(:upsert_list).with(:message =>
          {
            'record' => [{
              'listRel:entityId'    => 'Target',
              'listRel:companyName' => 'Target',
              '@xsi:type' => 'listRel:Customer',
              '@externalId' => 'ext2'
            }]
          }).returns(File.read('spec/support/fixtures/upsert_list/upsert_list_with_errors.xml'))
      end

      it 'constructs error objects' do
        response = NetSuite::Actions::UpsertList.call(customers)
        expect(response.errors.first.code).to eq('USER_ERROR')
        expect(response.errors.first.message).to eq('Please enter value(s) for: Item')
        expect(response.errors.first.type).to eq('ERROR')
      end
    end
  end
end
