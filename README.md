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
```
Sample csv content
ID,タイトル,カテゴリ,メール,電話,作成日,量
1,Iphone 16,携帯,duc@mfv.com,0932676897,2025-02-17,1
2,Iphone 16 pro,携帯,duc@mfv.com,0932676897,2025-02-17,15
```
You can define validation rules using a query hash structure:
```
{
      "ID" => {
        "key" => "id",
        "valid" => {
          "required" => true
        }
      },
      "タイトル" => {
        "key" => "title",
        "valid" => {
          "required" => true,
          "min_length" => 1,
          "max_length" => 100
        }
      },
      "カテゴリ" => {
        "key" => "category",
        "valid" => {
          "required" => true,
          "callback" => ->(v) { ['携帯', 'PC'].include?(v) }
        }
      },
      "メール" => {
        "key" => "email",
        "valid" => {
          "email" => true
        }
      },
      "電話" => {
        "key" => "phone",
        "valid" => {
          "phone" => true
        }
      },
      "作成日" => {
        "key" => "date_created"
      },
      "量" => {
        "key" => "quantity",
        "valid" => {
          "min" => 1,
          "max" => 10
        }
      }
    }

validator = CSVValidator.new('path/to/file.csv', query_hash)
```

result:
```
{
	"result": [
		{
			"id": 1,
			"title": "Iphone 16",
			"category": "携帯",
			"email": "duc@mfv.com",
			"phone": "0932676897",
			"date_created": "2025-02-17",
			"quantity": 1
		}
	],
	"errors": [
		{
			"row": 2,
			"msg": "量 not valid"
		}
	]
}
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create new Pull Request

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
