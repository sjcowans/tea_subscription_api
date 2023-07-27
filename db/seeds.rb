# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Tea.destroy_all
Customer.destroy_all

@customer = Customer.create!(first_name: 'John', last_name: 'Doe', email: '<EMAIL>', address: '<ADDRESS>')
@tea = Tea.create!(title: 'Green Tea', description: 'Green Tea Description', temperature: 100, brew_time: 20)
@subscription = Subscription.create!(title: @tea.title, price: @tea.monthly_price, status: 1, frequency: 'Monthly', customer_id: @customer.id)