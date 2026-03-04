# frozen_string_literal: true

module Admin
  module MenuHelper
    def menu_current_controller?(controller_name)
      @current_controller_name == controller_name
    end

    def menu_title(title, subtitle = nil)
      content = content_tag(:label, title)
      content += content_tag(:span, subtitle) if subtitle
      content_tag(:li, content, class: "pc-item pc-caption")
    end

    def menu_link(name, path, controller_name, icon, others = {})
      return if others[:if] == false

      active = "active" if menu_current_controller?(controller_name)
      tag.li(class: "pc-item #{active}") do
        link_to url_for(path), class: "pc-link" do
          tag.span(class: "pc-micon fas #{icon}") {} 
            tag.span(name, class: "pr-4 pc-mtext")
        end
      end
    end

    def drop_menu(name, icon, items, active_menus, others = {})
      return nil if others[:if] == false
      return nil unless items.any?

      active = "active" if active_menus.include?(controller_name) || others[:active] == true
      tag.li(class: "pc-item pc-hasmenu") do
        link_to "#!", class: "pc-link", data: { toggle: "collapse" } do
          tag.span(class: "pc-micon fas #{icon}") {} 
            tag.span(name, class: "pc-mtext") 
            tag.span(class: "pc-arrow") do
              '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>'.html_safe
            end
        end 
        tag.ul(safe_join(items), class: "pc-submenu")
      end
    end
  end
end
