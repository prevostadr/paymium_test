# frozen_string_literal: true

begin
  Dir[Rails.root.join('db/seeds/0*.rb')].sort.each do |seed|
    printf "-> ⌛️ Seed #{seed} starting"
    start = Time.current
    load seed
    finish = Time.current
    diff = finish - start

    printf "\r-> ✅ Seed #{seed} loaded in #{diff} seconds\n"
  end
rescue StandardError => error
  raise error
end
