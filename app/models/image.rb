class Image < ActiveRecord::Base

	belongs_to :product
	has_attached_file :photo, :styles => { :medium => '100x100>', :thumb => '48x48>'}
	validates_attachment :photo, size: { less_than: 501.kilobytes }, content_type: { content_type: 'image/jpeg' }
end
