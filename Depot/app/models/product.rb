class Product < ActiveRecord::Base
    has_many :line_items
    has_many :orders, through: :line_items
    before_destroy :ensure_not_referenced_by_any_line_item
    validates :title, :description, :image_url, presence:true
    validates :price, numericality: {greater_than_or_equal_to: 0.01}
    validates_length_of :title, minimum: 10, message: " should be having a minimum of ten charactes"
    validates :image_url, allow_blank:true, format: {
        with: %r{\.gif|jpg|jpeg|png\Z}i,
        messsage: "Given image must be of Jpeg/Png/Gif fromat only"
        } 
    def self.latest
        Product.order(:updated_at).last
    end
    private
      def ensure_not_referenced_by_any_line_item
          if line_items.empty?
              return true
          else
              errors.add(:base, "Line Items Present")
              return false
          end
      end     
end
=begin
We see if the product is referenced by any line item before deletion. If it is, prevent it form being deleted. Else, allow it to be deleted.
=end
