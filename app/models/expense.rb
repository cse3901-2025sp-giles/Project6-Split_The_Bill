class Expense < ApplicationRecord
  belongs_to :trip

  has_many :expense_participants, dependent: :destroy
  has_many :participants, through: :expense_participants

  accepts_nested_attributes_for :expense_participants, allow_destroy: true

  #basic validations
  validates :description, :amount, :date, presence: true
  validates :amount, numericality: { greater_than: 0 }
end
