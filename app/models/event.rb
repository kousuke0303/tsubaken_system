class Event < ApplicationRecord
  belongs_to :manager
  belongs_to :matter
end
