require_relative 'lib/csv_validator/version'

Gem::Specification.new do |spec|
  spec.name = 'csv_validator'
  spec.version = CsvValidator::VERSION
  spec.authors = ['Your Name']
  spec.email = ['your.email@example.com']

  spec.summary = 'CSV validation with custom rules'
  spec.description = 'A Ruby gem for validating CSV files with custom rules and returning matching rows'
  spec.homepage = 'https://github.com/yourusername/csv_validator'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.files = Dir.glob('lib/**/*') + %w[README.md]
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rake', '~> 13.0'
end 