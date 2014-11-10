class TttGame < ActiveRecord::Base
  belongs_to :user
  belongs_to :ttt
end