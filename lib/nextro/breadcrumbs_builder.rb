# frozen_string_literal: true

module Nextro
  class BreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
    def render
      set_context
    end

    def set_context
      return "" if @elements.empty?

      last = @elements.last
      last.path = nil

      @elements.collect do |element|
        render_element(element)
      end.join.html_safe
    end

    def render_element(element)
      @context.content_tag(:li, class: "breadcrumb-item") do
        compute_name(element)
      end
    end
  end
end
