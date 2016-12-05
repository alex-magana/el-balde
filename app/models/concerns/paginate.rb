module Concerns
  module Paginate
    DEFAULT_RECORDS = 20
    MAX_RECORDS = 100

    def validate_page_number(page_number)
      if !page_number || page_number <= 1
        0
      else
        page_number - 1
      end
    end

    def validate_required_records(required_records)
      if !required_records || required_records <= 0
        required_records = DEFAULT_RECORDS
      end
      required_records = MAX_RECORDS if required_records > MAX_RECORDS
      required_records
    end

    def paginate(page_number, required_records = DEFAULT_RECORDS)
      required_records = validate_required_records(required_records)
      limit(required_records).
        offset(validate_page_number(page_number) * required_records).
        order("id ASC")
    end
  end
end
