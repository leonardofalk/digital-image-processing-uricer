class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :show_image, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    @images = Image.where(image_collection_id: nil)
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  def show_image
    # ext = @image.name.scan(/^.+\.(.+)$/i).first.first
    # ext = "image/#{ext}"

    send_data @image.data, disposition: 'inline'
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    image_params[:data].each do |file|
      @image = Image.new(data: file) do |t|
        t.name = t.data.original_filename
        t.data = t.data.read
      end

      @image.save
    end

    respond_to do |format|
      if @image.save
        ImageCv.new(@image)

        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @image = Image.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def image_params
    params.require(:image).permit(data: [])
  end
end
