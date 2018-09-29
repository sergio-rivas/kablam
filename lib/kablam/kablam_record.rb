module Kablam
  class KablamRecord < ActiveRecord::Base
    self.abstract_class = true

    def html_id
      "#{model_name.singular}-#{id}"
    end

    def undoable?
      attributes.include?("destroyed_at")
    end

    def standard_hash
      serializable_hash.except("created_at",
          "updated_at").reject{|k,v|v.blank?}
    end

    def input(field)
      form_name = self.class.to_s.underscore
      kablam_scope = "kablam_forms.#{self.class.table_name}.#{field}"
      {
        name: "#{form_name}[#{field}]",
        field: field.to_sym,
        value: send(field),
        label: I18n.translate(:label, scope: kablam_scope, default: ""),
        pretext: I18n.translate(:pretext, scope: kablam_scope, default: ""),
        placeholder: I18n.translate(:placeholder, scope: kablam_scope, default: ""),
        hint: I18n.translate(:hint, scope: kablam_scope, default: ""),
        choices: self.class.choices(field, I18n.locale),
        onchange: I18n.translate(:onchange, scope: kablam_scope, default: ""),
        true_statement: I18n.translate(:true_statement, scope: kablam_scope, default: "")
      }
    end

    def self.slack_hook
      nil
    end

    def opt_for(field)
      Hash[self.class.attribute_names.map{|x| [x,{}]}].merge(self.kablam_options)[field]
    end

    def kablam_options
      {}
    end

    def slack_message
      puts "You have not setup slack message for this model.\nto prepare a slack_message, please add method 'slack_message'\nwith content of a hash with keys [:create, :update, :destroy].\n\nFor each key, prepare a value hash like this:\n  ...\n  create:  {\n   pretext: 'some text',\n   author: 'some name',\n   title: 'some title',\n   text: ''\n  },\n  ...\n\nHope this helps!!"
      {create: {}, update: {}, destroy: {}}
    end

    def self.set_fields
      puts "You haven't setup Kablam forms for #{self.to_s} yet!"
      puts "create a method in your model called:"
      puts ""
      puts "def self.set_fields"
      puts "# Then setup the roles of each column name"
      puts "All the types: checkbox_array, checkbox_boolean, file_upload, hidden, input, multi_inputs, select, text, exclude"
      puts "Example:"
      puts "{"
      puts "  select: [\"role\", \"column_2\"],"
      puts "  file_upload: ['column_3'],"
      puts "  exclude: [\"id\", \"created_at\", \"user_id\", \"updated_at\"]"
      puts "}"

      {}
    end

    def self.form_choices
      puts "For fields w/ choices (select, checkboxes, etc.)"
      puts "You can setup the values/choices by creating a method:"
      puts "def self.form_choices"
      puts "example:"
      puts "
      {
        \"field_name\" => [{value: \"value\",
          label: {
          \"locale\"=> \"locale_label\"
          }
        }]
      }"
      {}
    end

    def identifier
      send(self.class.fields.first)
    end

    def self.fields
      result = self.attribute_names - ["id", "created_at", "updated_at", "destroyed_at"]
    end

    def self.field_set
      field_types = {
        input: [],
        text: [],
        hidden: [],
        select: [],
        datetime: [],
        checkbox_array: [],
        checkbox_boolean: [],
        multi_inputs: [],
        file_upload: [],
        exclude: ["id", "created_at", "updated_at", "destroyed_at"]
      }
      user_fields = set_fields
      user_fields[:exclude] += field_types[:exclude] if user_fields[:exclude].present?

      field_types.merge user_fields.select { |k| field_types.keys.include? k }
    end

    def self.prep_form_field
      # This method will prepare hash of hashes
      # for each data-field w/ the form input type.
      # ex: date, radio, select, etc.

      obj = self.new
      hashy = {}
      fields_array = self.fields
      fields_array.each do |k|
        hashy[k] = :not_set
        hashy[k] = obj.column_for_attribute(k).type if obj.column_for_attribute(k).type
        hashy[k] = :input             if     [:string, :float, :integer].include? hashy[k]
        hashy[k] = :checkbox_boolean  if     [:boolean].include? hashy[k]
        self.field_set.keys.each{|type| hashy[k] = type if self.field_set[type].include?(k)}
      end
      hashy
    end

    def self.choices(field, locale)
      c_set = self.form_choices[field]
      return false if c_set.blank?
      c_set.map{|choice| {value: choice[:value], label: (choice[:label][locale.to_s] || "CHOICE TRANSLATION NOT FOUND! PLEASE CONTACT STAFF!")}}
    end
  end
end
