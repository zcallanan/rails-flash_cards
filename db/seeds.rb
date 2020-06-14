CollectionPermission.destroy_all
DeckPermission.destroy_all
QuestionSetPermission.destroy_all
Membership.destroy_all
DeckString.destroy_all
CollectionString.destroy_all
QuestionSetString.destroy_all
TagSetString.destroy_all
TagSet.destroy_all
QuestionSet.destroy_all
Collection.destroy_all
Deck.destroy_all
UserGroup.destroy_all
User.destroy_all


def generate_permissions(value, user, deck, collection, question_set, user_group = nil)
  deck_hash = { user: user, deck: deck, read_access: true }
  collection_hash = { user: user, collection: collection, read_access: true }
  question_set_hash = { user: user, question_set: question_set, read_access: true }
  user_group_hash = { user: user, user_group: user_group, read_access: true } unless user_group.nil?
  if value == 'update'
    deck_hash[:update_access] = true
    collection_hash[:update_access] = true
    question_set_hash[:update_access] = true
    user_group_hash[:update_access] = true
  elsif value == 'clone'
    deck_hash[:clone_access] = true
    collection_hash[:clone_access] = true
    question_set_hash[:clone_access] = true
  end

  permission = false
  until permission
    deck_random = Deck.all.sample
    if deck_random.user != user
      DeckPermission.create!(deck_hash)
      CollectionPermission.create!(collection_hash)
      QuestionSetPermission.create!(question_set_hash)
      Membership.create!(user_group_hash) unless user_group.nil?
      puts "#{value} access given to #{deck_random}"
      permission = true
    end
  end
end

def create_strings(deck, collection, question_set, tag_set, number)
  strings = {
    en: ["title one #{number}", "description one #{number}"],
    fr: ["titre premier #{number}", "description un #{number}"],
    de: ["Titel eins #{number}", "Beschreibung ein #{number}"],
    ru: ["заглавие первое #{number}", "первое описание #{number}"]
  }
  strings.each do |key, value|
    DeckString.create!(deck: deck, language: key, title: "Deck #{value[0]} #{(1..100).to_a.sample}", description: "Deck #{value[1]} #{[1..100].sample}" )
    CollectionString.create!(collection: collection, language: key, title: "Collection #{value[0]} #{(1..100).to_a.sample}", description: "Collection #{value[1]} #{(1..100).to_a.sample}" )
    QuestionSetString.create!(question_set: question_set, language: key, title: "Question Set #{value[0]} #{(1..100).to_a.sample}", description: "Question Set #{value[1]} #{(1..100).to_a.sample}" )
    TagSetString.create!(tag_set: tag_set, language: key, title: "Tag Set #{value[0]} #{(1..100).to_a.sample}", description: "Tag Set #{value[1]} #{(1..100).to_a.sample}" )
  end
end

n = 0
x = 0
15.times do
  user = User.create!(email: "z#{n}@example.com", password: 'secret')
  n += 1
  3.times do
    deck = Deck.create!(user: user)
    collection = Collection.create!(user: user, deck: deck)
    question_set = QuestionSet.create!(user: user, deck: deck)
    tag_set = TagSet.create!(user: user)
    create_strings(deck, collection, question_set, tag_set, x)
    x += 1
    user_group = UserGroup.create!(user: user, name: Faker::Book.title)
    DeckPermission.create!(user: user, deck: deck, read_access: true, update_access: true, clone_access: true)
    CollectionPermission.create!(user: user, collection: collection, read_access: true, update_access: true, clone_access: true)
    QuestionSetPermission.create!(user: user, question_set: question_set, read_access: true, update_access: true, clone_access: true)
    Membership.create!(user: user, user_group: user_group, read_access: true, update_access: true)
    if Deck.count > 5
      generate_permissions('read', user, deck, collection, question_set, user_group)
      generate_permissions('update', user, deck, collection, question_set, user_group)
      generate_permissions('clone', user, deck, collection, question_set)
    end
  end
end

