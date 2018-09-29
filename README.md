![](http://bcdbimages.s3.amazonaws.com/nick/kablam.jpg)

*Documentation In Progress*
# Large Scale Automation. Small Scale Customization.
The concept of this gem is simple. And, although it goes slightly against the "Convention Over Configuration" ideal that makes Rails an **AWESOME** and powerful tool, you'll see how it makes devloping a large-scale application super easy. The concept came when styling 20-50 form fields for a really large table just drained the energy from my day.

In a nutshell, here's the idea:  Reduce the amount of tedious repetative tasks that are unavoidable and must be done. Eventually, I aim to include every major *common* SAAS feature in this one gem.

There are three files you will need to work with:
<code>config/initializers/kablam.rb</code>
<code>config/locales/kablam-forms.(*LANGUAGE).yml</code>
<code>app/models/your_model.rb</code>

The Kablam Initializer contains all the standardized classes you use in your project. All the forms, the textareas, the input-texts, etc. These classes will be used by default in every form for every field, but can also be overwritten on a per-form basis.

The Kablam Locale YML will contain *ALL THE TEXT* rendered in your forms. All the placeholders, all the labels, all the hints, and all the pretexts.

In Your Model, you will be able to adjust kablams automatic rendering of forms by letting it know which columns to render in what way. 

KABLAM FORMS
-------------
*insert pretext explaining forms & comparing w/ form_for and simple_form_for*

Here's an example with the Article model.
@article can be either <code>Article.new</code> or <code>Article.find(id)</code>
If @article has an id, it will render an update form, else, a new form.

Basic Use :
```
<%= kablam_form_for @object %>
```
This will go through all the data columns in its database table and render a field for it.
Every field is in this order:

```
<div> <---Form Group
  <div></div> <---Pretext Box (used for special notifications/descriptions)
  <label></label> <---Label
  <small></small> <---Hint
  <input> <---Input
</div>
```

Advanced Use:

To render special content before a field
```
<%= kablam_form_for @object do %>
  <% kablam_before("field_name") do %>
    <div> something to put before "field_name" form field is rendered</div>
  <% end %>
<% end %>
```
To render special content after a field
```
<%= kablam_form_for @object do %>
  <% kablam_after("field_name") do %>
    <div> something to put after "field_name" form field is rendered</div>
  <% end %>
<% end %>
```

To use form_for helpers\* (note: still needs testing):
```
<%= kablam_form_for @object do |f| %>
  <%= f.text_field :some_column, value: "a value" %>
<% end %>
```

KABLAM MESSAGING
----------
*To DO: Make documentation on setting up / using Kablam Messaging*
