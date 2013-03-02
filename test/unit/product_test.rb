require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?, 'product is invalid'
    assert product.errors[:title].any?, 'title has errors'
    assert product.errors[:description].any?, 'description has errors'
    assert product.errors[:image_url].any?, 'image_url has errors'
  end
end
