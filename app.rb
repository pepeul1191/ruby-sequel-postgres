require 'csv'

CSV.foreach(
  'data/carrers.csv',
  quote_char: '"',
  col_sep: '|',
  row_sep: :auto,
  headers: true,
) do |row|
  puts row[0]
  puts row['id']
  puts row['name']
end
