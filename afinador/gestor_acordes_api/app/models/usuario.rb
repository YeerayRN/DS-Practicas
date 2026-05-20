class Usuario < ApplicationRecord
  has_many :acordes
  
  validates :nombre, uniqueness: true, presence: true
end
