class PackagesController < ApplicationController
  before_action :set_package, only: %i[ show edit update destroy ]

  # GET /packages or /packages.json
  def index
    @packages = Package.all

    # @packages = @packages.joins('JOIN items on items.id = packages.item_id').where('items.name LIKE ?', "%#{params[:item_name]}%") if params[:item_name]
  end

  def checkout
    if params[:pkg].present?
      @selected_items = Package.where(id: params[:pkg].split(',')).map(&:item)

      @selected_items = @selected_items.where(id: params[:selected_item_ids]) if params[:selected_item_ids].present?
    elsif params[:items].present?
      @selected_items = Item.where(id: params[:items].split(','))
    else
      @selected_items = Item.none
    end
  end

  # GET /packages/1 or /packages/1.json
  def show
  end

  # GET /packages/new
  def new
    @package = Package.new
  end

  # GET /packages/1/edit
  def edit
  end

  # POST /packages or /packages.json
  def create
    current_params = package_params
    @package       = Package.new()
    @package.item  = Item.find(current_params.delete(:item)[:id])

    @package.assign_attributes(current_params)

    respond_to do |format|
      if @package.save
        format.html { redirect_to package_url(@package), notice: "Package was successfully created." }
        format.json { render :show, status: :created, location: @package }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /packages/1 or /packages/1.json
  def update
    current_params = package_params
    @package.item = Item.find(current_params.delete(:item)[:id]) if package_params[:item].present?

    respond_to do |format|
      if @package.update(current_params)
        format.html { redirect_to package_url(@package), notice: "Package was successfully updated." }
        format.json { render :show, status: :ok, location: @package }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /packages/1 or /packages/1.json
  def destroy
    @package.destroy

    respond_to do |format|
      format.html { redirect_to packages_url, notice: "Package was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package
      @package = Package.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def package_params
      params.require(:package).permit(:measurement_units, :measurement, :item_id, item: :id)
    end
end
