module Kablam
  module KablamHelper
    def replace_with(id, content)
    end

    def undo_destroy_path(model)
      name = model.model_name.singular
      params = [[name, { destroyed_at: nil }]].to_h
      polymorphic_path("data_undo", params)
    end

    def kablam_form_for(obj, options = {}, &block)
      # @kablam_content = {}
      options[:obj] = obj
      # options[:block] = block_given? ? block : ""
      render layout: "kablam_forms/kablam_form", locals: options do |f|
        capture(f, &block) if block_given?
      end
      # nil
    end

    def kablam_before(field, &block)
      @kablam_before = {} if @kablam_before.blank?
      @kablam_before[field] = block
      nil
    end

    def kablam_after(field, &block)
      @kablam_after = {} if @kablam_after.blank?
      @kablam_after[field] = block
      nil
    end

    # TODO: Complete this 🤷
    def disable_test
      'console.log("test")'
    end

    # TODO: Use Rails UJS setData/expando to stash original state 😎
    def show(model)
      raw "document.getElementById('#{model.html_id}').style.display = 'table-row'"
    end

    def hide(model)
      raw "document.getElementById('#{model.html_id}').style.display = 'none'"
    end

    def render_flash(partial: 'application/flash_notice', **locals)
      html = j render partial: partial, locals: locals
      raw "document.getElementById('flash').innerHTML = '#{html}'"
    end
  end
end
