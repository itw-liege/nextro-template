# frozen_string_literal: true

module BreadcrumbdableConcern
  extend ActiveSupport::Concern

  def breadcrumb_title
    respond_to?(:name) ? name : to_s
  end
end
