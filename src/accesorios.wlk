import wollok.game.*
import utilidades.*
import personajes.*

object pelo inherits ElementoBase {
	var image = "neanthy_der_pelo_1.png"
	var position = game.at(0,0)
	
	method image() = image
	
	method position() = position

	method actualizar() {
		position = utilidades.protagonista().position()
		image = utilidades.protagonista().ultimoMovimiento().imagenPelo()
		game.removeVisual(self)
		game.addVisual(self)
	}

	method formaPelo() =
		if (utilidades.protagonista().tiene(peine)) "pelo_2"
		else "pelo_1"
}

class AccesorioAgarrable inherits ElementoBase{
	var position = game.at(0,0)
	var image
	const property sonido

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
	
	override method reaccionarA(objeto) {
		if (not utilidades.protagonista().tiene(self)) {
			objeto.agarrar(self)
		}
	}
}

object peine inherits AccesorioAgarrable(image = "peine.png", sonido = "oh-yeah.wav") {}

object reloj inherits AccesorioAgarrable(image = "reloj.png", sonido = "cool.wav") {
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

object anteojos inherits AccesorioAgarrable(image = "anteojos.png", sonido = "yeah.wav") {
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