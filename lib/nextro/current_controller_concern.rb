# frozen_string_literal: true

module Nextro
  module CurrentControllerConcern
    extend ActiveSupport::Concern

    included do |_base|
      helper HelperMethods
      before_action :set_current_controller_name
    end

    module HelperMethods
      def current_controller?(controller_name)
        @current_controller_name == controller_name
      end
    end

    def set_current_controller_name
      @current_controller_name = controller_name
    end
  end
end
