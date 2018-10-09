module Kablam
  class Forms
    def self.render_edit(obj, target_id, table_id, opt={})
      "<a class=\'#{opt[:class]}\' onclick=\'event.preventDefault();load(\"#{target_id}\", \"/kablam/#{obj.class.table_name}/form?id=#{obj.id}&target=#{table_id}\")\' href=\'#\'>#{opt[:text] || "Edit"}</a>"
    end

    def self.render_form(obj, target_id, table_id, opt={})
      "<a class=\'#{opt[:class]}\' onclick=\'event.preventDefault();load(\"#{target_id}\", \"/kablam/#{obj.class.table_name}/form?#{('id='+obj.id+'&') if obj.id.present?}&target=#{table_id}\")\' href=\'#\'>#{opt[:text] || "Edit"}</a>"
    end

    def self.render_destroy(obj, opt={})
      "<a data-disable-with=\'…\' class=\'#{opt[:class]}\' data-remote=\'true\' rel=\'nofollow\' data-method=\'delete\' href=\'/kablam/#{obj.class.table_name}/#{obj.id}\'>#{opt[:text] || "Remove"}</a>"
    end

    def self.default_classes
      {
        # Generally used classes for everything.
        form_wrapper: Kablam.form_wrapper,
        submit_button: Kablam.submit_button,
        form_group: Kablam.form_group,
        field_label: Kablam.field_label,
        field_hint: Kablam.field_hint,
        pretext_wrapper: Kablam.pretext_wrapper,
        pretext: Kablam.pretext,

        # Classes for the acutal from field input/select html items:
        input: Kablam.input,
        textarea: Kablam.textarea,
        select: Kablam.dropdown_select,
        file_upload: Kablam.file_upload,
        file_upload_icon: Kablam.file_upload_icon,

        # Classes for checkboxes
        checkbox_group_wrapper: Kablam.checkbox_group_wrapper,
        checkbox_wrapper: Kablam.checkbox_wrapper,
        checkbox_label: Kablam.checkbox_label,
        checkbox: Kablam.checkbox,

        # Classes for Multi-Inputs
        multi_input_group: Kablam.multi_input_group,
        multi_add_button: Kablam.multi_add_button,
        multi_remove_button: Kablam.multi_remove_button,
        multi_add_icon: Kablam.multi_add_icon,
        multi_remove_icon: Kablam.multi_remove_icon
      }
    end
  end
end
