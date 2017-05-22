class StaticPagesController < WebBaseController
  def home
    @total_usd_value = sprintf('%.2f', Discount.total_usd_value)
    @unique_apps_count = Discount.uniq_apps_count
  end
end
