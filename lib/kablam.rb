module Kablam
  # Basic form classes (in initialize)
  mattr_accessor :form_wrapper
  mattr_accessor :submit_button
  mattr_accessor :form_group
  mattr_accessor :field_label
  mattr_accessor :field_hint
  mattr_accessor :pretext_wrapper
  mattr_accessor :pretext

  # Classes for the acutal from field input/select html items:
  mattr_accessor :input
  mattr_accessor :textarea
  mattr_accessor :dropdown_select
  mattr_accessor :file_upload
  mattr_accessor :file_upload_icon

  # Checkbox classes
  mattr_accessor :checkbox_group_wrapper
  mattr_accessor :checkbox_wrapper
  mattr_accessor :checkbox_label
  mattr_accessor :checkbox

  # Multi-Inputs classes (i.e. add string arrays)
  mattr_accessor :multi_input_group
  mattr_accessor :multi_add_button
  mattr_accessor :multi_remove_button
  mattr_accessor :multi_add_icon
  mattr_accessor :multi_remove_icon

  module ClassMethods

  end

  module InstanceMethods

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  def self.setup
    yield self
  end


end

require 'kablam/engine'
require 'kablam/forms'
require 'kablam/kablam_record'
