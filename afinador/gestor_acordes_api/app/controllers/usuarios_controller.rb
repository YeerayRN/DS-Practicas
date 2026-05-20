class UsuariosController < ApplicationController
  def index
    @usuarios = Usuario.all
    render json: @usuarios
  end

  def create
    @usuario = Usuario.new(usuario_params)
    
    if @usuario.save
      render json: { id: @usuario.id, nombre: @usuario.nombre }, status: :created
    else
      render json: @usuario.errors, status: :unprocessable_entity
    end
  end

  def update
    @usuario = Usuario.find(params[:id])
    
    if @usuario.update(usuario_params)
      render json: { id: @usuario.id, nombre: @usuario.nombre }
    else
      render json: @usuario.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @usuario = Usuario.find(params[:id])
    
    if @usuario.destroy
      head :ok
    else
      render json: { error: "Error al eliminar" }, status: :unprocessable_entity
    end
  end

  private

  def usuario_params
    params.require(:usuario).permit(:nombre)
  end
end