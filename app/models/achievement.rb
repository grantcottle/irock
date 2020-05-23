class Achievement < ApplicationRecord
  validates :title, presence: true
  enum privacies: [:public_access, :private_access, :firends_access]
end
