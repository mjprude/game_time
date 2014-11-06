class Hangman < ActiveRecord::Base
  belongs_to :user

  before_create do
    self.word = random_word
    self.game_state = self.word.gsub(/\w/, '_')
  end

  def random_word
    # ['MONKEY', 'LEMUR', 'BABOON', 'ORANGUTAN', 'CHIMP', 'SPIDER MONKEY', 'THREE-TOED SLOTH'].sample
    countries = HTTParty.get('http://restcountries.eu/rest/v1/all')
    words = []
    countries.each do |hash|
      words << "#{hash['capital'].parameterize.upcase.gsub('-', ' ')}, #{hash['name'].parameterize.upcase.gsub('-', ' ')}"
    end
    words.sample
  end

  def guess(letter)
    game_state_will_change!
    bad_guesses_will_change!
    correct = false
    self.word.chars.each_with_index do |char, i|
      if char == letter
        self.game_state[i] = letter
        correct = true
      end
    end
    if !correct
      self.bad_guesses += letter
    end
    self.save!
    victory
  end

  def victory
    !self.game_state.include?('_')
  end

  def fail_count
    self.bad_guesses.length
  end

  def data
    {bad_guesses: self.bad_guesses, game_state: self.game_state, victory: victory, fail_count: fail_count, category: self.category}.to_json
  end

end