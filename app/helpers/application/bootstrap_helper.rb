# frozen_string_literal: true

module Application
  module BootstrapHelper
    def flash_message(flash)
      message = nil
      klass = nil
      title = nil

      if flash[:notice].present?
        message = flash[:notice]
        title = t("nextro.flash.notice")
        klass = "alert-success"
      elsif flash[:warning].present?
        message = flash[:warning]
        title = t("nextro.flash.warning")
        klass = "alert-warning"
      elsif flash[:error].present?
        message = flash[:error]
        title = t("nextro.flash.error")
        klass = "alert-danger"
      elsif flash[:alert].present?
        message = flash[:alert]
        title = t("nextro.flash.error")
        klass = "alert-danger"
      end

      return nil unless message.present?

      content_tag(:div, class: "row") do
          content_tag(:div, class: "col-sm-12") do
            content_tag(:div, class: "alert #{klass} alert-dismissable") do
              button_tag("&times;".html_safe, type: "button", class: "close", "data-dismiss": "alert", "aria-hidden": "true") +
                content_tag(:strong, title) + tag.br + message
            end
          end
        end
    end
  end
end
