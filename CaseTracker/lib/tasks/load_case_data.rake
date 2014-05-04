namespace :cases do
  desc 'Inserting new case data into the local DB'
  task load_case_data: :environment do
    puts 'Loading data...'
    Case.load_data
  end
end