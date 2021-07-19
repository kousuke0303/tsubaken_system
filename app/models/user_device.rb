class UserDevice < ApplicationRecord
  after_commit :set_platform
  
  belongs_to :member_code
  
  validates :instance_id, presence: true, uniqueness: true

  private
    def set_platform
      if self.platform.nil?
        scope = 'https://www.googleapis.com/auth/firebase.messaging'
        authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
          json_key_io: File.open("./app/assets/firebase-adminsdk.json"),
          scope: scope
        )
      
        access_token = authorizer.fetch_access_token!

        uri = URI.parse("https://iid.googleapis.com/iid/info/#{self.instance_id}?details=true")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        req = Net::HTTP::Get.new(uri.request_uri)
        req['Authorization'] = "key=AAAAvsfqWHA:APA91bHXVRt5w-1AfBded3K59x7El02XZYnl-b9F_pJxhiDDGHUVR1hXfT_PnIPeD5sStLyaidyGxQz0GwaGSvcksm9fAB4Q7--cBa1j1BLkgTpWc-mIPRg83FCy-IHWewicTmqcK-4K"
        res = http.request(req)
        if res.code == "200"
          response = JSON.parse(res.body)
          platform = response['platform']
          self.update(platform: platform)
        end
      end
    end
      
end
