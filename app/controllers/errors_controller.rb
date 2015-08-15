class ErrorsController < ApplicationController
  def catch_404
    raise ActionController::RoutingError.new("Route not found for #{request.url}")
  end
end