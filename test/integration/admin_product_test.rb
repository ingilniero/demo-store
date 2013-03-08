require 'minitest_helper'

feature 'admins products' do
	background do
    logout_admin
    login_admin
  end

  scenario 'Admin can see his products' do
  	click_link 'Products'
  	assert page.has_text?('Nuevo Producto')
  end

  scenario 'Admin can create a product with an image' do
    click_link 'Products'
    click_link 'Nuevo Producto'

    fill_in 'product_name', :with => 'test'
    fill_in 'product_description', :with => 'the test description'
    fill_in 'product_price', :with => '1.0'
    fill_in 'product_inventory', :with => '1'
    check 'product_active'
    attach_file 'product_images_attributes_0_photo', 'test/fixtures/image.jpg'
    click_button 'Create Product'
    assert page.has_text?('Nuevo Producto')
    assert page.has_text?('test')
    click_link 'test'
    assert page.has_text?('Eliminar')
  end

  scenario 'Admin can delete an image of a product' do
    create_product_with_image
    click_link 'test'
    check 'product[images_attributes][0][_destroy]'
    click_button 'Update Product'
    click_link 'test'
    assert page.has_no_text?('Eliminar')
  end


  scenario 'Admin can check a field to make the inventory of one product infinite' do
    create_product_with_image
    click_link 'test'
    check 'product_infinite'
    click_button 'Update'
    click_link 'test'
    assert page.has_field? 'product_inventory', with: '-1'
  end

  scenario 'Two admins can create a product with the same name' do
    create_product_with_image
    assert page.has_text?('test')
    logout_admin
    login_admin
    create_product_with_image
    assert page.has_text?('test')
  end

  scenario 'Admin cannot see products of another admin' do
    create_product_with_image
    logout_admin
    login_admin
    click_link 'Products'
    assert page.has_no_text?('test')
  end

  scenario 'Admin cannot see a product even if know the url' do
    create_product_with_image
    logout_admin
    login_admin
    visit 'http://localhost:3000/backend/products/1/edit'
    assert page.has_no_text?('test')
  end
end

def logout_admin
  visit '/backend'
  all('.logout').each{|l| l.click}
end

def login_admin
  visit '/backend/sign_in'
  counter = Admin.count + 1
  email = "admin#{counter}@store.com"
  Admin.create! email: email, password: 'password', password_confirmation: 'password'

  within('#new_admin') do
    fill_in 'admin_email', with: email
    fill_in 'admin_password', with: 'password'
  end
  click_button 'login'
end

def create_product_with_image
  click_link 'Products'
  click_link 'Nuevo Producto'

  fill_in 'product_name', :with => 'test'
  fill_in 'product_description', :with => 'the test description'
  fill_in 'product_price', :with => '1.0'
  fill_in 'product_inventory', :with => '1'
  check 'product_active'
  attach_file 'product_images_attributes_0_photo', 'test/fixtures/image.jpg'
  click_button 'Create Product'
end