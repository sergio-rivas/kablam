# frozen_string_literal: true

require 'rails/generators/base'
module Kablam
  module Generators
    class InstallGenerator < Rails::Generators::Base
      namespace "kablam:install"
      source_root File.expand_path('../templates', __FILE__)
      # argument :name, :type => :string, :default => "en"

      # Change ApplicationRecord's inheritence
      gsub_file 'app/models/application_record.rb', 'class ApplicationRecord < ActiveRecord::Base', 'class ApplicationRecord < Kablam::KablamRecord'

      # Setup Initializer
      template "kablam.rb", "config/initializers/kablam.rb"
      template "_sample_target_item.html.erb", "app/views/kablam/models/_sample_target_item.html.erb"

      def setup_routes
        route "# KABLAM! form/create/update/destroy/undo for all models"
        route "# Note: Make sure Kablam engine is at the BOTTOM of routes"
        route "# helpers to use KABLAM! [examples w/ 'posts' model)"
        route "# --->  kablam.form_path('posts')"
        route "#  (if edit form, must add '?id=\#\{@post.id\}' at end of path)"
        route "# --->  kablam.create_path('posts')"
        route "# --->  kablam.delete_path('posts', @post)"
        route "# --->  kablam.update_path('posts', @post)"
        route "# --->  kablam.undo_path('posts', @post)"
        route "mount Kablam::Engine => '/kablam', as: 'kablam'"
      end

      def setup_assets
        inject_into_file 'app/assets/javascripts/application.js', before: "//=require_tree ." do
          "//=require kablam/ajax"
          "//=require kablam/forms\n"
        end
        prepend_file 'app/assets/stylesheets/application.css.scss', "@import 'kablam';"
      end

      readme "README"
    end
  end
end
