module Concerns
  module Paginate
    DEFAULT_REQUIRED_RECORDS = 20
    MAX_REQUIRED_RECORDS = 100

    def validate_required_records(required_records)
      if required_records <= 0 || !required_records
        required_records = DEFAULT_REQUIRED_RECORDS
      end
      if required_records > MAX_REQUIRED_RECORDS
        required_records = MAX_REQUIRED_RECORDS
      end
      required_records
    end

    def paginate(page_number, required_records = DEFAULT_REQUIRED_RECORDS)
      required_records = validate_required_records(required_records)
      page_number = 0 if page_number <= 1 || !page_number
      limit(required_records).
        offset(page_number * required_records).order("id ASC")
    end
  end
end
