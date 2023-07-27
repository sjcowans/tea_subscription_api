require 'rails_helper'

RSpec.describe 'subscribe', type: :request do
  it 'can create a tea subscription for a customer' do
    @customer = Customer.create!(first_name: 'John', last_name: 'Doe', email: '<EMAIL>', address: '<ADDRESS>')
    @tea = Tea.create!(title: 'Green Tea', description: 'Green Tea Description', temperature: 'Temperature', brew_time: 'Brew Time')

    post "/customers/#{@customer.id}/teas/#{@tea.id}/subscriptions"
    expect(response.status).to eq(201)
    response = JSON.parse(response.body, symbolize_names: true)
    expect(response[:data][:id]).to eq(@customer.id)
    expect(response[:data][:subscription]).to eq(@subscription.id)
    expect(response[:data][:subscription][:title]).to eq(@subscription.title)
    expect(response[:data][:subscription][:price]).to eq(@subscription.price)
    expect(response[:data][:subscription][:status]).to eq('Active')
    expect(response[:data][:subscription][:frequency]).to eq(@subscription.frequency)
  end
end
