# frozen_string_literal: true

module Kablam
  module Generators
    class InstallGenerator < Rails::Generators::Base
      namespace "kablam:install"
      source_root File.expand_path('../templates', __FILE__)
      # argument :name, :type => :string, :default => "en"
      def basic_setup
        # Change ApplicationRecord's inheritence
        gsub_file 'app/models/application_record.rb', 'class ApplicationRecord < ActiveRecord::Base', 'class ApplicationRecord < Kablam::KablamRecord'

        # Setup Initializer
        template "kablam.rb", "config/initializers/kablam.rb"
        copy_file "_sample_target_item.html.erb", "app/views/kablam/models/_sample_target_item.html.erb"
      end
      def setup_routes
        inject_into_file 'config/routes.rb', before: "end" do
          "  # KABLAM! form/create/update/destroy/undo for all models"
          "  # Note: Make sure Kablam engine is at the BOTTOM of routes"
          "  # helpers to use KABLAM! [examples w/ 'posts' model)"
          "  # --->  kablam.form_path('posts')"
          "  #  (if edit form, must add '?id=\#\{@post.id\}' at end of path)"
          "  # --->  kablam.create_path('posts')"
          "  # --->  kablam.delete_path('posts', @post)"
          "  # --->  kablam.update_path('posts', @post)"
          "  # --->  kablam.undo_path('posts', @post)"
          "  mount Kablam::Engine => '/kablam', as: 'kablam'\n"
        end

      end

      def setup_assets
        inject_into_file 'app/assets/javascripts/application.js', before: "//= require_tree ." do
          "//=require kablam/ajax"
          "//=require kablam/forms\n"
        end
        prepend_file 'app/assets/stylesheets/application.css.scss', "@import 'kablam';\n"
      end
    end
  end
end
