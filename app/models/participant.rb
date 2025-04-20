class Participant < ApplicationRecord
  belongs_to :trip

  has_many :expense_participants, dependent: :destroy
  has_many :expenses, through: :expense_participants  # expenses this person was part of
end
