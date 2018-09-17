# frozen_string_literal: true

require 'rails/generators/base'
module Kablam
  module Generators
    class MessagingGenerator < Rails::Generators::Base
      namespace "kablam:messaging"
      source_root File.expand_path('../templates', __FILE__)

      def setup_action_cable
        inject_into_file 'app/assets/javascripts/application.js', after: "//=require_tree .\n" do
          "//=require cable"
        end
        route "mount ActionCable.server => '/cable'"
        inject_into_file "app/views/layouts/application.html.erb", before: "</head>" do
          "  <%= action_cable_meta_tag %>\n  "
        end
      end

      def setup_models
        generate "model", "chat user:references subject:string "
        generate "model", "message chat:references content:text sender_id:integer attachment:string"
        generate "model", "message_status user:references message references read:boolean"
        copy_file "chat.rb", "app/models/chat.rb", force: true
        copy_file "message.rb", "app/models/message.rb", force: true
        status_migration = Dir.glob(Rails.root.to_s+"/db/migrate/**").last
        gsub_file status_migration, "t.boolean :read", "t.boolean :read, default: false"

        rake "db:migrate"
      end
      def setup_assets
        inject_into_file 'app/assets/javascripts/application.js', before: "//=require_tree .\n" do
          "//=require kablam/messaging"
        end
      end
    end
  end
end
