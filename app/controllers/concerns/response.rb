module Concerns
  module Response
    def render_response(body, status = :ok, location = nil)
      if location
        render json: body, status: status, location: location
      else
        render json: body, status: status
      end
    end
  end
end
