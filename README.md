# CSV Validator

A Ruby gem for validating CSV files with customizable rules and formatting checks.

## Installation

Add this line to your application's Gemfile:

```
gem 'csv_validator'
```

And then execute:
```
$ bundle install
```
Or install it directly:
```
$ gem install csv_validator
```
## Usage

### Basic Validation
```
validator = CSVValidator.new('path/to/file.csv')
result = validator.validate
```
### Custom Validation Rules
```
validator = CSVValidator.new('path/to/file.csv') do |config|
  # Ensure specific columns exist
  config.required_headers = ['name', 'email', 'phone']
  
  # Add custom column validations
  config.validate_column('email') do |value|
    value.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
  end
  
  # Set maximum file size (in bytes)
  config.max_file_size = 5_000_000
end
```
### Validation Options

- `skip_empty_rows`: Ignore empty rows during validation
- `strict_headers`: Ensure headers match exactly (case-sensitive)
- `allow_extra_columns`: Allow additional columns not specified in required_headers

Example usage with options:
```
validator = CSVValidator.new('path/to/file.csv', 
  skip_empty_rows: true,
  strict_headers: false,
  allow_extra_columns: true
)
```
### Handling Results
```
result = validator.validate

if result.valid?
  puts "CSV is valid!"
else
  puts "Validation errors:"
  result.errors.each do |error|
    puts "Row #{error.row_number}: #{error.message}"
  end
end
```
### Example Query Hash Structure

You can define validation rules using a query hash structure:
```
query_hash = {
  headers: {
    required: ['name', 'email', 'age'],
    optional: ['phone', 'address']
  },
  validations: {
    'name' => {
      presence: true,
      format: /^[a-zA-Z\s]{2,50}$/,
      min_length: 2,
      max_length: 50
    },
    'email' => {
      presence: true,
      format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i,
      unique: true
    },
    'age' => {
      type: :integer,
      range: 18..100
    },
    'phone' => {
      format: /^\+?[\d\s-]{10,}$/,
      allow_blank: true
    }
  },
  options: {
    skip_empty_rows: true,
    strict_headers: true,
    allow_extra_columns: false,
    max_file_size: 5_000_000 # 5MB
  }
}

validator = CSVValidator.new('path/to/file.csv', query_hash)
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create new Pull Request

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
