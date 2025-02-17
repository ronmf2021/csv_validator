require 'spec_helper'

RSpec.describe CsvValidator do
  let(:csv_file) { 'spec/fixtures/test.csv' }
  let(:query_hash) do
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
  end

  before do
    File.write(csv_file, <<~CSV)
      ID,タイトル,カテゴリ,メール,電話,作成日,量
      1,Iphone 16,携帯,duc@mfv.com,0932676897,2025-02-17,1
      2,Iphone 16 pro,携帯,duc@mfv.com,0932676897,2025-02-17,15
    CSV
  end

  after do
    File.delete(csv_file) if File.exist?(csv_file)
  end

  describe '.query_csv' do
    it 'validates CSV data correctly' do
      result = CsvValidator.query_csv(csv_file, query_hash)
      
      expect(result[:result].size).to eq(1)
      expect(result[:errors].size).to eq(1)
      
      expect(result[:result].first).to include(
        'id' => '1',
        'title' => 'Iphone 16',
        'quantity' => '1'
      )
      
      expect(result[:errors].first).to include(
        row: 2,
        msg: '量 must be <= 10'
      )
    end

    it 'raises error for non-existent file' do
      expect {
        CsvValidator.query_csv('non_existent.csv', query_hash)
      }.to raise_error(CsvValidator::FileNotFoundError)
    end
  end
end 