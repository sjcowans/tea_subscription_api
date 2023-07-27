class SubscriptionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :status, :frequency
end