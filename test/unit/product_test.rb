require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    
    assert product.invalid?, 'product is invalid'
    assert product.errors[:title].any?, 'title has errors'
    assert product.errors[:description].any?, 'description has errors'
    assert product.errors[:image_url].any?, 'image_url has errors'
  end

  test "product price must be positive" do
    product = Product.new(title: 'My Product Title',
                          description: 'description',
                          image_url: 'image.jpg')
    product.price = -1
    assert product.invalid?, 'product is invalid'
    assert_equal 'must be greater than or equal to 0.01', product.errors[:price].join('; ')

    product.price = 0
    assert product.invalid?, 'product is invalid'
    assert_equal 'must be greater than or equal to 0.01', product.errors[:price].join('; ')

    product.price = 1
    assert product.valid?, 'product is valid'
    
  end

  def new_product(image_url)
     Product.new(title: 'My Product Title',
                description: 'description',
                price: 1,
                image_url: image_url)
  end

  test "image url" do
    good = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    good.each do |image|
      assert new_product(image).valid?, "#{image} shouldn't be invalid"
    end

    bad.each do |image|
      assert new_product(image).invalid?, "#{image} shouldn't be valid"
    end
  end

  test "products are not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyyy",
                          image_url: "test.png",
                          price: 1)
    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join("; ")
  end


end
