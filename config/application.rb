require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DeviseLoginSystem
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.assets.initialize_on_precompile = false
    config.i18n.default_locale = :ja
    config.load_defaults 5.1
    # 表示時のタイムゾーンをJSTに設定
    config.time_zone = 'Asia/Tokyo'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]
    config.autoload_paths += %W(#{config.root}/lib)
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
