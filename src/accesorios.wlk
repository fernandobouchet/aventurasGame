import wollok.game.*
import utilidades.*

object pelo {
	var image = "neanthy_der_pelo_1.png"
	var position = game.at(0,0)
	
	method image() = image
	
	method position() = position

	method esAtravesable() = true

	method actualizar(direccion) {
		position = utilidadesParaJuego.protagonista().position()
		image = direccion.imagenPelo()
		game.removeVisual(self)
		game.addVisual(self)
	}

	method formaPelo() =
		if (utilidadesParaJuego.protagonista().tiene(peine)) "pelo_2"
		else "pelo_1"
}

class AccesorioAgarrable {
	var position = game.at(0,0)
	var image

	method position() = position
	method image() = image
	
	method configurate() {
		position = utilidadesParaJuego.posicionArbitrariaNoOcupada()
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			if(not objeto.esAtravesable()) self.reaccionarA(objeto)
		})
	}
	
	method esAtravesable() = true
	method reaccionarA(objeto) {
		if (objeto == utilidadesParaJuego.protagonista()) {
			objeto.agarrarItem(self)
			game.removeVisual(self)
			objeto.actualizarImagen(false)
		}
	}
}

object peine inherits AccesorioAgarrable(image = "peine.png") {}

object reloj inherits AccesorioAgarrable(image = "reloj.png") {
	override method configurate() {
		super()
		image = "reloj.png"
	}
	method actualizar(direccion, movimiento) {
		const protagonista = utilidadesParaJuego.protagonista()
		if (protagonista.tiene(self)) {
			if (not game.hasVisual(self)) game.addVisual(self)
			else {
				game.removeVisual(self)
				game.addVisual(self)
			}
			position = protagonista.position()
			image = direccion.imagenReloj(movimiento)
		}
	}
}

object anteojos inherits AccesorioAgarrable(image = "anteojos.png") {
	override method configurate() {
		super()
		image = "anteojos.png"
	}
	method actualizar(direccion) {
		const protagonista = utilidadesParaJuego.protagonista()
		if (protagonista.tiene(self)) {
			if (not game.hasVisual(self)) game.addVisual(self)
			else {
				game.removeVisual(self)
				game.addVisual(self)
			}
			position = protagonista.position()
			image = direccion.imagenAnteojos()
		}
	}
}