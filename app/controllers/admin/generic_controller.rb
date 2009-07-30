class Admin::GenericController < Admin::BaseController

  before_filter :get_resource

  def current_model
    @current_model ||= instance_eval(current_model_name)
  end

  def current_model_name
    @current_model_name ||= @resource.class_name
  end

  def current_objects
    @current_objects ||= current_model.paginate(:all, :page => (params[:page] || 1), :per_page => 10, :order => @resource.options[:order] || :id)
  end

  def current_object
    @current_object ||= current_model.find(params[:id]) || current_model.new
  end

  def instance_variable_name
    "current_object"
  end

  def singular
    false
  end
  
  make_resourceful do
    actions :all

    # Useful for debugging
    # response_for :show_fails do |format|
    #   raise $!
    # end

    response_for :create, :update do
      set_default_redirect send("admin_#{current_object.class.name.downcase}_path".to_sym, current_object)
    end

    response_for :index do |format|
      format.html
      format.xml
      format.js
    end

    response_for :show do |format|
      format.html { render :edit }
    end

    response_for :create do |format|
      format.html {
        flash[:notice] = "#{current_model_name.underscore.humanize} successfully updated"
        render :edit
      }
    end

    response_for :create_fails do |format|
      format.html {
        flash[:error] = flash[:notice] = nil
        render :new
      }
    end

    response_for :update do |format|
      format.html {
        flash[:notice] = "#{current_model_name.underscore.humanize} successfully updated"
        render :edit
      }
    end

    response_for :update_fails do |format|
      format.html {
        flash[:error] = flash[:notice] = nil
        render :edit
      }
    end
  end
  
  # Catching any extra methods here
  def method_missing(method, *args)
    if @resource.has_controller_method?(method)
      @resource.controller_method(method).call(current_object)
      # Set flash message
      flash[:notice] = @resource.controller_method(method).has_flash_notice? ? @resource.controller_method(method).flash_notice : nil
      flash[:error] = @resource.controller_method(method).has_flash_error? ? @resource.controller_method(method).flash_error : nil
      # Redirect or Render
      if @resource.controller_method(method).has_redirection?
        redirect_to send(@resource.controller_method(method).redirection)
      elsif @resource.controller_method(method).has_render?
        render @resource.controller_method(method).render
      else
        # Default is to render edit
        render :edit
      end
    end
  end

  private
  def get_resource
    resource_id = request.env['REQUEST_PATH'].split('/')[2]
    @resource = SimpleAdmin::Resources.get(resource_id)
    raise "Resource not found" unless @resource
  end
end