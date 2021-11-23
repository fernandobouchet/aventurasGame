import utilidades.*
import wollok.game.*
import personajes.*

object barraMarcador {
	const property position = game.at(0, game.height() - 1)
	var property image = ""
}

class UnidadNumeroMarcador {
	const property position
	const bloque

	method image() = self.actualizar(bloque.apply())

	method actualizar(numero) {
		const unidad = (numero - numero.div(10) * 10).min(9)
		return "numerosMarcador/" + unidad + ".png"
	}
}

class DecenaNumeroMarcador inherits UnidadNumeroMarcador {
	override method actualizar(numero) {
		const decena = numero.div(10).min(9)
		var nuevaImagen = "transparente.png"
		if (decena != 0) nuevaImagen = "numerosMarcador/d" + decena + ".png"
		return nuevaImagen
	}
}

class MarcadorNumero {
	const posEnX
	const datoASensar
	const decena = new DecenaNumeroMarcador(position = game.at(posEnX, game.height() - 1), bloque = datoASensar)
	const unidad = new UnidadNumeroMarcador(position = game.at(posEnX, game.height() - 1), bloque = datoASensar)

	method configurate() {
		game.addVisual(decena)
		game.addVisual(unidad)
	}
}


object marcadorFuerza inherits MarcadorNumero(posEnX = 3, datoASensar = {utilidades.protagonista().energia()}) {}

object marcadorSalud inherits MarcadorNumero(posEnX = 7, datoASensar = {utilidades.protagonista().salud()}) {}

object marcadorCoco inherits MarcadorNumero(posEnX = 11, datoASensar = {utilidades.protagonista().cocos().size()}) {}

object marcadorBitcoin inherits MarcadorNumero(posEnX = 11, datoASensar = {utilidades.protagonista().dinero()}) {}