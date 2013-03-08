class Backend::ProductsController < ApplicationController
	before_action :authenticate!
	before_action :make_inventory_infinite, only: [:create, :update]

	def index
		@products = Product.scope_products(current_admin).order(:id)
	end

	def new
		@product = Product.new
		generate_image_fields_for @product
	end

	def create
		@product = current_admin.products.build(product_params)

		if @product.save
			flash[:notice] = "Producto creado correctamente."
			redirect_to backend_products_path
		else
			flash[:alert] = "Producto no se ha creado."
			generate_image_fields_for @product
			render :new
		end
	end

	def edit
		return redirect_to backend_products_path unless current_admin.products.exists?(params[:id])
		@product = Product.find(params[:id])
		generate_image_fields_for @product
	end

	def update
		@product = Product.find(params[:id])

		if @product.update_attributes(product_params)
			flash[:notice] = "Producto actualizado correctamente."
			redirect_to backend_products_path
		else
			flash[:alert] = "No se ha actualizado el producto."
			render :edit
		end
	end

	protected
		def product_params
			params.require(:product).permit(:name, :description, :price, :inventory, :active, :infinite,
			images_attributes: [:_destroy, :id, :photo])
		end

		def number_of_images_for( product )
			Product::Max_Images - product.images.count
		end

		def generate_image_fields_for( product )
			number_of_images_for(product).times { product.images.build }
		end

		def make_inventory_infinite
			unless params[:product].nil?
				params[:product][:inventory] = '-1' if params[:product][:infinite] == '1'
			end
		end
end
