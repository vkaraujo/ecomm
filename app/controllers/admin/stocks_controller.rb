class Admin::StocksController < AdminController
  before_action :set_product, only: %i[new create edit]
  before_action :set_admin_stock, only: %i[show edit update destroy]

  def index
    @admin_stocks = Stock.where(product_id: params[:product_id])
  end

  def show; end

  def new
    @admin_stock = Stock.new
  end

  def edit; end

  def create
    @admin_stock = @product.stocks.new(admin_stock_params)

    respond_to do |format|
      if @admin_stock.save
        format.html { redirect_to admin_product_stock_url(@product, @admin_stock), notice: I18n.t('admin.stocks.create.success') }
        format.json { render :show, status: :created, location: @admin_stock }
      else
        format.html { render :new, status: :unprocessable_entity, notice: I18n.t('admin.stocks.create.failure') }
        format.json { render json: @admin_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @admin_stock.update(admin_stock_params)
        format.html { redirect_to admin_product_stock_url(@admin_stock.product, @admin_stock), notice: I18n.t('admin.stocks.update.success') }
        format.json { render :show, status: :ok, location: @admin_stock }
      else
        format.html { render :edit, status: :unprocessable_entity, notice: I18n.t('admin.stocks.update.failure') }
        format.json { render json: @admin_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_stock.destroy!

    respond_to do |format|
      format.html { redirect_to admin_product_stocks_url, notice: I18n.t('admin.stocks.destroy.success') }
      format.json { head :no_content }
    end
  end

  private

  def set_admin_stock
    @admin_stock = Stock.find(params[:id])
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def admin_stock_params
    params.require(:stock).permit(:size, :amount)
  end
end
