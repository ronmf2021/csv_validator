module CsvValidator
  class Validator
    def initialize(query_hash)
      @query_hash = query_hash
      @result = []
      @errors = []
    end

    def validate_file(file_path)
      raise FileNotFoundError unless File.exist?(file_path)

      CSV.foreach(file_path, headers: true).with_index(2) do |row, line_num|
        validate_row(row, line_num)
      end

      {
        result: @result,
        errors: @errors
      }
    end

    private

    def validate_row(row, line_num)
      row_data = {}
      row_valid = true

      @query_hash.each do |header, rules|
        value = row[header]
        key = rules['key']
        
        if rules['valid']
          valid, error = validate_field(header, value, rules['valid'])
          unless valid
            @errors << {row: line_num, msg: "#{header} #{error}"}
            row_valid = false
            next
          end
        end

        row_data[key] = convert_value(value, rules)
      end

      @result << row_data if row_valid
    end

    def validate_field(header, value, rules)
      return [false, 'is required'] if rules['required'] && value.to_s.empty?
      
      if value
        if rules['min_length'] && value.length < rules['min_length']
          return [false, "length must be >= #{rules['min_length']}"]
        end
        
        if rules['max_length'] && value.length > rules['max_length']
          return [false, "length must be <= #{rules['max_length']}"]
        end

        if rules['email'] && !valid_email?(value)
          return [false, 'is not a valid email']
        end

        if rules['phone'] && !valid_phone?(value)
          return [false, 'is not a valid phone number']
        end

        if rules['min'] && value.to_i < rules['min']
          return [false, "must be >= #{rules['min']}"]
        end

        if rules['max'] && value.to_i > rules['max']
          return [false, "must be <= #{rules['max']}"]
        end

        if rules['callback'] && !rules['callback'].call(value)
          return [false, 'not valid']
        end
      end

      [true, nil]
    end

    def convert_value(value, rules)
      return value unless value

      case rules['type']
      when 'integer'
        value.to_i
      when 'float'
        value.to_f
      when 'date'
        Date.parse(value)
      else
        value
      end
    end

    def valid_email?(email)
      email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    end

    def valid_phone?(phone)
      phone =~ /\A\d{10,11}\z/
    end
  end
end 