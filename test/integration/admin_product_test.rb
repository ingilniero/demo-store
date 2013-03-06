require 'minitest_helper'

feature 'admins products' do
	background do
    logout_admin
    login_admin
  end

  scenario 'Admin can see his products' do
  	click_link 'Products'
  	assert page.has_text?('Products')
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