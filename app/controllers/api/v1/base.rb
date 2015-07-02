module Api
  module V1
    class Base < ApplicationController
      before_filter :authenticate_user!
      before_filter :set_locale
      helper_method :current_user

      def validate_json(schema, data)
        schema_directory = Rails.root.join('doc', 'api', 'schemas')
        schema_path      = schema_directory.join("#{schema}.json").to_s
        @errors          ||= JSON::Validator.fully_validate(schema_path, data, :errors_as_objects => true)
      end

      DEFAULT_COUNT_PER_PAGE = 10

      private

      def current_user
        authenticate_by_token || super
      end
    end
  end
end