module ApplicationCable
  
  class Connection < ActionCable::Connection::Base
    
    identified_by :current_user
  
    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.name
    end
    
    protected
      def find_verified_user
        if cookies.signed['admin.id']
          verified_user = Admin.find_by(id: cookies.signed['admin.id'])
          if verified_user && cookies.signed['admin.expires_at'] > Time.now
            verified_user
          else
            reject_unauthorized_connection
          end
        elsif cookies.signed['manager.id']
          verified_user = Manager.find_by(id: cookies.signed['manager.id'])
          if verified_user && cookies.signed['manager.expires_at'] > Time.now
            verified_user
          else
            reject_unauthorized_connection
          end
        elsif cookies.signed['staff.id']
          verified_user = Staff.find_by(id: cookies.signed['staff.id'])
          if verified_user && cookies.signed['staff.expires_at'] > Time.now
            verified_user
          else
            reject_unauthorized_connection
          end
        elsif cookies.signed['external_staff.id']
          verified_user = ExternalStaff.find_by(id: cookies.signed['external_staff.id'])
          if verified_user && cookies.signed['external_staff.expires_at'] > Time.now
            verified_user
          else
            reject_unauthorized_connection
          end
        end
      end

  
    # def connect
    #   reject_unauthorized_connection unless find_verified_user
    # end

    # # private

    # def find_verified_user
    #   self.current_user = env['warden'].user(scope: :admin)
    # end
  end
    
    
    
    # これがないとDEVISEに弾かれる
    # identified_by :current_admin, :current_manager, :current_staff

    # def connect
    #   find_verified
    # end

    # private
    #   def find_verified
    #     setup_admin if verified_admin
    #     setup_manager if verified_manager
    #     setup_staff if verified_staff

    #     reject_unauthorized_connection unless [current_admin, current_manager, current_staff].any?
    #   end
      
    #   def verified_admin
    #     cookies.signed['admin.expires_at'].present? &&
    #     cookies.signed['admin.expires_at'] > Time.zone.now
    #   end

    #   def verified_manager
    #     cookies.signed['manager.expires_at'].present? &&
    #     cookies.signed['manager.expires_at'] > Time.zone.now
    #   end
      
    #   def verified_staff
    #     cookies.signed['staff.expires_at'].present? &&
    #     cookies.signed['staff.expires_at'] > Time.zone.now
    #   end
      
    #   def setup_admin
    #     self.current_admin = Admin.find_by(id: cookies.signed['admin.id'])
    #     logger.add_tags 'ActionCable', "#{current_admin.model_name.name} #{current_admin.id}"
    #   end

    #   def setup_manager
    #     self.current_manager = Manager.find_by(id: cookies.signed['manager.id'])
    #     logger.add_tags 'ActionCable', "#{current_manager.model_name.name} #{current_manager.id}"
    #   end
      
    #   def setup_staff
    #     self.current_staff = Staff.find_by(id: cookies.signed['staff.id'])
    #     logger.add_tags 'ActionCable', "#{current_staff.model_name.name} #{current_staff.id}"
    #   end
    
        # self.current_admin = env['warden'].user(scope: :admin)
        # if cookies.encrypted[Rails.application.config.session_options[:key]]['warden.user.admin.key'].present?
        #   id = cookies.encrypted[Rails.application.config.session_options[:key]]['warden.user.admin.key'][0][0]
        #   if verified_user = Admin.find_by(id: id)
        #     verified_user
        #   end
        # elsif cookies.encrypted[Rails.application.config.session_options[:key]]['warden.user.manager.key'].present?
        #   if verified_user = Manager.find_by(id: cookies.encrypted[Rails.application.config.session_options[:key]]['warden.user.manager.key'][0][0])
        #     verified_user
        #   end
        # elsif cookies.encrypted[Rails.application.config.session_options[:key]]['warden.user.staff.key'].present?
        #   if verified_user = Staff.find_by(id: cookies.encrypted[Rails.application.config.session_options[:key]]['warden.user.staff.key'][0][0])
        #     verified_user
        #   end
        # else
        #   reject_unauthorized_connection
        # end
end
