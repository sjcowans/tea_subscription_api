class SubscriptionsController < ApplicationController

  def create
    @customer = Customer.find(params[:customer_id])
    @tea = Tea.find(params[:tea_id])
    @subscription = Subscription.new(customer_id: @customer.id, title: @tea.title, price: @tea.monthly_price, status: 1, frequency: 'Monthly')
    if @subscription.save
      render json: SubscribeSerializer.serialize(@customer, @subscription), status: :created
    else
      render json: ErrorMessageSerializer.serialize(@subscription.errors), status: :unprocessable_entity
    end
  end

  def index
    @customer = Customer.find(params[:customer_id])
    render json: @customer.subscriptions, status: :ok
  end

  def update
    @customer = Customer.find(params[:customer_id])
    @subscription = Subscription.find(params[:id])
    if params[:status] == "active"
      @subscription.update(status: 1)
    elsif params[:status] == "inactive"
      @subscription.update(status: 0)
    end
    return unless @subscription.save

    render json: SubscribeSerializer.serialize(@customer, @subscription), status: :ok
  end
end