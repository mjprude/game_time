module Sinatra
  module LetterHelper

    def letterbank
      string = ""
      ('A'..'Z').each do |letter|
        string << "<button id='#{letter}' class='letterbank'>#{letter}</button>"
      end
      string
    end
  end
  helpers LetterHelper
end