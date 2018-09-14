module Kablam
  module ClassMethods

  end

  module InstanceMethods

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end

require 'kablam/engine'
require 'kablam/forms'
require 'kablam/kablam_record'
