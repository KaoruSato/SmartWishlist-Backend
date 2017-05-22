class User::DiscountNotifier < SmartInit::Base
  initialize_with :product
  is_callable

  mattr_accessor :push_provider
  self.push_provider = User::PushProvider

  def call
    user = product.user
    return if user.is_system_user?
    message = "Discount #{product.discount_ratio}% \"#{product.name}\" now for #{product.current_price_formatted} from #{product.base_price_formatted}"

    push_provider.call(user, message)
  end
end
