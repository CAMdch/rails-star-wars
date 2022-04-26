class Movie < ApplicationRecord
  has_many :teams, dependent: :destroy
  has_many :characters, through: :teams

  validates :title, uniqueness: true
end
