DeckCategory.destroy_all
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
Category.destroy_all

# TODO: generate list of real categories
category_list = ['English', 'Spanish', 'French', 'Biology', 'Chemistry', 'Organic Chemistry', 'Algebra', 'Linear Algebra', 'Calculus']

category_list.each do |category|
  Category.create!(name: category)
end


def generate_permissions(value, string_hash, user, deck, collection, question_set, tag_set = nil, user_group = nil, languages= [:en, :fr])
  languages.each do |language|
    other_user_chosen = false
    while other_user_chosen == false
      other_user = User.all.sample
      other_user_chosen = true if other_user != user
    end
    deck_hash = { user: other_user, deck: deck, deck_string: string_hash[language][0], language: language, read_access: true }
    collection_hash = { user: other_user, collection: collection, collection_string: string_hash[language][1], language: language, read_access: true }
    question_set_hash = { user: other_user, question_set: question_set, question_set_string: string_hash[language][2], language: language, read_access: true }
    tag_set_hash = { user: other_user, tag_set: tag_set, tag_set_string: string_hash[language][3], language: language, read_access: true } unless tag_set.nil?
    user_group_hash = { user: other_user, user_group: user_group, user_label: "friend #{other_user.id}", owner_id: user.id, email_contact: other_user.email, read_access: true } unless user_group.nil?
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
end

def create_strings(user, deck, collection, question_set, tag_set, number)
  strings = {
    en: ["title one #{number}", "description one #{number}", true],
    fr: ["titre premier #{number}", "description un #{number}", false]
    # de: ["Titel eins #{number}", "Beschreibung ein #{number}", false],
    # ru: ["заглавие первое #{number}", "первое описание #{number}", false]
  }
  string_hash = {en: [], fr: []}
  strings.each do |key, value|
    string_hash[key] << DeckString.create!(user: user, deck: deck, language: key, title: "Deck #{value[0]} #{deck.id}", description: "Deck #{value[1]} #{deck.id}" )
    string_hash[key] << CollectionString.create!(user: user, collection: collection, language: key, title: "Collection #{value[0]} #{collection.id}", description: "Collection #{value[1]} #{collection.id}" )
    string_hash[key] << QuestionSetString.create!(user: user, question_set: question_set, language: key, title: "Question Set #{value[0]} #{question_set.id}", description: "Question Set #{value[1]} #{question_set.id}" )
    string_hash[key] << TagSetString.create!(user: user, tag_set: tag_set, language: key, title: "Tag Set #{value[0]} #{tag_set.id}", description: "Tag Set #{value[1]} #{tag_set.id}" )
  end
  string_hash
end

n = 0
x = 0
languages = [:en, :fr]

15.times do
  email = "pups#{n}@example.com"
  user = User.create!(email: email, password: 'secret', language: languages.sample)
  n += 1
  languages.each do |language|
    n <= 14 ? deck = Deck.create!(user: user, default_language: language) : deck = Deck.create!(user: user, default_language: language, global_deck_read: true)
    collection = Collection.create!(user: user, deck: deck)
    question_set = QuestionSet.create!(user: user, deck: deck)
    tag_set = TagSet.create!(user: user, deck: deck)
    string_hash = create_strings(user, deck, collection, question_set, tag_set, x)
    x += 1
    user_group = UserGroup.create!(user: user, name: Faker::Book.title)
    DeckPermission.create!(user: user, deck: deck, deck_string: string_hash[language][0], language: language, read_access: true, update_access: true, clone_access: true)
    CollectionPermission.create!(user: user, collection: collection, collection_string: string_hash[language][1], language: language, read_access: true, update_access: true, clone_access: true)
    QuestionSetPermission.create!(user: user, question_set: question_set, question_set_string: string_hash[language][2], language: language, read_access: true, update_access: true, clone_access: true)
    TagSetPermission.create!(user: user, tag_set: tag_set, tag_set_string: string_hash[language][3], language: language, read_access: true, update_access: true)
    Membership.create!(user: user, user_group: user_group, user_label: 'Group Owner', status: 'Managing Group', owner_id: user.id, email_contact: email, read_access: true, update_access: true)
    if User.count > 8
      generate_permissions('read', string_hash, user, deck, collection, question_set, tag_set, user_group)
      generate_permissions('update', string_hash, user, deck, collection, question_set, tag_set, user_group)
      generate_permissions('clone', string_hash, user, deck, collection, question_set)
    end
  end
end




