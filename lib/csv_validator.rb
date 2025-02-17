require 'csv'
require 'date'
require_relative 'csv_validator/version'
require_relative 'csv_validator/validator'
require_relative 'csv_validator/errors'

module CsvValidator
  class << self
    def query_csv(file_path, query_hash)
      validator = Validator.new(query_hash)
      validator.validate_file(file_path)
    end
  end
end 