class Trip < ApplicationRecord
  belongs_to :user
  has_many :participants, dependent: :destroy
  has_many :expenses, dependent: :destroy # 👈 add this line
  accepts_nested_attributes_for :participants, allow_destroy: true, reject_if: proc { |attrs| attrs["name"].blank? }
end
