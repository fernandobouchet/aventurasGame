import wollok.game.*
import utilidades.*
import personajes.*

object pelo {
	var image = "neanthy_der_pelo_1.png"
	var position = game.at(0,0)
	
	method image() = image
	
	method position() = position

	method esAtravesable() = true

	method actualizar() {
		position = neanthy.position()
		image = neanthy.ultimoMovimiento().imagenPelo()
		game.removeVisual(self)
		game.addVisual(self)
	}

	method formaPelo() =
		if (neanthy.tiene(peine)) "pelo_2"
		else "pelo_1"
}

class AccesorioAgarrable {
	var position = game.at(0,0)
	var image

	method position() = position
	method image() = image
	
	method configurate() {
		position = utilidades.posicionArbitrariaNoOcupada()
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			if(not objeto.esAtravesable()) self.reaccionarA(objeto)
		})
	}
	
	method esAtravesable() = true
	method reaccionarA(objeto) {
		if (objeto == utilidades.protagonista() and not neanthy.tiene(self)) {
			game.removeVisual(self)
			objeto.agarrarItem(self)
			objeto.actualizarImagen()
		}
	}
}

object peine inherits AccesorioAgarrable(image = "peine.png") {}

object reloj inherits AccesorioAgarrable(image = "reloj.png") {
	override method configurate() {
		super()
		image = "reloj.png"
	}
	method actualizar() {
		if (neanthy.tiene(self)) {
			if (not game.hasVisual(self)) game.addVisual(self)
			else {
				game.removeVisual(self)
				game.addVisual(self)
			}
			position = neanthy.position()
			image = neanthy.ultimoMovimiento().imagenReloj()
		}
	}
}

object anteojos inherits AccesorioAgarrable(image = "anteojos.png") {
	override method configurate() {
		super()
		image = "anteojos.png"
	}
	method actualizar() {
		if (neanthy.tiene(self)) {
			if (not game.hasVisual(self)) game.addVisual(self)
			else {
				game.removeVisual(self)
				game.addVisual(self)
			}
			position = neanthy.position()
			image = neanthy.ultimoMovimiento().imagenAnteojos()
		}
	}
}