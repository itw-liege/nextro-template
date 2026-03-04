# frozen_string_literal: true

module Admin
  module TableHelper
    def table_edit_button(path)
      table_button(path, "fa-pencil-alt btn-success", tooltip: "Modifier")
    end

    def table_delete_button(path)
      table_button(path, "fa-trash btn-danger", tooltip: "Supprimer", confirm: "Êtes-vous sûr ?", method: :delete)
    end

    def table_show_button(path)
      table_button(path, "fa-eye btn-primary", tooltip: "Voir")
    end

    def table_button(path, icon, options = {})
      icon_html = tag.i(class: "fas #{icon} icon-circle icon-xs")
      link_options = {}
      link_options["data-toggle"] = "tooltip" if options[:tooltip]
      link_options["data-original-title"] = options[:tooltip] if options[:tooltip]
      link_options["data-confirm"] = options[:confirm] if options[:confirm]
      link_options[:method] = options[:method] if options[:method]
      link_to icon_html, path, link_options
    end
  end
end
