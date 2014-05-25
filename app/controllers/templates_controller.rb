class TemplatesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:show]
  skip_load_resource :only => [:create]
  before_action :set_template, only: [:show, :edit, :update, :destroy]
  before_action :sidebar_menu
  helper_method :get_template_types
  helper_method :get_template_sub_types

  # GET /templates
  def index
    @templates = Template.all
  end

  # GET /templates/1
  def show
  end

  # GET /templates/new
  def new
    @template = Template.new
    build_uploaded_file
  end

  # GET /templates/1/edit
  def edit
    build_uploaded_file
  end

  # POST /templates
  def create
    @template = Template.new(template_params)
    build_uploaded_file
    if @template.save
      redirect_to @template, notice: 'Template was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /templates/1
  def update
    if @template.update(template_params)
      redirect_to @template, notice: 'Template was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /templates/1
  def destroy
    @template.destroy
    redirect_to templates_url, notice: 'Template was successfully destroyed.'
  end

  def get_template_sub_types()
    return Template::TEMPLATE_SUB_TYPE.values
  end
  
  def get_template_types()
    return Template::TEMPLATE_TYPE.values
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
      uploaded_file_url(@template)
    end

    def build_uploaded_file
      @template.build_uploaded_file unless @template.uploaded_file
      @template.build_thumbnail_image unless @template.thumbnail_image
    end

    # Only allow a trusted parameter "white list" through.
    def template_params
      params.require(:template).permit(:name, :jumbotron_available, :template_type, :template_sub_type, 
        { uploaded_file_attributes: [:assets] }, { thumbnail_image_attributes: [:assets] } )
    end

    def uploaded_file_url(template)
      @template_image_url = template.uploaded_file.assets.url if template.uploaded_file
      @template_thumbnail_url = template.thumbnail_image.assets.url if template.thumbnail_image
    end

    def sidebar_menu
      super ["Templates", "folder"], "templates-nav", [[templates_path(@venue), "List templates"], [new_template_path(@venue), "Create a template"]], true
    end
end
