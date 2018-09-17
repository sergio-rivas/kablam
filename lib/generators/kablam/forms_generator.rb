# frozen_string_literal: true

require 'yaml'
module Kablam
  module Generators
    class FormsGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      namespace "kablam:forms"
      source_root File.expand_path('../templates', __FILE__)
      argument :name, :type => :string, :default => "en"

      def generate_yml
        # Load All Models

        db_index = Hash[ActiveRecord::Base.connection.tables.collect{|c| [c, c.classify]}].except("schema_migrations", "ar_internal_metadata")
        gen_yaml(db_index)
      end

      private
      # HELPER METHODS TO MAKE DOUBLE_QUOTE YML FILES
      def ensure_quotes(h)
        h.each do |k, v|
          if v.is_a?(Hash)
            ensure_quotes(v)
            next
          end
          h[k] = v + "__ensure_quotes__\n "
        end
      end

      def dump_yaml_with_double_quotes(yaml_file)
        yaml = YAML.load_file(yaml_file)
        File.open(yaml_file, 'w') do |f|
          YAML.dump(ensure_quotes(yaml), f, line_width: -1)
        end
        `sed -i '' "s/__ensure_quotes__[\\]n //g" #{yaml_file}`
      end

      def clean_columns(model)
        model_attr = model.attribute_names - ["id", "created_at", "updated_at"]
        # Remove Devise Hidden Attr. if Devise Model
        if defined? model.params_authenticatable?
          model_attr << "password"
          model_attr = model_attr - ["encrypted_password", "reset_password_token", "reset_password_sent_at", "remember_created_at", "sign_in_count", "current_sign_in_at", "last_sign_in_at", "current_sign_in_ip", "last_sign_in_ip", "confirmation_token", "confirmed_at", "confirmation_sent_at", "unconfirmed_email", "failed_attempts", "unlock_token", "locked_at"]
        end
        return model_attr
      end

      def name_cleaner(model, attribute)
        return attribute.split("_").map{|x|x.capitalize}.join(" ")
      end

      def db_to_hash(db_index)
        result_hash = {}
        db_index.each do |table_name, model_name|
          model = model_name.constantize
          model_attr = clean_columns(model)

          # setup table hash
          table_hash = {}
          model_attr.each do |attribute|
            clean_name = name_cleaner(model, attribute)

            table_hash[attribute] = {
              "label" => clean_name,
              "placeholder" => "placeholder_text_for_#{attribute}",
              "hint" => "small_text_long_descirption_hint_for_#{attribute}",
              "pretext" => "pretext_box_for_#{attribute}"
            }
          end
          result_hash[table_name] = table_hash
        end
        return result_hash
      end

      def gen_yaml(db_index)
        path = "config/locales/kablam-forms.#{name}.yml"
        original = YAML.load_file(path)
        yml_hash = {name => {"kablam_forms" => db_to_hash(db_index)}}
        yml_hash.merge!(original) if original.present?

        File.write(path, yml_hash.to_yaml)
        dump_yaml_with_double_quotes(path)
      end
    end
  end
end
