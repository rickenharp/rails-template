gem "haml-rails"

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"

# pry

gem_group :development do
  gem "pry-rails"
end
run "bundle install"
git :add => "."
git :commit => "-a -m 'Use pry instead of irb'"

# factory_girl

gem_group :development, :test do
  gem "factory_girl_rails"
end
run "bundle install"
git :add => "."
git :commit => "-a -m 'Add factory_girl'"

# rspec

gem_group :development, :test do
  gem "rspec-rails"
end
run "bundle install"
generate('rspec:install')
git :add => "."
git :commit => "-a -m 'Add rspec'"

# bourbon, neat and bitters

gem "bourbon"
gem "neat"
gem "bitters"

run "bundle install"
run "cd app/assets/stylesheets && bitters install"

File.unlink("app/assets/stylesheets/application.css")
File.open('app/assets/stylesheets/application.scss','w') do |f|
  f.puts <<-EOF
@import "bourbon";
@import "base/base";
@import "neat";

.container {
  @include outer-container;
}
EOF
end


run "rm app/views/layouts/application.html.erb"
File.open('app/views/layouts/application.html.haml', 'w') do |f|
  f.puts <<-EOF
!!!
%html
  %head
    %title Application Title
    %meta{:name => 'viewport', :content => 'width=device-width,initial-scale=1'}
    = stylesheet_link_tag    "application", :media => "all"
    = javascript_include_tag "application"
    = csrf_meta_tags
  %body
    %div.container
      = yield
  EOF
end

git :add => "."
git :commit => "-a -m 'Add bourbon, neat and bitters'"

generate(:controller, "welcome", "index")
route "root :to => 'welcome#index'"
rake("db:migrate")

git :add => "."
git :commit => "-a -m 'Create welcome controller'"
