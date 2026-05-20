class Acorde < ApplicationRecord
  belongs_to :usuario

  validates :cuerda1, :cuerda2, :cuerda3, :cuerda4, :cuerda5, :cuerda6,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: -1,
              less_than_or_equal_to: 22,
              message: "debe ser un traste válido (entre -1 y 22)"
            }
end
