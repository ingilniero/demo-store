class RemoveImagesFieldsFromImages < ActiveRecord::Migration
  def change
  	remove_column :images, :image_file_name
  	remove_column :images, :image_updated_at
  	remove_column :images, :image_content_type
  	remove_column :images, :image_file_size
  end
end
