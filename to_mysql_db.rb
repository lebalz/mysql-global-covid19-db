require 'csv'

# some populations are unknown in the
# csv and were looked up on wikipedia
POPULATION = {
  'Falkland_Islands_(Malvinas)' => 3398,
  'Western_Sahara' => 567402,
  'Eritrea' => 5750433,
  'Anguilla' => 14731,
  'Bonaire, Saint Eustatius and Saba' => 25987
}

table = CSV.parse(File.read("./covd19_14_05_2020.csv"), headers: true)
rows = table.size

create_db = <<-SQL
DROP DATABASE IF EXISTS global_covid19;
CREATE DATABASE global_covid19;
USE global_covid19;
SQL

create_table = <<-SQL
CREATE TABLE regions (
  name CHAR(64) PRIMARY KEY,
  continent CHAR(32),
  population BIGINT NOT NULL
);

CREATE TABLE reports (
  id INT PRIMARY KEY auto_increment,
  reported_at DATE NOT NULL,
  cases INT NOT NULL,
  deaths INT NOT NULL,
  region CHAR(64) NOT NULL,
  continent CHAR(32) NOT NULL,
  FOREIGN KEY (region) REFERENCES regions(name)
);
SQL



File.open('db_mysql.sql', 'w') do |f|
  f.puts create_db
  f.puts create_table

  f.puts 'INSERT INTO regions (name, continent, population) VALUES'
  territories = []
  table.each_with_index do |row, idx|
    territory = row['countriesAndTerritories']
    next if territories.include?(territory)

    f.puts ',' unless territories.empty?
    
    territories << territory
    continent = row['continentExp']
    population = row['popData2018'] || POPULATION[territory]
    f.write "('#{territory}', '#{continent}', #{population})"
  end
  f.puts ';'

  f.puts 'INSERT INTO reports (reported_at, cases, deaths, region, continent) VALUES'
  table.each_with_index do |row, idx|
    date = "#{row['year']}-#{row['month']}-#{row['day']}"
    cases = row['cases']
    deaths = row['deaths']
    territory = row['countriesAndTerritories']
    continent = row['continentExp']
    f.write "('#{date}', #{cases}, #{deaths}, '#{territory}', '#{continent}')"
    f.puts ',' if idx < rows - 1
  end
  f.puts ';'
end
