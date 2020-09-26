class Matter < ApplicationRecord
  has_many :matter_staffs, dependent: :destroy
  has_many :staffs, through: :matter_staffs
  has_many :matter_users, dependent: :destroy
  has_many :users, through: :matter_users
  has_many :clients, dependent: :destroy
  accepts_nested_attributes_for :clients, allow_destroy: true
  has_many :events, dependent: :destroy
  has_many :matter_tasks, dependent: :destroy
  has_many :tasks, through: :matter_tasks
  
  # ## scope #########################################
  scope :are_connected_matter_without_own, ->(connected_id, manager) {
    joins(:managers).where(connected_id: connected_id).merge(Manager.where.not(id: manager.id))
  }
  
  def to_param
    matter_uid ? matter_uid : super()
  end  
end
