class PurchasesController < ApplicationController
  before_action :set_purchase, only: %i[ show edit update destroy ]

  # GET /purchases or /purchases.json
  def index
    @purchases = Purchase.all

    @purchases = @purchases.joins('JOIN packages ON packages.id = purchases.package_id JOIN items ON items.id = packages.item_id')
                           .where('items.name LIKE ?', "%#{params[:item_name]}%") if params[:item_name]
  end

  # GET /purchases/1 or /purchases/1.json
  def show
  end

  def spreadsheet; end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
  end

  def bulk_create
    purchases = params.permit(bulk_purchases: purchase_attributes).values.flatten

    failures  = purchases.filter_map do |purchase_details|
      next if purchase_details.blank?

      store     = Store.find_by(name: purchase_details.delete(:store))
      package   = Package.find_by_item_and_measurement(purchase_details.delete(:item_package).downcase)

      @purchase = Purchase.new(purchase_details.merge({ store: store, package: package }))

      next if @purchase.save

      "Error processing #{purchase_details}: #{@purchase.errors.full_messages.last}"
    rescue => e
      "Error processing #{purchase_details}: #{e}"
    end

    respond_to do |format|
      if failures.empty?
        format.html { redirect_to purchases_url, notice: "Purchases were successfully created." }
        format.json { render :show, status: :created, location: purchases_url }
      else
        format.html { render :spreadsheet, status: :unprocessable_entity }
        format.json { render json: failures, status: :unprocessable_entity }
      end
    end
  end

  # POST /purchases or /purchases.json
  def create
    current_params = purchase_params
    @purchase      = Purchase.new()

    @purchase.store   = Store.find current_params.delete('store')
    @purchase.package = Package.find current_params.delete('package')

    @purchase.assign_attributes(current_params)

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to purchase_url(@purchase), notice: "Purchase was successfully created." }
        format.json { render :show, status: :created, location: @purchase }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchases/1 or /purchases/1.json
  def update
    respond_to do |format|
      current_params = purchase_params
      @purchase.store   = Store.find current_params.delete('store')
      @purchase.package = Package.find current_params.delete('package')

      if @purchase.update(current_params)
        format.html { redirect_to purchase_url(@purchase), notice: "Purchase was successfully updated." }
        format.json { render :show, status: :ok, location: @purchase }
      else
        format.html { render :edit, status: :unprocessable_entity, notice: 'Failure!' }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1 or /purchases/1.json
  def destroy
    @purchase.destroy

    respond_to do |format|
      format.html { redirect_to purchases_url, notice: "Purchase was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def purchase_params
      params.require(:purchase).permit(:price, :cost, :discount, :quantity, :measurement, :measurement_units, :date, :package, :id, :store, :item_package)
    end

    def purchase_attributes
      [ :price, :cost, :discount,
        :quantity, :measurement, :measurement_units,
        :store, :store_id, :date, :item,
        :package_id, :package, :item_package,
        :purchase,
        package: :id, store: :id ]
    end
end
