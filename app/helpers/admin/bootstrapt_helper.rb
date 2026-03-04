# frozen_string_literal: true

module Admin
  module BootstraptHelper
    def b_link_to(title, path, button_type, options = {})
      link_options = { class: "btn btn-#{button_type}" }
      link_options["data-toggle"] = "tooltip" if options[:tooltip]
      link_options["data-original-title"] = options[:tooltip] || "Tooltip title" if options[:tooltip]
      link_to(title, path, link_options)
    end

    def b_card_for_resource(resource, &block)
      name = resource.class.to_s.pluralize.downcase
      card_action_name = action_name.to_sym
      card_action_name = :new if card_action_name == :create
      card_action_name = :edit if card_action_name == :update
      title = t("admin.#{name}.title.#{card_action_name}")
      b_card(title, &block)
    end

    def b_card(title, &block)
      b_card_of(title, 12, &block)
    end

    def b_card_of(title, col_size, &block)
      content = capture(&block)
      tag.div(class: "row") do
        tag.div(class: "col-sm-#{col_size}") do
          tag.div(class: "card") do
            tag.div(class: "card-header") do
              tag.h5(title)
            end
            tag.div(class: "card-body") { content }
          end
        end
      end
    end
  end
end
