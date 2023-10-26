require 'rails_helper'

RSpec.describe SetFieldService do
  let(:service) { described_class }
  let(:existed_customer) {
    Customer.create!({
      email: 'example-existed-email@gmail.com',
      first_name: 'first-name-example',
      last_name: 'last-name-example',
      phone: 'phone-example',
      title: 'title-example',
      role: 'role-example',
      score: '1',
    })
  }
  let(:sample_customer) {
    Customer.create!({
      email: 'example-email@gmail.com',
      first_name: 'first-name-example',
      last_name: 'last-name-example',
      phone: 'phone-example',
      title: 'title-example',
      role: 'role-example',
      score: '1',
    })
  }

  context 'should save customer {field} success' do
    context 'with valid email' do
      let(:email) { ' new-EMAIL-edit@gmail.com ' }
      let(:result) { service.new.call(
        customer: sample_customer,
        field_name: 'email',
        new_value: email
      )}

      it 'return service with empty hash, correct email, verified false' do
        expect(result).to eq({})
        expect(sample_customer.email).to eq(email.strip.downcase)
        expect(sample_customer.verified).to be(false)
      end
    end

    context 'with valid first_name' do
      let(:first_name) { '  first-name-example ' }
      let(:result) { service.new.call(
        customer: sample_customer,
        field_name: 'first_name',
        new_value: first_name
      )}

      it 'return service with empty hash, correct first_name' do
        expect(result).to eq({})
        expect(sample_customer.first_name).to eq(first_name.strip)
      end
    end

    context 'with valid last_name' do
      let(:last_name) { '  last-name-example ' }
      let(:result) { service.new.call(
        customer: sample_customer,
        field_name: 'last_name',
        new_value: last_name
      )}

      it 'return service with empty hash, correct last_name' do
        expect(result).to eq({})
        expect(sample_customer.last_name).to eq(last_name.strip)
      end
    end

    context 'with valid phone' do
      let(:phone) { '  phone-example ' }
      let(:result) { service.new.call(
        customer: sample_customer,
        field_name: 'phone',
        new_value: phone
      )}

      it 'return service with empty hash, correct phone' do
        expect(result).to eq({})
        expect(sample_customer.phone).to eq(phone.strip)
      end
    end

    context 'with valid title' do
      let(:title) { '  title-example ' }
      let(:result) { service.new.call(
        customer: sample_customer,
        field_name: 'title',
        new_value: title
      )}

      it 'return service with empty hash, correct title' do
        expect(result).to eq({})
        expect(sample_customer.title).to eq(title.strip)
      end
    end

    context 'with valid role' do
      let(:role) { '  role-example ' }
      let(:result) { service.new.call(
        customer: sample_customer,
        field_name: 'role',
        new_value: role
      )}

      it 'return service with empty hash, correct role' do
        expect(result).to eq({})
        expect(sample_customer.role).to eq(role.strip)
      end
    end

    context 'with valid score' do
      let(:score) { ' 1 ' }
      let(:result) { service.new.call(
        customer: sample_customer,
        field_name: 'score',
        new_value: score
      )}

      it 'return service with empty hash, correct score' do
        expect(result).to eq({})
        expect(sample_customer.score).to eq(score.to_i)
      end
    end
  end

  context 'should update customer failed' do
    context 'with blank email' do
      let(:email) { '' }
      let(:result) { service.new.call(
        customer: sample_customer,
        field_name: 'email',
        new_value: email
      )}

      it 'return correct error' do
        expect(result[:error]).to eq( 'You need to specify an email for this customer.' )
      end
    end

    context 'with invalid email format' do
      let(:email) { 'examplegmail.com' }
      let(:result) { service.new.call(
        customer: sample_customer,
        field_name: 'email',
        new_value: email
      )}

      it 'return correct error' do
        expect(result[:error]).to eq("Can't save email. Invalid value: '#{email}'")
      end
    end

    context 'with existed email' do
      let(:result) { service.new.call(
        customer: sample_customer,
        field_name: 'email',
        new_value: existed_customer.email
      )}

      it 'return correct error' do
        expect(result[:error]).to eq( 'Email already exists.' )
      end
    end

    context 'with valid mail but unexpected exception happen' do
      before do
        allow(sample_customer).to receive(:save!).and_raise(StandardError, exception_message)
      end

      let(:exception_message) { 'Unexpected error' }
      let(:email) { 'example-normal-valid-email@gmail.com' }
      let(:result) { service.new.call(
        customer: sample_customer,
        field_name: 'email',
        new_value: email
      )}

      it 'return correct error' do
        expect(result[:error]).to eq( 'Unexpected error' )
      end
    end

    context 'with invalid/unknown field' do
      let (:field_name) { 'somefield' }
      let(:result) { service.new.call(
        customer: sample_customer,
        field_name: field_name,
        new_value: 'somefield_value'
      )}

      it 'return correct error' do
        expect(result[:error]).to eq( "Unknown field: '#{field_name}'" )
      end
    end
  end
end
