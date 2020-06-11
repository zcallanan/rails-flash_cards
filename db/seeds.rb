# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

CollectionPermission.destroy_all
DeckPermission.destroy_all
Collection.destroy_all
Deck.destroy_all
User.destroy_all


15.times do
  user = User.create!(email: Faker::Internet.email, password: Faker::Internet.password(min_length: 6))
  deck = Deck.create!(user: user)
  collection = Collection.create!(user: user, deck: deck)
  DeckPermission.create!(user: user, deck: deck, read_access: true, update_access: true, clone_access: true)
  CollectionPermission.create!(user: user, collection: collection, read_access: true, update_access: true, clone_access: true)
  if Deck.count >= 7
    permission = false
    until permission
      deck_random = Deck.all.sample
      if deck_random.user != user
        DeckPermission.create!(user: user, deck: deck_random, read_access: true)
        CollectionPermission.create!(user: user, collection: collection, read_access: true)
        puts "read access given to #{deck_random}"
        permission = true
      end
    end
    permission = false
    until permission
      deck_random = Deck.all.sample
      if deck_random.user != user
        DeckPermission.create!(user: user, deck: deck_random, read_access: true, update_access: true)
        CollectionPermission.create!(user: user, collection: collection, read_access: true, update_access: true)
        puts "read & write access given to #{deck_random}"
        permission = true
      end
    end
  end
end

