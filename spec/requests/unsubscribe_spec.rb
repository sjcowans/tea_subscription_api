require 'rails_helper'

RSpec.describe 'unsubscribe', type: :request do
  it 'can update a tea subscription to inactive for a customer' do
    @customer = Customer.create!(first_name: 'John', last_name: 'Doe', email: '<EMAIL>', address: '<ADDRESS>')
    @tea = Tea.create!(title: 'Green Tea', description: 'Green Tea Description', temperature: 'Temperature', brew_time: 'Brew Time')
    @subscription = Subscription.create!(title: @tea.title, price: @tea.monthly_price, status: 1, frequency: 'Monthly', customer_id: @customer.id)

    expect(@subscription.status).to eq('Active')

    patch "/customers/#{@customer.id}/teas/#{@tea.id}/subscriptions/#{@subscription.id}/?status=inactive"

    @subscription.reload
    expect(@subscription.status).to eq('Inactive')

    expect(response.status).to eq(200)
    response_data = JSON.parse(response.body, symbolize_names: true)
    expect(response_data[:id]).to eq(@customer.id)
    expect(response_data[:subscription][:id]).to eq(1)
    expect(response_data[:subscription][:title]).to eq(@tea.title)
    expect(response_data[:subscription][:price]).to eq(@tea.monthly_price)
    expect(response_data[:subscription][:status]).to eq('Inactive')
    expect(response_data[:subscription][:frequency]).to eq('Monthly')
  end
end
