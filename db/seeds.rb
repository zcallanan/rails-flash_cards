CollectionPermission.destroy_all
DeckPermission.destroy_all
QuestionSetPermission.destroy_all
TagSetPermission.destroy_all
Membership.destroy_all
DeckString.destroy_all
CollectionString.destroy_all
QuestionSetString.destroy_all
TagSetString.destroy_all
UserGroupDeck.destroy_all
UserGroupCollection.destroy_all
UserGroupQuestionSet.destroy_all
UserGroupTagSet.destroy_all
TagSet.destroy_all
QuestionSet.destroy_all
Collection.destroy_all
Deck.destroy_all
UserGroup.destroy_all
User.destroy_all


def generate_permissions(value, string_array, user, deck, collection, question_set, tag_set = nil, user_group = nil)
  deck_hash = { user: user, deck: deck, deck_string: string_array[0], language: 'en', read_access: true }
  collection_hash = { user: user, collection: collection, collection_string: string_array[1], read_access: true }
  question_set_hash = { user: user, question_set: question_set, question_set_string: string_array[2], read_access: true }
  tag_set_hash = { user: user, tag_set: tag_set, tag_set_string: string_array[3], read_access: true } unless tag_set.nil?
  user_group_hash = { user: user, user_group: user_group, read_access: true } unless user_group.nil?
  if value == 'update'
    deck_hash[:update_access] = true
    collection_hash[:update_access] = true
    question_set_hash[:update_access] = true
    tag_set_hash[:update_access] = true
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
      TagSetPermission.create!(tag_set_hash) unless tag_set.nil?
      Membership.create!(user_group_hash) unless user_group.nil?
      puts "#{value} access given to #{deck_random}"
      permission = true
    end
  end
end

def create_strings(deck, collection, question_set, tag_set, number)
  strings = {
    en: ["title one #{number}", "description one #{number}", true],
    fr: ["titre premier #{number}", "description un #{number}", false],
    de: ["Titel eins #{number}", "Beschreibung ein #{number}", false],
    ru: ["заглавие первое #{number}", "первое описание #{number}", false]
  }
  string_array = []
  strings.each do |key, value|
    string_array << DeckString.create!(deck: deck, language: key, global_access: value[2], title: "Deck #{value[0]} #{(1..100).to_a.sample}", description: "Deck #{value[1]} #{[1..100].to_a.sample}" )
    string_array << CollectionString.create!(collection: collection, language: key, title: "Collection #{value[0]} #{(1..100).to_a.sample}", description: "Collection #{value[1]} #{(1..100).to_a.sample}" )
    string_array << QuestionSetString.create!(question_set: question_set, language: key, title: "Question Set #{value[0]} #{(1..100).to_a.sample}", description: "Question Set #{value[1]} #{(1..100).to_a.sample}" )
    string_array << TagSetString.create!(tag_set: tag_set, language: key, title: "Tag Set #{value[0]} #{(1..100).to_a.sample}", description: "Tag Set #{value[1]} #{(1..100).to_a.sample}" )
  end
  string_array
end

n = 0
x = 0
15.times do
  user = User.create!(email: "z#{n}@example.com", password: 'secret')
  n += 1
  2.times do
    n <= 14 ? deck = Deck.create!(user: user) : deck = Deck.create!(user: user, global_deck_read: true)
    collection = Collection.create!(user: user, deck: deck)
    question_set = QuestionSet.create!(user: user, deck: deck)
    tag_set = TagSet.create!(user: user)
    string_array = create_strings(deck, collection, question_set, tag_set, x)
    x += 1
    user_group = UserGroup.create!(user: user, name: Faker::Book.title)
    DeckPermission.create!(user: user, deck: deck, deck_string: string_array[0], read_access: true, update_access: true, clone_access: true)
    CollectionPermission.create!(user: user, collection: collection, collection_string: string_array[1], read_access: true, update_access: true, clone_access: true)
    QuestionSetPermission.create!(user: user, question_set: question_set, question_set_string: string_array[2], read_access: true, update_access: true, clone_access: true)
    TagSetPermission.create!(user: user, tag_set: tag_set, tag_set_string: string_array[3], read_access: true, update_access: true)
    Membership.create!(user: user, user_group: user_group, read_access: true, update_access: true)
    if Deck.count > 10
      user = User.all.sample
      generate_permissions('read', string_array, user, deck, collection, question_set, tag_set, user_group)
      user = User.all.sample
      generate_permissions('update', string_array, user, deck, collection, question_set, tag_set, user_group)
      user = User.all.sample
      generate_permissions('clone', string_array, user, deck, collection, question_set)
    end
  end
end

