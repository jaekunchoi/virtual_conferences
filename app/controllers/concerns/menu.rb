module Menu
	extend ActiveSupport::Concern

	class << self
		def add_sidebar_menu(top_level, menu_class, menu_items, expanded = false)
	    	@sidebar_menu_item ||= []
	    	@menu_items ||= []
	    	@sidebar_menu_item << [top_level, menu_class, @menu_items.concat(menu_items), expanded]
	    end
	end
end