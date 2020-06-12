CollectionPermission.destroy_all
DeckPermission.destroy_all
Membership.destroy_all
Collection.destroy_all
Deck.destroy_all
UserGroup.destroy_all
User.destroy_all


def generate_permissions(value, user, deck, collection, user_group = nil)
  deck_hash = { user: user, deck: deck, read_access: true }
  collection_hash = { user: user, collection: collection, read_access: true }
  user_group_hash = { user: user, user_group: user_group, read_access: true } unless user_group.nil?
  if value == 'update'
    deck_hash[:update_access] = true
    collection_hash[:update_access] = true
    user_group_hash[:update_access] = true
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
      Membership.create!(user_group_hash) unless user_group.nil?
      puts "#{value} access given to #{deck_random}"
      permission = true
    end
  end
end


15.times do
  user = User.create!(email: Faker::Internet.email, password: 'secret')
  deck = Deck.create!(user: user)
  collection = Collection.create!(user: user, deck: deck)
  user_group = UserGroup.create!(user: user, name: Faker::Book.title)
  DeckPermission.create!(user: user, deck: deck, read_access: true, update_access: true, clone_access: true)
  CollectionPermission.create!(user: user, collection: collection, read_access: true, update_access: true, clone_access: true)
  Membership.create!(user: user, user_group: user_group, read_access: true, update_access: true)
  if Deck.count > 5
    generate_permissions('read', user, deck, collection, user_group)
    generate_permissions('update', user, deck, collection, user_group)
    generate_permissions('clone', user, deck, collection)
  end
end

