class Image < ActiveRecord::Base
	belongs_to :product
	has_attached_file :photo
	has_attached_file :photo, :styles => { :medium => '360', :thumb => '190'}

	validates_attachment :photo, size: { less_than: 1.megabytes }, content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png'] }
end
