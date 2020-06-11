CollectionPermission.destroy_all
DeckPermission.destroy_all
Collection.destroy_all
Deck.destroy_all
User.destroy_all


def generate_permissions(value, user, deck, collection)
  deck_hash = { user: user, deck: deck, read_access: true }
  collection_hash = { user: user, collection: collection, read_access: true }
  if value == 'update'
    deck_hash[:update_access] = true
    collection_hash[:update_access] = true
  elsif value == 'clone'
    deck_hash[:clone_access] = true
    collection_hash[:clone_access] = true
  end

  permission = false
  until permission
    deck_random = Deck.all.sample
    if deck_random.user != user
      DeckPermission.create!(deck_hash)
      CollectionPermission.create!(collection_hash)
      puts "read access given to #{deck_random}"
      permission = true
    end
  end
end


15.times do
  user = User.create!(email: Faker::Internet.email, password: 'secret')
  deck = Deck.create!(user: user)
  collection = Collection.create!(user: user, deck: deck)
  DeckPermission.create!(user: user, deck: deck, read_access: true, update_access: true, clone_access: true)
  CollectionPermission.create!(user: user, collection: collection, read_access: true, update_access: true, clone_access: true)
  if Deck.count >= 9
    generate_permissions('read', user, deck, collection)
    generate_permissions('update', user, deck, collection)
    generate_permissions('clone', user, deck, collection)
  end
end

