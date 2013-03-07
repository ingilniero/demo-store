require "minitest_helper"

describe Backend::ProductsController do

	describe 'show' do
		it 'should show only the products that belongs to this admin' do
			get :index, {}, { 'admin_id' => 200 }
			assert_response :success
			assert_template :index
			assigns[:products].wont_be_nil
		end
	end


	describe 'new' do
		it 'should display a form' do
			get :new , {}, { 'admin_id' => 200}

			assert_response :success
			assert_template :new
			assigns[:product].wont_be_nil
		end
	end

	describe 'create' do
		let(:params) do
			{
				product: {
									name: 'iPhone',
									description: 'Cool cell phone.',
									price: 6000,
									inventory: 100,
									active: true
								}
			}
		end

		let(:invalid_params)do
			{
				product: {
									name: nil,
									description: '',
									price: 'invalid',
									inventory: -1,
									active: nil
									}
			}
		end
		it 'should create a product and redirect to index' do
			post :create, params , { 'admin_id' => 100 }
			assert_redirected_to backend_products_path
			flash[:notice].wont_be_nil
		end

		it 'should redirect to new when product is invalid' do
			post :create, invalid_params, { 'admin_id' => 100 }
			assert_response :success
			assert_template :new
			flash[:alert].wont_be_nil
		end
	end

	describe 'edit' do
		it 'should edit display a form' do
			get :edit, { 'id' => 1 }, { 'admin_id' => 100}

			assert_response :success
			assert_template :edit
			assigns[:product].wont_be_nil
		end
	end

	describe 'update' do
		let(:params)do
			{
				id: 1,
				product: {
									name: 'another item',
									description: 'description',
									price: 10.0,
									inventory: -1,
									active: true
									}
			}
		end

		let(:invalid_params)do
			{
				id: 1,
				product: {
									name: 'product',
									description: 'description',
									price: nil,
									inventory: -1,
									active: nil
									}
			}
		end

		it 'should update a product and redirect to index' do
			put :update , params, { 'admin_id' => 100 }
			assigns[:product].wont_be_nil
			assert_redirected_to backend_products_path
			flash[:notice].wont_be_nil
		end

		it 'should render edit when product is invalid' do
			put :update, invalid_params, { 'admin_id' => 100 }
			assigns[:product].wont_be_nil
			assert_response :success
			assert_template :edit
			flash[:alert].wont_be_nil
		end
	end
end