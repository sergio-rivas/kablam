module Kablam
  class Kablam::KablamRecord < ActiveRecord::Base
    self.abstract_class = true

    def undoable?
      attributes.include?("destroyed_at")
    end

    def standard_hash
      serializable_hash.except("created_at",
          "updated_at").reject{|k,v|v.blank?}
    end

    def self.slack_hook
      nil
    end

    def self.input(field)
      form_name = self.to_s.underscore
      {
        name: "#{form_name}[#{field}]",
        value: obj.send(field),
        label: t(:label, scope: magic_scope, default: ""),
        pretext: t(:pretext, scope: magic_scope, default: ""),
        placeholder: t(:placeholder, scope: magic_scope, default: ""),
        hint: raw(t(:hint, scope: magic_scope, default: "")),
        choices: @model.choices(field, I18n.locale)
      }
    end

    def slack_message
      puts "You have not setup slack message for this model.\nto prepare a slack_message, please add method 'slack_message'\nwith content of a hash with keys [:create, :update, :destroy].\n\nFor each key, prepare a value hash like this:\n  ...\n  create:  {\n   pretext: 'some text',\n   author: 'some name',\n   title: 'some title',\n   text: ''\n  },\n  ...\n\nHope this helps!!"
      {create: {}, update: {}, destroy: {}}
    end

    def identifier
      send(self.class.fields.first)
    end

    def self.fields
      result = self.attribute_names - ["id", "created_at", "updated_at"]
    end

    def self.field_set
      field_types = {
        input: [],
        text: [],
        hidden: [],
        select: [],
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
        hashy[k] = obj.column_for_attribute(k).type
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
