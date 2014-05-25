class TagsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource :except => [:show]
  skip_load_resource :only => [:create]
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :set_venue
  before_action :sidebar_menu

  helper_method :get_venues
  
  def index
    @tags = Tag.where(venue_id: @venue) if @venue
    @tags = Tag.all unless @venue
  end

  def show
  end

  def new
    @tag = Tag.new()
    @tag.venue = @venue
    build_images
  end

  def create
    @tag = Tag.new(content_params)
    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tag }
      else
        flash[:error] = 'Unable to create tag. ' + @tag.errors.full_messages.to_s
        format.html { render action: 'new' }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    build_images
  end
  
  def build_images
    @tag.build_thumbnail_image unless @tag.thumbnail_image
  end

  def update
    @tag.assign_attributes(content_params)
    @tag.thumbnail_image = nil if content_params[:thumbnail_image_attributes].blank? or (content_params[:thumbnail_image_attributes][:assets].blank? and content_params[:thumbnail_image_attributes][:id].blank?)
    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { render action: 'show', status: :created, location: @tag }
      else
        flash[:error] = 'Unable to update tag. ' + @tag.errors.full_messages.to_s
        format.html { render action: 'new'}
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to contents_path() }
      format.json { head :no_content }
    end
  end
  
  def get_venues
    @venues ||= Venue.all
  end
  
private
  
  def set_tag
    @tag = Tag.find(params[:id])
  end

  def set_venue
    @venue = @tag.venue if @tag and @tag.venue
    @venue ||= Venue.find(params[:venue_id]) if params[:venue_id]
  end

  def content_params
    params.require(:tag).permit(:name, :venue_id, :featured, thumbnail_image_attributes: [:assets, :id])
  end
end