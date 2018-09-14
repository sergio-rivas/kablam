module Kablam
  class Forms
    def default_classes
      {
        form_wrapper: "pa4 black-80",
        submit_button: "relative no-underline mt3 f4 tc db w-75 pv3 mb3 bg-red hover-bg-green white br2 shadow-5 btn-3d bn outline-0",
        form_group: "measure mb4 relative",
        field_label: "f6 b db mb2",
        field_hint: "f6 black-60 db mb2",
        pretext_wrapper: "measure ph3 pv1 mb3 b ba b--dashed bw1 b--red",
        pretext: "fw5 i f5",

        # Classes for the acutal from field input/select html items:
        input: "input-reset ba b--black-20 pa2 db w-100",
        textarea: "db border-box hover-black w-100 measure ba b--black-20 pa2 br2 mb2",
        select: "ba bg-white b--black-20 pa2 mb2 db w-100",
        file_upload: "ba b--black-20 pa5 mb2 db w-100 b--dashed b--red",
        file_upload_icon: "fa fa-upload absolute left-0 right-0 ml-auto mr-auto top-2 mt3 f1 black-05",
        checkbox_group_wrapper: "", # Wrapper around all checkboxes
        checkbox_wrapper: "flex items-center mb2", # Wrapper for individual checkbox
        checkbox_label: "f6 b db",
        checkbox: "mr2",
        multi_input_group: "flex mb2", #wrapper with input + delete button
        multi_add_button: "absolute bg-green hover-bg-red no-underline pv2 pl3 pr3 right-0 top-0 white btn-3d br2", # For 'multi_inputs'
        multi_remove_button: "relative no-underline bg-red hover-bg-green white pa2 pl3 pr3 ml1 btn-3d br2", # For 'multi_inputs'
        multi_add_icon: "fa fa-plus",
        multi_remove_icon: "fa fa-trash"
      }
    end
  end
end
