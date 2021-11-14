import utilidades.*
import wollok.game.*
import personajes.*

object barraMarcador {
	const property position = game.at(0,game.height() - 1)
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

object marcadorBitcoin {
	
	const decena = new DecenaNumeroMarcador(position = game.at(11,game.height() - 1))
	const unidad = new UnidadNumeroMarcador(position = game.at(11,game.height() - 1))
	
	method actualizar() {
		const dineroProtagonista = utilidadesParaJuego.protagonista().dinero()
		if (dineroProtagonista > 99) {
			decena.cambiarOMostrar(9)
			unidad.cambiarOMostrar(9)
		}
		else {
			const decenaT = dineroProtagonista.div(10)
			decena.cambiarOMostrar(decenaT)
			unidad.cambiarOMostrar(dineroProtagonista - decenaT * 10)
		}
	}
}

object marcadorCoco {
	
	const decena = new DecenaNumeroMarcador(position = game.at(11,game.height() - 1))
	const unidad = new UnidadNumeroMarcador(position = game.at(11,game.height() - 1))
	
	method actualizar() {
		const cocosProtagonista = neanthy.cocos().size()
		if (cocosProtagonista > 99) {
			decena.cambiarOMostrar(9)
			unidad.cambiarOMostrar(9)
		}
		else {
			const decenaT = cocosProtagonista.div(10)
			decena.cambiarOMostrar(decenaT)
			unidad.cambiarOMostrar(cocosProtagonista - decenaT * 10)
		}
	}
}