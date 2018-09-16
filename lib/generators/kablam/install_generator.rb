require 'yaml'

module Kablam
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      namespace "kablam:install"
      source_root File.expand_path('../templates', __FILE__)
      # argument :name, :type => :string, :default => "en"

      # Change ApplicationRecord's inheritence
      gsub_file 'app/models/application_record.rb', 'class ApplicationRecord < ActiveRecord::Base', 'class ApplicationRecord < Kablam::KablamRecord'

      # Setup Initializer
      template "kablam.rb", "config/initializers/kablam.rb"

      def setup_routes
        route "# form/create/update/destroy/undo for all models"
        route "get    'd/:name/form' => 'data#form',     as: 'data_form'"
        route "post   'd/:name'      => 'data#create',   as: 'data_create'"
        route "patch  'd/:name/:id'  => 'data#update',   as: 'data_update'"
        route "delete 'd/:name/:id'  => 'data#destroy',  as: 'data_destroy'"
        route "put    'd/:name/:id'  => 'data#undo',     as: 'data_undo'"
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
