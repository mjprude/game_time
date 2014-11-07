class Hangman < ActiveRecord::Base
  belongs_to :user

  before_create do
    self.pull_data
    self.game_state = self.word.gsub(/\w/, '_')
  end

  def random_word(hash)
    self.word = hash.keys.sample
    self.latlng = hash[self.word]
  end

  def pull_data
    countries = HTTParty.get('http://restcountries.eu/rest/v1/all')
    words = {}
    countries.each do |hash|
      cap_name = "#{hash['capital'].parameterize.upcase.gsub('-', ' ')}, #{hash['name'].parameterize.upcase.gsub('-', ' ')}"
      words[cap_name] = hash['latlng'].join(', ')
    end
    random_word(words)
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
    {bad_guesses: self.bad_guesses, game_state: self.game_state, victory: victory, fail_count: fail_count, latlng: self.latlng}.to_json
  end

end