# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  # Attempt to create a new category or return an existing category
  #
  # @param category_attributes [Hash] Attributes to create the category with
  #                                     Currently consists of:
  #                                       - name: name of the category
  #
  # @return persisted category or nil
  def self.get_or_create(category_attributes)
    return nil unless category_attributes

    # Attempt to create a new category record
    category = Category.create(category_attributes)

    # If category failed the uniqueness validation,
    # try to find existing category
    unless category.valid?
      category = Category.find_by(name: category_attributes[:name])
    end

    category
  end
end
