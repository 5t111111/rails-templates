return unless yes?('Do you really want to use this template?')

gem 'slim-rails'
gem 'puma'

gem_group :development, :test do
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'quiet_assets'
  gem 'rack-mini-profiler', require: false
  gem 'rails_best_practices'
  gem 'rails-footnotes'
  gem 'qtapp'
end

initializer 'rack_profiler.rb', <<-CODE
  if Rails.env == 'development'
    require 'rack-mini-profiler'

    # initialization is skipped so trigger it
    Rack::MiniProfilerRails.initialize!(Rails.application)

    # Display on right
    Rack::MiniProfiler.config.position = 'right'
  end
CODE

gem_group :test do
  gem 'minitest-rails'
  gem 'minitest-rails-capybara'
  gem 'minitest-reporters'
  gem 'minitest-power_assert'
  gem 'launchy'
  gem 'poltergeist'
  gem 'timecop'
  gem 'guard'
  gem 'guard-minitest'
end

if yes?('Do you want to use rails assets?')
  add_source('https://rails-assets.org')
  gem 'rails-assets-bootstrap' if yes?('Do you want to use rails-assets-bootstrap?')
end

install_sorcery = yes?('Do you want to use sorcery?') ? true : false
gem 'sorcery' if install_sorcery

install_kaminari = yes?('Do you want to use kaminari?') ? true : false
gem 'kaminari' if install_kaminari

if yes?('Do you want to use bootstrap?')
  gem 'bootstrap-sass'
  remove_file './app/assets/stylesheets/application.css'
  get 'https://raw.githubusercontent.com/5t111111/rails-templates/master/application-bootstrap.css.scss', './app/assets/stylesheets/application.css.scss'
end

application <<-GENERATORS
config.generators do |g|
  g.template_engine :slim
end
GENERATORS

remove_file './app/views/layouts/application.html.erb'
get 'https://raw.githubusercontent.com/5t111111/rails-templates/master/application.html.slim', './app/views/layouts/application.html.slim'

run 'bundle install'

generate('rails_footnotes:install')
generate('sorcery:install') if install_sorcery
generate('kaminari:config') if install_kaminari

after_bundle do
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end
