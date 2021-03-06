class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :like, :edit, :update, :destroy]
  before_action :set_category, only: [:new, :edit]

  # GET /products
  # GET /products.json
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.page(params[:page]).per(PRODUCTS_PER)
    @categories = Category.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # POST /products/1/like
  def like
    if current_user.likes?(@product)
      current_user.unlike!(@product)
    else
      current_user.like!(@product)
    end

    redirect_to @product
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
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
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /products/import/csv
  def import_csv
    Product.import_csv(params[:file])
    redirect_to admin_products_path
  end

  def export_csv
    output_csv = Product.export_csv
    respond_to do |format|
      format.csv do
        send_data output_csv, filename: "products.csv"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def set_category
      @categories = Category.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :category_id)
    end
end
