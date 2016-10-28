class TestController < ApplicationController
  def test
  	User.reindex
  	products = User.search "vg"
	products.each do |product|
  	@product=product.active
	end
  end
end
