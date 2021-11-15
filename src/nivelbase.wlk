import wollok.game.*
import fondo.*
import personajes.*
import marcadores.*
import accesorios.*
import elementos.*
import utilidades.*

class Nivel {

	var property juegoEnPausa = false
	var elementoEnergia = new ElementoEnergizante(energia = 30)

	method crearElementoEnergizante() {
		if (not game.hasVisual(elementoEnergia)) {
			elementoEnergia = new ElementoEnergizante(energia = 30)
			if (0.randomUpTo(100) > 90) elementoEnergia = new ElementoEnergizante(energia = -20)
			elementoEnergia.configurate()
		}
		game.schedule(4000.randomUpTo(8000).truncate(0), { self.crearElementoEnergizante()})
	}

	method restart() {
		game.clear()
		self.configurate()
	}

	method perder() {
		const sonidoPerder = new Sound(file = "oh-no.mp3")
		game.clear()
		sonidoPerder.play()
		game.addVisual(new Fondo(image = "neanthy-game-over.png"))
		keyboard.r().onPressDo{ self.restart()}
	}

	method configurate() {
		game.addVisual(new Fondo(image = "neanthy-bgn.png"))
		game.addVisual(barraMarcador)
		neanthy.esAtacado(false)
		self.generarParedes()
		self.crearElementoEnergizante()
		self.cargarPersonajesYObjetos()
		marcadorFuerza.actualizar()
		marcadorSalud.actualizar()
		game.onTick(50, "perder", { if (neanthy.energia() <= 0 or neanthy.salud() <= 0) self.perder()
		})
		keyboard.t().onPressDo({ self.terminar()})
		keyboard.r().onPressDo{ self.restart()}
		keyboard.p().onPressDo{ juegoEnPausa = !juegoEnPausa}
		game.onTick(50, "estado juego", { self.estadoJuego()})
	}

	method estadoJuego()

	method terminar()

	method cargarPersonajesYObjetos()

	method generarParedes() {
		self.generarParedEnX(1, 4, 0)
		self.generarParedEnX(7, game.width() - 2, 0)
		self.generarParedEnX(1, 4, game.height() - 2)
		self.generarParedEnX(7, 10, game.height() - 2)
		self.generarParedEnY(0, 1, 3)
		self.generarParedEnY(0, 7, game.height() - 3)
		self.generarParedEnY(game.width() - 1, 1, 3)
		self.generarParedEnY(game.width() - 1, 7, game.height() - 3)
	}

	method generarParedEnX(desdeX, hastaX, y) {
		const pared = []
		pared.add(new Pared(position = game.at(desdeX, y)))
		(hastaX - desdeX).times{ x => pared.add(new Pared(position = game.at(desdeX + x, y)))}
		pared.forEach{ p => game.addVisual(p)}
	}

	method generarParedEnY(x, desdeY, hastaY) {
		const pared = []
		pared.add(new Pared(position = game.at(x, desdeY)))
		(hastaY - desdeY).times{ y => pared.add(new Pared(position = game.at(x, desdeY + y)))}
		pared.forEach{ p => game.addVisual(p)}
	}

}

