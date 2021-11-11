import utilidades.*
import wollok.game.*

object barraMarcador {
	const property position = game.at(0,game.height() - 1)
	const property image = "marcador.png"
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

object marcadorFuerza {
	const decena = new DecenaNumeroMarcador(position = game.at(3,game.height() - 1))
	const unidad = new UnidadNumeroMarcador(position = game.at(3,game.height() - 1))
	
	method actualizar() {
		const energiaProtagonista = utilidadesParaJuego.protagonista().energia()
		if (energiaProtagonista > 99) {
			decena.cambiarOMostrar(9)
			unidad.cambiarOMostrar(9)
		}
		else {
			const decenaT = energiaProtagonista.div(10)
			decena.cambiarOMostrar(decenaT)
			unidad.cambiarOMostrar(energiaProtagonista - decenaT * 10)
		}
	}
}

object marcadorSalud {
	const decena = new DecenaNumeroMarcador(position = game.at(7,game.height() - 1))
	const unidad = new UnidadNumeroMarcador(position = game.at(7,game.height() - 1))
	
	method actualizar() {
		const saludProtagonista = utilidadesParaJuego.protagonista().salud()
		if (saludProtagonista > 99) {
			decena.cambiarOMostrar(9)
			unidad.cambiarOMostrar(9)
		}
		else {
			const decenaT = saludProtagonista.div(10)
			decena.cambiarOMostrar(decenaT)
			unidad.cambiarOMostrar(saludProtagonista - decenaT * 10)
		}
	}
}