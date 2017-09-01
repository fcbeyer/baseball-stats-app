class Player < ApplicationRecord
  has_many :battings, :dependent => :destroy
  validates_uniqueness_of :playerID
end
