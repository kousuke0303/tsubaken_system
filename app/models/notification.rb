class Notification < ApplicationRecord
  
  after_commit :auto_delete, on: :update
  after_commit :push_notification, on: :create
  
  belongs_to :schedule, optional: true
  belongs_to :task, optional: true
  belongs_to :construction_report, optional: true
  belongs_to :construction_schedule, optional: true
  
  belongs_to :sender, class_name: 'MemberCode', foreign_key: 'sender_id', optional: true
  belongs_to :reciever, class_name: 'MemberCode', foreign_key: 'reciever_id', optional: true

  enum status: { active: 0, close: 1 }
  enum category: { not_set: 0, schedule: 1, task: 2, report: 3, construction_schedule: 4 }
  enum action_type: { creation: 0, updation: 1, deletion: 2 }
  
  scope :creation_notification_for_schedule, -> { where(status: 0, category: 1, action_type: 0) }
  scope :updation_notification_for_schedule, -> { where(status: 0, category: 1, action_type: 1) }
  scope :delete_notification_for_schedule, -> { where(status: 0, category: 1, action_type: 2) }
  scope :creation_notification_for_task, -> { where(status: 0, category: 2, action_type: 0) }
  scope :updation_notification_for_task, -> { where(status: 0, category: 2, action_type: 1) }
  scope :delete_notification_for_task, -> { where(status: 0, category: 2, action_type: 2) }
  scope :creation_notification_for_report, -> { where(status: 0, category: 3, action_type: 0)}
  scope :creation_notification_for_construction_schedule, -> { where(status: 0, category: 4, action_type: 0) }
  scope :updation_notification_for_construction_schedule, -> { where(status: 0, category: 4, action_type: 1) }
  scope :delete_notification_for_construction_schedule, -> { where(status: 0, category: 4, action_type: 2) }
  
  private
  
    def auto_delete
      self.destroy if self.status == "close"
    end
   
    def push_notification
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open("./app/assets/firebase-adminsdk.json"),
        scope: 'https://www.googleapis.com/auth/firebase.messaging'
      )
      access_token = authorizer.fetch_access_token!
      access_key = "#{access_token['token_type']} #{access_token['access_token']}"
     
      reciever_user_devices = MemberCode.find(reciever_id).user_devices
      
      body = {
        message: {
          token: reciever_user_devices.first.instance_id,
          notification: {
            title: 'Emperor-Paint',
            body: '新着情報があります',
            # icon: File.expand_path("appicon/icon-72x72.png")
          },
          # android: {
          #   notification: {
          #     channel_id: 'test_category' # Android 向けの通知カテゴリ
          #   }
          # },
          # apns: {
          #   payload: {
          #     aps: {
          #       sound: 'default', # 通知音
          #       badge: 1          # iOS のホーム画面でのバッジ更新用
          #     }
          #   }
          # },
          # webpush: {
          #   headers: {
          #     TTL: "86400"
          #   }
          # }
        }
      }
    
      uri = URI.parse('https://fcm.googleapis.com/v1/projects/emperor-paint-18f69/messages:send')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new(uri)
      req['Content-Type'] = 'application/json'
      req['Authorization'] = "Bearer #{access_token['access_token']}"
      req.body = body.to_json
      res = http.request(req)
      puts res.code
    end
    
end
