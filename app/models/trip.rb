class Trip < ApplicationRecord
  belongs_to :user
  has_many :participants, dependent: :destroy
  has_many :expenses, dependent: :destroy

  accepts_nested_attributes_for :participants, allow_destroy: true, reject_if: proc { |attrs| attrs["name"].blank? }

  #Basic validations
  validates :name, :start_date, :end_date, presence: true
end
