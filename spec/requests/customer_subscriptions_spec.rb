require 'rails_helper'

RSpec.describe 'subscribe', type: :request do
  it 'can list all tea subscriptions for a customer' do
    @customer = Customer.create!(first_name: 'John', last_name: 'Doe', email: '<EMAIL>', address: '<ADDRESS>')
    @tea = Tea.create!(title: 'Green Tea', description: 'Green Tea Description', temperature: 100, brew_time: 20)
    Subscription.create!(title: @tea.title, price: @tea.monthly_price, status: 1, frequency: 'Monthly', customer_id: @customer.id)
    Subscription.create!(title: @tea.title, price: @tea.monthly_price, status: 1, frequency: 'Monthly', customer_id: @customer.id)

    get "/customers/#{@customer.id}/subscriptions"

    expect(response.status).to eq(200)
    response_data = JSON.parse(response.body, symbolize_names: true)

    response_data.each_with_index do |subscription_response, index|
      subscription = @customer.subscriptions[index]
      expect(subscription_response[:id]).to eq(subscription.id)
      expect(subscription_response[:title]).to eq(subscription.title)
      expect(subscription_response[:price]).to eq(subscription.price)
      expect(subscription_response[:status]).to eq('Active')
      expect(subscription_response[:frequency]).to eq(subscription.frequency)
    end
  end
end