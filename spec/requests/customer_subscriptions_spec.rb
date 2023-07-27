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

  it 'can update an inactive tea subscription to active for a customer' do
    @customer = Customer.create!(first_name: 'John', last_name: 'Doe', email: '<EMAIL>', address: '<ADDRESS>')
    @tea = Tea.create!(title: 'Green Tea', description: 'Green Tea Description', temperature: 'Temperature', brew_time: 'Brew Time')
    @subscription = Subscription.create!(title: @tea.title, price: @tea.monthly_price, status: 0, frequency: 'Monthly', customer_id: @customer.id)

    expect(@subscription.status).to eq('Inactive')

    patch "/customers/#{@customer.id}/teas/#{@tea.id}/subscriptions/#{@subscription.id}/?status=active"

    @subscription.reload
    expect(@subscription.status).to eq('Active')

    expect(response.status).to eq(200)
    response_data = JSON.parse(response.body, symbolize_names: true)
    expect(response_data[:id]).to eq(@customer.id)
    expect(response_data[:subscription][:id]).to eq(1)
    expect(response_data[:subscription][:title]).to eq(@tea.title)
    expect(response_data[:subscription][:price]).to eq(@tea.monthly_price)
    expect(response_data[:subscription][:status]).to eq('Active')
    expect(response_data[:subscription][:frequency]).to eq('Monthly')
  end
end