require "minitest_helper"

describe Product do
	it 'should be a valid product' do
		product = Product.new name: 'test', description: 'description', price: 10, inventory: 1, active: true
		product.name == 'test'
		product.description == 'description'
		product.price == 10
		product.inventory == 1
		product.active == true
		product.valid?.must_equal true
	end

	it 'should fail with invalid data' do
		product = Product.new.valid?.must_equal false
	end

	it 'should fail when tries to create two different products with the same name for the same admin' do
		  admin = Admin.find(100)
		  admin.products.create name: 'product', description: 'product', inventory: '1', price: '10', active: true

		  product = Product.new name: 'product', description: 'product', inventory: '1', price: '10', active: true
		  product.admin = admin
		  product.save.must_equal false
	end

	it 'should allow create two products with the same name on different admins' do
		admin_one = Admin.find(100)
		admin_two = Admin.find(200)

		product_one = admin_one.products.create name: 'product', description: 'description', inventory: '1', price: '10', active: true
		product_two = admin_two.products.create name: 'product', description: 'description', inventory: '1', price: '10', active: true

		product_one.valid?.must_equal true
		product_two.valid?.must_equal true
	end
end
