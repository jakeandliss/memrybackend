module Api
  module V1
    class Base < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError do |exception|
        render json: { error: exception.message }, status: :not_found
      end

      rescue_from Exception do |exception|
        render json: { error: exception.message }, status: :internal_server_error
      end

      #before_action :authenticate_user!
      # helper_method :current_user

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

      def report_errors_on(record)
        render json: { message: { errors: record.errors.full_messages } }, status: :unprocessable_entity
      end
    end
  end
end
