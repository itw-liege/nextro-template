# frozen_string_literal: true

module Nextro
  module PageTitleConcern
    extend ActiveSupport::Concern

    included do
      helper_method :page_title
    end

    def page_title
      @page_title ||= "Admin"
    end
  end
end
