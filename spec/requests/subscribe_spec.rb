require 'rails_helper'

RSpec.describe 'subscribe', type: :request do
  it 'can create a tea subscription for a customer' do
    @customer = Customer.create!(first_name: 'John', last_name: 'Doe', email: '<EMAIL>', address: '<ADDRESS>')
    @tea = Tea.create!(title: 'Green Tea', description: 'Green Tea Description', temperature: 'Temperature', brew_time: 'Brew Time')

    post "/customers/#{@customer.id}/teas/#{@tea.id}/subscriptions"
    expect(response.status).to eq(201)
    response_data = JSON.parse(response.body, symbolize_names: true)
    binding.pry
    expect(response_data[:id]).to eq(@customer.id)
    expect(response_data[:subscription][:id]).to eq(1)
    expect(response_data[:subscription][:title]).to eq(@tea.title)
    expect(response_data[:subscription][:price]).to eq(@tea.monthly_price)
    expect(response_data[:subscription][:status]).to eq('Active')
    expect(response_data[:subscription][:frequency]).to eq('Monthly')
  end

  it 'can give errors for a bad tea subscription for a customer' do
    @customer = Customer.create!(first_name: 'John', last_name: 'Doe', email: '<EMAIL>', address: '<ADDRESS>')
    @tea = Tea.create!(title: 'Green Tea', description: 'Green Tea Description', temperature: 'Temperature', brew_time: 'Brew Time')

    post "/customers/#{@customer.id}/teas/0/subscriptions"

    expect(response.status).to eq(404)

    response_data = JSON.parse(response.body, symbolize_names: true)
    expect(response_data[:errors][0][:detail]).to eq('Customer or tea not found')
  end

  it 'can give unproccesible entity for bad params' do
    @customer = Customer.create!(first_name: 'John', last_name: 'Doe', email: '<EMAIL>', address: '<ADDRESS>')
    @tea = Tea.create!(title: 'Green Tea', description: 'Green Tea Description', temperature: 'Temperature', brew_time: 'Brew Time')

    post "/customers/#{@customer.id}/teas/#{@tea.id}/subscriptions?frequency=4"

    expect(response.status).to eq(422)

    response_data = JSON.parse(response.body, symbolize_names: true)
    expect(response_data[:errors][0][:detail]).to eq('Is not a valid frequency')
  end

  it 'can update an inactive tea subscription to active for a customer' do
    @customer = Customer.create!(first_name: 'John', last_name: 'Doe', email: '<EMAIL>', address: '<ADDRESS>')
    @tea = Tea.create!(title: 'Green Tea', description: 'Green Tea Description', temperature: 'Temperature', brew_time: 'Brew Time')
    @subscription = Subscription.create!(title: @tea.title, price: @tea.monthly_price, status: 0, frequency: 'Monthly', customer_id: @customer.id)

    expect(@subscription.status).to eq('Inactive')

    patch "/customers/#{@customer.id}/subscriptions/#{@subscription.id}/?status=Active"

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

  it 'can give 422 from bad update params' do
    @customer = Customer.create!(first_name: 'John', last_name: 'Doe', email: '<EMAIL>', address: '<ADDRESS>')
    @tea = Tea.create!(title: 'Green Tea', description: 'Green Tea Description', temperature: 'Temperature', brew_time: 'Brew Time')
    @subscription = Subscription.create!(title: @tea.title, price: @tea.monthly_price, status: 0, frequency: 'Monthly', customer_id: @customer.id)

    patch "/customers/#{@customer.id}/subscriptions/#{@subscription.id}/?price=one"

    expect(response.status).to eq(422)
    response_data = JSON.parse(response.body, symbolize_names: true)
    expect(response_data[:errors][0][:detail][:price][0]).to eq('is not a number')
  end

  it 'can give 404 from no customer' do
    @customer = Customer.create!(first_name: 'John', last_name: 'Doe', email: '<EMAIL>', address: '<ADDRESS>')
    @tea = Tea.create!(title: 'Green Tea', description: 'Green Tea Description', temperature: 'Temperature', brew_time: 'Brew Time')
    @subscription = Subscription.create!(title: @tea.title, price: @tea.monthly_price, status: 0, frequency: 'Monthly', customer_id: @customer.id)

    patch "/customers/0/subscriptions/#{@subscription.id}/?price=one"

    expect(response.status).to eq(404)
    response_data = JSON.parse(response.body, symbolize_names: true)
    expect(response_data[:errors][0][:detail]).to eq("Customer not found")
  end
end
