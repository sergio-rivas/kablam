require 'rest-client'
require 'json'

class KablamController < ApplicationController
  protect_from_forgery with: :exception
  before_action :set_model, only: [:create, :update, :undo, :destroy, :form]
  before_action :set_object, only: [:update, :destroy]
  before_action :set_undo_object, only: [:undo]
  skip_before_action :verify_authenticity_token, only: [:message]
  include Concerns::ApiSettings

  def form
    # Automatically Render Vanilla Form for use w/ JS.load
    if params[:id].present?
      set_object
    else
      @object = @model.new
      set_ref
    end
    render layout: false
  end

  def message
    @message = JSON.parse(params[:message])
    respond_to do |format|
      format.js
      format.html do
        redirect_to request.referrer
      end
    end
  end

  def create
    @object = @model.new(model_params)

    if @object.save
      slack?(:create)
      respond_to do |format|
        format.js
        format.html do
          redirect_to request.referrer
          flash[:notice] = :Created
        end
      end
    else
      # TODO: Add some failure handling 👍
    end
  end

  def update
    if @object.update(model_params)
      slack?(:update)
      respond_to do |format|
        format.js
        format.html do
          redirect_to request.referrer
          flash[:notice] = :Destroyed
        end
      end
    else
      # ADD FAILURE HANDLING
    end
  end

  def destroy
    if @object.destroy
      slack?(:destroy)
      respond_to do |format|
        format.js
        format.html do
          redirect_to request.referrer
          flash[:notice] = :Destroyed
        end
      end
    else
      # TODO: Add some failure handling 👍
    end
  end

  def undo
    @object.update(undo_params)
  end

  def slack
    render status: 200, json: params['challenge']
  end

  private

  def slack?(crud_type)
    if @model.slack_hook.present? && @object.slack_message[crud_type].present?
      slack_it(@model.slack_hook, @object.slack_message[crud_type])
    end
  end

  def set_object
    @object = @model.find(params[:id])
  end

  def set_undo_object
    @object = @model.unscoped.where.not(destroyed_at: nil).find(params[:id])
  end

  def set_model
    db_index = Hash[ActiveRecord::Base.connection.tables.collect{|c| [c, c.classify]}].except("schema_migrations", "ar_internal_metadata")
    @model = db_index[params[:name]].constantize # "users" => User
  end

  def undo_params
    params.require(@model.to_s.underscore.to_sym).permit :destroyed_at
  end

  def base_params
    arr = @model.attribute_names.map { |e| e.to_sym }
    arr.delete(:id)
    arr.delete(:created_at)
    arr.delete(:updated_at)
    arr.map! do |attr|
      new_val = (@model.new.send(attr) == []) ? {attr=>[]} : attr
      new_val
    end
    params.require(@model.to_s.underscore.to_sym).permit(arr)
  end

  def model_params
    result = base_params
    upload_items = base_params.select{|k,v| v.is_a? ActionDispatch::Http::UploadedFile }
    upload_items.each do |k,v|
      result[k] = send_to_bucket(v)
    end
    result
  end

  def set_ref
    owners = @model.reflect_on_all_associations(:belongs_to) || []
    if owners.count < 1
      return true
    elsif owners.count == 1
      foreign_key = owners.first.name.to_s+"_id"
      @object.write_attribute(foreign_key, params[:ref_id])
    else
      p "NOT ENOUGH REF'S ACCOUNTED FOR! REWRITE FORMS??"
    end
  end
end
