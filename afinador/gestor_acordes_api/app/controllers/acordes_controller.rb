class AcordesController < ApplicationController
  def index
    @acordes = Acorde.all
    render json: @acordes
  end

  def create
    @acorde = Acorde.new(acorde_params)

    if @acorde.save
      render json: @acorde, status: :created
    else
      render json: @acorde.errors, status: :unprocessable_entity
    end
  end

  def update
    @acorde = Acorde.find(params[:id])

    if @acorde.update(acorde_params)
      render json: @acorde
    else
      render json: @acorde.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @acorde = Acorde.find(params[:id])

    if @acorde.destroy
      head :ok
    else
      render json: { error: "Error al eliminar" }, status: :unprocessable_entity
    end
  end

  private

  def acorde_params
    # Aquí autorizamos los campos exactos que creaste en tu migración
    params.require(:acorde).permit(:nombre, :cuerda1, :cuerda2, :cuerda3, :cuerda4, :cuerda5, :cuerda6, :usuario_id)
  end
end
