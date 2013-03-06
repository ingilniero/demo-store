class Product < ActiveRecord::Base
	belongs_to :admin
	has_many :images, :dependent => :destroy

	Max_Images = 5


	validates :name, :description, :price, :inventory, :active , presence: true
	validates :name, :uniqueness => { :scope => :admin_id }
	validates :price, numericality: true
	validates :inventory, numericality: { :only_integer => true, :greater_than_or_equal_to => -1 }
	validates :active, inclusion: { :in => [true, false] }

	accepts_nested_attributes_for :images, :limit => 5, :allow_destroy => true, :reject_if => :black?
end
