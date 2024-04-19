class Admin::OrdersController < AdminController
  before_action :set_admin_order, only: %i[show edit update destroy]

  def index
    @not_fulfilled_pagy, @not_fulfilled_orders = pagy(Order.where(fulfilled: false).order(created_at: :asc))
    @fulfilled_pagy, @fulfilled_orders = pagy(Order.where(fulfilled: true).order(created_at: :asc), page_param: :page_fulfilled)
  end

  def show; end

  def new
    @admin_order = Order.new
  end

  def edit; end

  def create
    @admin_order = Order.new(admin_order_params)

    respond_to do |format|
      if @admin_order.save
        format.html { redirect_to admin_order_url(@admin_order), notice: I18n.t('admin.orders.create.success') }
        format.json { render :show, status: :created, location: @admin_order }
      else
        format.html { render :new, status: :unprocessable_entity, notice: I18n.t('admin.orders.create.failure') }
        format.json { render json: @admin_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @admin_order.update(admin_order_params)
        format.html { redirect_to admin_order_url(@admin_order), notice: I18n.t('admin.orders.update.success') }
        format.json { render :show, status: :ok, location: @admin_order }
      else
        format.html { render :edit, status: :unprocessable_entity, notice: I18n.t('admin.orders.update.failure') }
        format.json { render json: @admin_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_order.destroy!

    respond_to do |format|
      format.html { redirect_to admin_orders_url, notice: I18n.t('admin.orders.destroy.success') }
      format.json { head :no_content }
    end
  end

  private

  def set_admin_order
    @admin_order = Order.find(params[:id])
  end

  def admin_order_params
    params.require(:order).permit(:customer_email, :fulfilled, :total, :address)
  end
end
