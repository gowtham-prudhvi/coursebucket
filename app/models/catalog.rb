class Catalog < ApplicationRecord
	self.table_name = "catalog"
	searchable do
    text :name,:instructors,:partners
  	end
end
