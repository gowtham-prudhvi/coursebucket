class Catalog < ApplicationRecord
	self.table_name = "catalog"
	searchable do
    text :name
  	end
end
