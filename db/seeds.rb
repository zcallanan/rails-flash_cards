puts 'destroying...'
UserLog.destroy_all
DeckPermission.destroy_all
Membership.destroy_all
DeckString.destroy_all
CollectionString.destroy_all
QuestionString.destroy_all
CardString.destroy_all
UserGroupDeck.destroy_all
TagRelation.destroy_all
QuestionRelation.destroy_all
Tag.destroy_all
CollectionCard.destroy_all
Review.destroy_all
Answer.destroy_all
Question.destroy_all
Card.destroy_all
Collection.destroy_all
Deck.destroy_all
UserGroup.destroy_all
User.destroy_all
Category.destroy_all

puts 'seeding...'

tags = ['best', 'biggest', 'awesome', 'terrible', 'one', 'two', 'annie', 'dog', 'cat', 'squirrel']

tags.each do |tag|
  Tag.create!(name: tag)
end

# TODO: generate list of real categories
category_list = {
  'All' => ['All Categories'],
  'Geography' => ['Countries'],
  'Language' => ['English Language', 'Spanish Language', 'French Language'],
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
        deck_permission = DeckPermission.create!(deck_hash)
        UserLog.create!(user: deck_hash[:user], deck_permission: deck_permission, event: 'Deck access granted')
        membership = Membership.create!(user_group_hash) unless n == 2
        UserLog.create!(user: user_group_hash[:user], membership: membership, event: 'User Group access granted')
        permission = true
      end
    end
    n += 1
  end
end

def create_strings(user, deck, collection, cards, number)
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
      card_string = CardString.create!(user: user, card: card, language: key, title: value.first, body: value.last)
      UserLog.create!(user: user, card: card, card_string: card_string, event: 'Card string created')
    end
  end

  strings.each do |key, value|
    string_hash[key] << DeckString.create!(user: user, deck: deck, language: key, title: "Deck #{value[0]} #{deck.id}", description: "Deck #{value[1]} #{deck.id}" )
    UserLog.create!(user: user, deck_string: string_hash[key].last, deck: deck, event: 'Deck string created')
    string_hash[key] << CollectionString.create!(user: user, collection: collection, language: key, title: "Collection #{value[0]} #{collection.id}", description: "Collection #{value[1]} #{collection.id}" )
    UserLog.create!(user: user, collection_string: string_hash[key].last, collection: collection, event: 'Collection string created')
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
    UserLog.create!(user: user, deck: deck, event: 'Deck created')
    5.times do
      review = Review.create!(user: user, deck: deck, rating: (1..5).to_a.sample, title: Faker::Lorem.sentence(word_count: 5, supplemental: true, random_words_to_add: 8), body: Faker::Lorem.sentence(word_count: 15, supplemental: true, random_words_to_add: 12))
      UserLog.create!(user: user, review: review, deck: deck, event: 'Review created')
    end
    # default collection created for a deck
    collection = Collection.create!(user: user, deck: deck, static: true)
    UserLog.create!(user: user, collection: collection, event: 'All Cards collection created')
    collection_string = CollectionString.create!(collection: collection, user: user, language: deck.default_language, title: 'All Cards', description: 'Review all cards in this deck.')
    UserLog.create!(user: user, collection_string: collection_string, collection: collection, event: 'All cards collection string created')
    # custom collection created for a deck
    collection = Collection.create!(user: user, deck: deck, static: false)
    UserLog.create!(user: user, collection: collection, event: 'Collection created')

    card_list = []
    c = 4
    5.times do
      card_list << Card.create!(deck: deck, user: user)
      UserLog.create!(user: user, card: card_list.last, event: 'Card created')

      collection_card = CollectionCard.create!(card: card_list.last, collection: collection, priority: c)
      UserLog.create!(user: user, collection_card: collection_card, card: card_list.last, collection: collection, event: 'Card added to collection')
      c -= 1
    end

    card_list.each do |card|
      # the default question that each card has. This is not editable. Custom questions are static false
      question = Question.create!(user: user, static: true)
      # when reviewing cards, each card has one question by default. This is an open-ended question where they can enter an answer.
      QuestionString.create!(question: question, user: user, language: deck.default_language, title: 'Default', body: 'Your response to the card')
      question_relation = QuestionRelation.create!(user: user, deck: deck, card: card, question: question)
      UserLog.create!(user: user, question_relation: question_relation, event: 'Question set created')
      card_tags = Tag.all.sample(2)
      card_tags.each do |tag|
        tag_relation = TagRelation.create!(card: card, tag: tag)
        UserLog.create!(user: user, tag_relation: tag_relation, card: card, tag: tag, event: 'Tag added to card')
      end
    end


    string_hash = create_strings(user, deck, collection, card_list, x)
    x += 1
    user_group = UserGroup.create!(user: user, name: Faker::Book.title)
    UserLog.create!(user: user, user_group: user_group, event: 'User Group created')
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




