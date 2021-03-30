class Matter < ApplicationRecord
  belongs_to :estimate_matter
  belongs_to :estimate
  belongs_to :publisher, optional: true
  belongs_to :client
  
  has_one :band_connection, dependent: :destroy
  
  has_many :matter_member_codes, dependent: :destroy
  has_many :member_codes, through: :matter_member_codes
  
  has_one :invoice, dependent: :destroy
  has_many :reports, -> { order(position: :asc) }, dependent: :destroy  
  has_one :report_cover, dependent: :destroy
  
  has_many :tasks, dependent: :destroy
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images
  has_many :messages, dependent: :destroy
  has_many :supplier_matters, dependent: :destroy
  has_many :suppliers, through: :supplier_matters
  
  accepts_nested_attributes_for :supplier_matters, allow_destroy: true
  accepts_nested_attributes_for :tasks, allow_destroy: true

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 300 }
  validates :scheduled_started_on, presence: true
  validates :scheduled_finished_on, presence: true
  validate :scheduled_finished_on_is_after_started_on
  
  enum status: { not_started: 0, progress: 1, completed: 2 }
  
  before_create :identify
  after_commit :staff_external_staff_connection_and_task_set, on: :create
  
  scope :join_estimate_matter, ->{ joins(:estimate_matter) }
  
  # matter_status変更
  def change_matter_status
    if self.tasks.where(status: 2).present?
      self.update(status: 1)
    elsif self.tasks.where(status: 1).empty? && self.tasks.where(status: 2).empty?
      self.update(status: 2)
    else
      self.update(status: 0)
    end
  end
  
  def change_invoice(estimate_id)
    ActiveRecord::Base.transaction do
      @matter.update!(estimate_id: estimate_id)
      self.invoice.destroy!
      invoice = self.build_invoice(total_price: self.estimate.total_price,
                                   discount: self.estimate.discount,
                                   plan_name_id: self.estimate.plan_name_id)
      
      invoice.save!
    end
  rescue => e
      Rails.logger.error e.class
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      # bugsnag導入後
      # Bugsnag.notifiy e
  end
  
  private
  
  #----------------------------------------------
    #CALLBACK_METGOD
  #---------------------------------------------
  
    def identify(num = 16)
      self.id ||= SecureRandom.hex(num)
    end
    
    def staff_external_staff_connection_and_task_set
      ActiveRecord::Base.transaction do
        self.tasks.create!(title: "足場架設依頼", status: 1, sort_order: 1) 
        self.tasks.create!(title: "発注依頼", status: 1, sort_order: 2)
        self.estimate_matter.member_codes.each do |member_code|
          self.matter_member_codes.create!(member_code_id: member_code.id)
        end
        invoice = self.build_invoice(total_price: self.estimate.total_price,
                                     discount: self.estimate.discount,
                                     plan_name_id: self.estimate.plan_name_id)
        invoice.save!
      end
    rescue => e
      Rails.logger.error e.class
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      # bugsnag導入後
      # Bugsnag.notifiy e
    end
      
    
  #----------------------------------------------
    #VALIDATE_METHOD
  #---------------------------------------------

    def scheduled_finished_on_is_after_started_on
      if scheduled_finished_on.present? && scheduled_started_on.present? && scheduled_started_on >= scheduled_finished_on
        errors.add(:scheduled_finished_on, "は着工予定日以降を入力してください")
      end
    end
end
