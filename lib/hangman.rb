class Hangman < ActiveRecord::Base
  belongs_to :user

  before_create do
    self.word = random_word
  end

  def random_word
    ['MONKEY', 'LEMUR', 'BABOON', 'ORANGUTAN', 'CHIMP', 'SPIDER MONKEY', 'THREE-TOED SLOTH'].sample
  end

  def guess(letter)
    game_state_will_change!
    if !self.game_state
      self.game_state = self.word.gsub(/\w/, '_')
    end
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
    # self.update({game_state: self.game_state, bad_guesses: self.bad_guesses})
    victory
  end

  def victory
    !self.game_state.include?('_')
  end

  def fail_count
    self.bad_guesses.length
  end

end