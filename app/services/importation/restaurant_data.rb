module Importation
  class RestaurantData
    def initialize(params)
      @params = params
    end

    def perform
      calls_params_validator
      created_data = Importation::RestaurantsDataCreator.new(@validated_params[:valid_params]).perform
      call_response_builder(created_data, @validated_params[:invalid_params])
    end

    private

    attr_reader :params

    def calls_params_validator
      @validated_params = ::Validators::ImportationRequestParams.new(params).perform
    end

    def call_response_builder(valid, invalid)
      Importation::ResponseBuilder.new(valid, invalid).perform
    end
  end
end
