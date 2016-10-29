class Catalog < ApplicationRecord
	self.table_name = "catalog"
	searchkick
end
