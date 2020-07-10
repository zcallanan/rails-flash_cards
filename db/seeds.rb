DeckPermission.destroy_all
Membership.destroy_all
DeckString.destroy_all
CollectionString.destroy_all
QuestionSetString.destroy_all
CardString.destroy_all
UserGroupDeck.destroy_all
TagRelation.destroy_all
Tag.destroy_all
QuestionSet.destroy_all
CollectionCard.destroy_all
Card.destroy_all
Collection.destroy_all
Deck.destroy_all
UserGroup.destroy_all
User.destroy_all
Category.destroy_all

tags = ['best', 'biggest', 'awesome', 'terrible', 'one', 'two', 'annie', 'dog']

tags.each do |tag|
  Tag.create!(name: tag)
end

# TODO: generate list of real categories
category_list = {
  'All' => ['All Categories'],
  'Geography' => ['Countries'],
  'Language' => ['English', 'Spanish', 'French'],
  'Mathematics' => ['Algebra', 'Linear Algebra', 'Calculus'],
  'Science' => ['Biology', 'Chemistry', 'Organic Chemistry']
}

category_list.each do |key, array|
  array.each do |category|
    Category.create!(name: category, theme: key)
  end
end


def generate_permissions(**objects)
  users = []
  users << objects[:user]
  n = 0
  while n < 3
    other_user_chosen = false
    while other_user_chosen == false
      other_user = User.all.sample
      other_user_chosen = true if users.include?(other_user) == false
    end
    users << other_user
    deck_hash = { user: other_user, deck: objects[:deck], read_access: true }
    user_group_hash = { user: other_user, user_group: objects[:user_group], user_label: "friend #{other_user.id}", email_contact: other_user.email, read_access: true } unless n == 2
    if n == 1
      deck_hash[:update_access] = true
      user_group_hash[:update_access] = true
    elsif n == 2
      deck_hash[:clone_access] = true
    end

    permission = false
    until permission
      deck_random = Deck.all.sample
      if deck_random.user != objects[:user]
        DeckPermission.create!(deck_hash)
        Membership.create!(user_group_hash) unless n == 2
        permission = true
      end
    end
    n += 1
  end
end

def create_strings(user, deck, collection, question_set, cards, number)
  strings = {
    en: ["title one #{number}", "description one #{number}", true],
    fr: ["titre premier #{number}", "description un #{number}", false]
  }
  card_strings = {
    en: ["title #{number}", "body #{number}"],
    fr: ["titre #{number}", "corps #{number}"]
  }
  string_hash = {en: [], fr: []}
  cards.each do |card|
    card_strings.each do |key, value|
      CardString.create!(user: user, card: card, language: key, title: value.first, body: value.last)
    end
  end

  strings.each do |key, value|
    string_hash[key] << DeckString.create!(user: user, deck: deck, language: key, title: "Deck #{value[0]} #{deck.id}", description: "Deck #{value[1]} #{deck.id}" )
    string_hash[key] << CollectionString.create!(user: user, collection: collection, language: key, title: "Collection #{value[0]} #{collection.id}", description: "Collection #{value[1]} #{collection.id}" )
    string_hash[key] << QuestionSetString.create!(user: user, question_set: question_set, language: key, title: "Question Set #{value[0]} #{question_set.id}", description: "Question Set #{value[1]} #{question_set.id}" )
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
    n <= 14 ? deck = Deck.create!(user: user, default_language: language, category: Category.all.sample) : deck = Deck.create!(user: user, default_language: language, global_deck_read: true, category: Category.all.sample)
    collection = Collection.create!(user: user, deck: deck, static: true)
    card_list = []
    c = 4
    5.times do
      card_list << Card.create!(deck: deck, user: user)

      CollectionCard.create!(card: card_list.last, collection: collection, priority: c)
      c -= 1
    end

    card_list.each do |card|
      card_tags = Tag.all.sample(2)
      card_tags.each do |tag|
        TagRelation.create!(card: card, tag: tag)
      end
    end

    question_set = QuestionSet.create!(user: user, deck: deck)
    string_hash = create_strings(user, deck, collection, question_set, card_list, x)
    x += 1
    user_group = UserGroup.create!(user: user, name: Faker::Book.title)
    ug_deck = UserGroupDeck.create!(user_group: user_group, deck: deck)

    DeckPermission.create!(user: user, deck: deck, read_access: true, update_access: true, clone_access: true)
    Membership.create!(user: user, user_group: user_group, user_label: 'Group Owner', status: 'Managing Group', email_contact: email, read_access: true, update_access: true)
    if User.count > 8
      object_hash = {
        user: user,
        deck: deck,
        user_group: user_group
      }
      generate_permissions(object_hash)
    end
  end
end

puts 'finished seed!'




