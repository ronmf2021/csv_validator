module CsvValidator
  class FileNotFoundError < StandardError
    def initialize(msg = 'CSV file not found')
      super
    end
  end
end 