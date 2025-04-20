class Expense < ApplicationRecord
  belongs_to :trip

  has_many :expense_participants, dependent: :destroy
  has_many :participants, through: :expense_participants

  # this line allows Rails to save participant_ids from a form
  accepts_nested_attributes_for :expense_participants, allow_destroy: true
end
