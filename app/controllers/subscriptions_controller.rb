class SubscriptionsController < ApplicationController

  def create
    @customer = Customer.find(params[:customer_id])
    @tea = Tea.find(params[:tea_id])
    @subscription = Subscription.new(customer_id: @customer.id, title: @tea.title, price: @tea.monthly_price, status: "Active", frequency: 'Monthly')
    if @subscription.save
      render json: @subscription, status: :created
    else
      render json: ErrorMessageSerializer.serialize(@subscription.errors), status: :unprocessable_entity
    end
  end
end