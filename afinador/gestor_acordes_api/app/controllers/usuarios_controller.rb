class UsuariosController < ApplicationController
  def index
    @usuarios = Usuario.all
    render json: @usuarios
  end

  def create
    # find_or_create_by busca un registro con ese nombre exacto.
    # Si lo encuentra: lo recupera de la BD (Login).
    # Si NO lo encuentra: lo crea y lo guarda automáticamente (Registro).
    @usuario = Usuario.find_or_create_by(nombre: usuario_params[:nombre])
    
    if @usuario.persisted?
      # Devolvemos status :ok (200) para indicar éxito en ambos casos
      render json: { id: @usuario.id, nombre: @usuario.nombre }, status: :ok
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