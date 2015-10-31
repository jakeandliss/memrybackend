# Configure CORS
unless Rails.env.test?
  Rails.application.configure do
    config.middleware.insert_before 0, "Rack::Cors",
                                    debug:  !(Rails.env.production?),
        logger: (-> { Rails.logger }) do
      allow do
        origins CORS_ALLOWED_DOMAINS

        resource '/cors',
               :headers => :any,
               :methods => [:post],
               :credentials => true,
               :max_age => 0

        resource '*', :headers => :any, :methods => [:get, :post, :put, :patch, :delete, :options]
      end
    end
  end
end