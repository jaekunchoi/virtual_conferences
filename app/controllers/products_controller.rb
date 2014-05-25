class ProductsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource :except => [:show]
  skip_load_resource :only => [:create]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :sidebar_menu, :set_booths, :role_vars

  # GET /products
  # GET /products.json
  def index
    if(current_user.has_role?(:admin) || current_user.has_role?(:vendor))
      @products = Product.all
    else
      @products = Product.where(:user_id => current_user.id)
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    @product.build_uploaded_file
  end

  # GET /products/1/edit
  def edit
    @product.build_uploaded_file unless @product.uploaded_file
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
      uploaded_file_url(@product)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :product_url, :image_id, :request_info, 
        :email_notification, :emails, :user_id, :booth_ids => [], uploaded_file_attributes: [:assets] )
    end

    def sidebar_menu
      super ["Products", "gift"], "product-nav", [[products_path, "List products"], [new_product_path, "Create a product"]], true
    end
    
    def uploaded_file_url(product)
      @product_logo_url = product.uploaded_file.assets.url if product.uploaded_file
    end

    def set_booths
      if current_user.has_role? :admin
        @booths = Booth.all
      else
        @booths = Booth.where(:user_id => current_user.id)
      end
    end

    def role_vars
      if current_user.has_role? :booth_rep
        hide_sidebar 'hide-sidebar'
      end
    end
end
