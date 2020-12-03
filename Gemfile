source 'https://rubygems.org'

gem 'rails',        '~> 5.2.2'
gem 'puma',         '~> 3.7'
gem 'rails-i18n'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'bcrypt'
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks',   '~> 5'
gem 'jbuilder',     '~> 2.5'
gem 'bootstrap',    '~> 4.3.1'
gem "font-awesome-rails"
gem 'font-awesome-sass'
gem 'toastr-rails'
gem 'mechanize'
# Devise
gem 'devise'
# decorator
gem 'active_decorator'
# line_login
gem 'omniauth-line'
# line_login時の偽mail作成
gem 'faker'
# simple_calendar
gem 'simple_calendar', '~> 2.0'
# ラジオボタン生成時に便利なgem
gem 'enum_help'
# ネイティブへのapi発行用
gem 'fast_jsonapi'
# 環境変数設定用
gem 'dotenv-rails'
# AWS S3を利用するためのgem
gem "aws-sdk-s3", require: false
# 画像のリサイズのためのgem
gem 'mini_magick', '~> 4.8'

group :development, :test do
  gem 'mysql2'
  # gem 'byebug',  '9.0.6', platform: :mri
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console',           '3.5.1'
  gem 'listen',                '3.1.5'
  gem 'spring',                '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :production do
  gem 'pg', '0.20.0'
end

# Windows環境では、このgemを含める必要があります。（mac環境でもこのままで問題ありません）
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]