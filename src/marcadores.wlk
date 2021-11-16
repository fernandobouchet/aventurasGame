import utilidades.*
import wollok.game.*
import personajes.*

object barraMarcador {

	const property position = game.at(0, game.height() - 1)
	var property image = ""

}

class DecenaNumeroMarcador {

	var image = "numerosMarcador/d0.png"
	const property position

	method image() = image

	method cambiarOMostrar(numero) {
		if (game.hasVisual(self)) game.removeVisual(self)
		if (numero != 0) {
			image = "numerosMarcador/d" + numero + ".png"
			game.addVisual(self)
		}
	}
}

class UnidadNumeroMarcador {

	var image = "numerosMarcador/0.png"
	const property position

	method image() = image

	method cambiarOMostrar(numero) {
		if (game.hasVisual(self)) game.removeVisual(self)
		image = "numerosMarcador/" + numero + ".png"
		game.addVisual(self)
	}

}

class MarcadorNumero {
	const posEnX
	const decena = new DecenaNumeroMarcador(position = game.at(posEnX, game.height() - 1))
	const unidad = new UnidadNumeroMarcador(position = game.at(posEnX, game.height() - 1))

	method datoASensar()

	method actualizar() {
		const dato = self.datoASensar().min(99) //cambio
		const decenaT = dato.div(10)
		decena.cambiarOMostrar(decenaT)
		unidad.cambiarOMostrar(dato - decenaT * 10)
	}
}

object marcadorFuerza inherits MarcadorNumero(posEnX = 3) {
	override method datoASensar() = utilidades.protagonista().energia()
}

object marcadorSalud inherits MarcadorNumero(posEnX = 7) {
	override method datoASensar() = utilidades.protagonista().salud()
}


object marcadorCoco inherits MarcadorNumero(posEnX = 11) {
	override method datoASensar() = utilidades.protagonista().cocos().size()
}


object marcadorBitcoin inherits MarcadorNumero(posEnX = 11) {
	override method datoASensar() = utilidades.protagonista().dinero()
}