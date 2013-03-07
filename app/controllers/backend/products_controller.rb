class Backend::ProductsController < ApplicationController
	before_action :authenticate!


	def show
	end

	def index
		@products = current_admin.products
	end

	def new
		@product = Product.new
		generate_image_fields_for @product
	end

	def create
		@product = current_admin.products.build(product_params)

		unless params[:product][:images_attributes].nil?
			params[:product][:images_attributes].each do | file, values |
				@product.images.build values
			end
		end

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

		unless params[:product][:images_attributes].nil?
			params[:product][:images_attributes].each do | file, values |
				# if values.key?(:_destroy)
				# 	@product.images = values
				# 	logger.inspect(file)
				# else
					@product.images.build values.except(:_destroy)
				# end
			end
		end

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
			params.require(:product).permit(:name, :description, :price, :inventory, :active)
		end

		def number_of_images_for( product )
			Product::Max_Images - product.images.size
		end

		def generate_image_fields_for( product )
			number_of_images_for(product).times { product.images.build }
		end
end
