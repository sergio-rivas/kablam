# Here's the configuration setup for Kablam!
# You can change all the defaults to fit the css in your project.
# Just for fun, all the defaults used here are based on the awesome Tachyons css library.

Kablam.setup do |config|
  # ===========================================================
  #              _  _ ____ ___  _    ____ _  _
  #              |_/  |__| |__] |    |__| |\/|
  #              | \_ |  | |__] |___ |  | |  |
  # ===========================================================
  #    The configurations below are primarily classes. Except
  #     for the datetime_handler.
  # ===========================================================
  #           .___
  #           [__  _ ._.._ _  Classes &
  #           |   (_)[  [ | )   Handlers
  # ===========================================================

  # These classes are used for the labels/group-wrappers, etc.
  config.form_wrapper =  "pa4 black-80"
  config.submit_button =  "relative no-underline mt3 f4 tc db w-75 pv3 mb3 bg-red hover-bg-green white br2 shadow-5 btn-3d bn outline-0"
  config.form_group =  "measure mb4 relative"
  config.field_label =  "f6 b db mb2"
  config.field_hint =  "f6 black-60 db mb2"
  config.pretext_wrapper =  "measure ph3 pv1 mb3 b ba b--dashed bw1 b--red"
  config.pretext =  "fw5 i f5"

  # Classes for the acutal from field input/select html items =
  config.input =  "input-reset ba b--black-20 pa2 db w-100"
  config.textarea =  "db border-box hover-black w-100 measure ba b--black-20 pa2 br2 mb2"
  config.dropdown_select =  "ba bg-white b--black-20 pa2 mb2 db w-100"
  config.file_upload =  "ba b--black-20 pa5 mb2 db w-100 b--dashed b--red"
  config.file_upload_icon =  "fa fa-upload absolute left-0 right-0 ml-auto mr-auto top-2 mt3 f1 black-05"
  config.datetime_handler = nil

  # Checkbox Classes
  config.checkbox_group_wrapper =  "" # Wrapper around all checkboxes
  config.checkbox_wrapper =  "flex items-center mb2" # Wrapper for individual checkbox
  config.checkbox_label =  "f6 b db"
  config.checkbox =  "mr2"

  # Classes for Muli-Input form_type
  # i.e. a normal input w/ +/- button to add/remove entries.
  # result is an array []
  config.multi_input_group =  "flex mb2" #wrapper with input + delete button
  config.multi_add_button =  "absolute bg-green hover-bg-red no-underline pv2 pl3 pr3 right-0 top-0 white btn-3d br2"
  config.multi_remove_button =  "relative no-underline bg-red hover-bg-green white pa2 pl3 pr3 ml1 btn-3d br2"
  config.multi_add_icon =  "fa fa-plus"
  config.multi_remove_icon =  "fa fa-trash"

  # ============================================================
  #                     KABLAM MESSAGING
  # ============================================================
  config.message_location = "start" # Accepted values are "start" and "end"
end
