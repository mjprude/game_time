module Sinatra
  module LetterHelper

    def letterbank
      string = ""
      (A..Z).each do |letter|
        string << "<div id='#{letter}' class='letterbank'>#{letter}</div>"
      end
      string
    end
  end
  helpers LetterHelper
end