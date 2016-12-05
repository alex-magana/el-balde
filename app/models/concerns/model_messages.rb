module Concerns
  module ModelMessages
    def name_length
      "Too short. The minimum length is 3 characters."
    end

    def list_name_uniqueness
      "A list with a similar name already exists."
    end
  end
end
