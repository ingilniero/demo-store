class Product < ActiveRecord::Base
	attr_accessor :infinite

	belongs_to :admin
	has_many :images, :dependent => :destroy

	accepts_nested_attributes_for :images, :limit => 5, :allow_destroy => true

	validates :name, :description, :price, :inventory, presence: true
	validates :name, :uniqueness => { :scope => :admin_id }
	validates :price, numericality: true
	validates :inventory, numericality: { :only_integer => true, :greater_than_or_equal_to => -1 }
	validates :active, inclusion: { :in => [true, false] }

	scope :scope_products, lambda { | admin | where( admin_id: admin ).order(:id) }

	Max_Images = 5

end
