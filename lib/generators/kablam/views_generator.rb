module KablamForms
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      include Rails::Generators::ResourceHelpers
      namespace "kablam:form_views"
      source_root File.expand_path('../templates', __FILE__)


    end
  end
end
