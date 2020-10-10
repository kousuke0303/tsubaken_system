class Matter < ApplicationRecord
  has_many :supplier_matters, dependent: :destroy
  has_many :suppliers, through: :supplier_matters
  belongs_to :client
  has_many :matter_staffs, dependent: :destroy
  has_many :staffs, through: :matter_staffs
  has_many :events, dependent: :destroy
  has_many :matter_tasks, dependent: :destroy
  has_many :tasks, through: :matter_tasks
  
  scope :are_connected_matter_without_own, ->(connected_id, manager) {
    joins(:managers).where(connected_id: connected_id).merge(Manager.where.not(id: manager.id))
  }
  
  def to_param
    matter_uid ? matter_uid : super()
  end  
end
