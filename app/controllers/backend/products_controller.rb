class Backend::ProductsController < ApplicationController
	def show
	end
	def index
		@products = current_admin.products
	end

	def new
		@product = Product.new
		5.times do
			@product.images.build
		end
	end

	def create
		@product = current_admin.products.build(product_params.except(:photo))
		if @product.save
			@image = @product.images.build(:photo => product_params[:photo])

			flash[:notice] = "Producto creado correctamente."
			redirect_to backend_products_path
		else
			flash[:alert] = "Producto no se ha creado."
			render :new
		end
	end

	def edit
		@product = Product.find(params[:id])
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
			params.require(:product).permit(:name, :images_fields, :description, :price, :inventory, :active)
		end
end
