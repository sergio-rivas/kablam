require 'yaml'

module Kablam
  module Generators
    class KablamGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      namespace "kablam"
      source_root File.expand_path('../templates', __FILE__)
      # argument :name, :type => :string, :default => "en"
    end
  end
end
