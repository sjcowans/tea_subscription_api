class SubscriptionsController < ApplicationController

  def create
    @customer = Customer.find_by(id: params[:customer_id])
    @tea = Tea.find_by(id: params[:tea_id])
    if @customer.nil? || @tea.nil?
      render json: ErrorMessageSerializer.serialize("Customer or tea not found"), status: :not_found
      return
    end
    params[:frequency] ||= "Monthly"
    unless Subscription.frequencies.include?(params[:frequency])
      render json: ErrorMessageSerializer.serialize("Is not a valid frequency"), status: :unprocessable_entity
      return
    end
    @subscription = Subscription.new(customer_id: @customer.id, title: @tea.title, price: @tea.monthly_price, status: 1, frequency: params[:frequency])
    return unless @subscription.save

    render json: SubscribeSerializer.serialize(@customer, @subscription), status: :created
  end

  def index
    @customer = Customer.find_by(id: params[:customer_id])
    if @customer
      render json: @customer.subscriptions, status: :ok
    else 
      render json: ErrorMessageSerializer.serialize("Customer not found"), status: 404
    end
  end

  def update
    @customer = Customer.find_by(id: params[:customer_id])
    @subscription = Subscription.find(params[:id])
    if @customer
      if @subscription.update(subscription_params)
        render json: SubscribeSerializer.serialize(@customer, @subscription), status: :ok
      else
        render json: ErrorMessageSerializer.serialize(@subscription.errors), status: :unprocessable_entity
      end
    else
      render json: ErrorMessageSerializer.serialize("Customer not found"), status: 404
    end
  end

  private

  def subscription_params
    params.permit(:id, :customer_id, :title, :price, :status, :frequency)
  end
end