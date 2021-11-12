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
	}

	method formaPelo() =
		if (utilidadesParaJuego.protagonista().tiene(shampoo)) "pelo_2"
		else "pelo_1"
}

object shampoo {
	var position = game.at(0,0)
	const property image = "chicken.png"

	method position() = position
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
			objeto.actualizarImagen(false)
			game.removeVisual(self)
		}
	}
}