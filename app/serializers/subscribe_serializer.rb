class SubscribeSerializer
  def self.serialize(customer, subscription)
   {
      id: customer.id,
          subscription: {
                          id: subscription.id,
                          title: subscription.title,
                          price: subscription.price,
                          status: subscription.status,
                          frequency: subscription.frequency
                        } 
    }
  end
end