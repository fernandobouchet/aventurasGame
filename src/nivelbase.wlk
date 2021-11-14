import wollok.game.*
import fondo.*
import personajes.*
import marcadores.*
import accesorios.*
import elementos.*
import utilidades.*


class Nivel {
	
	var property juegoEnPausa = false
	var property cantElementosEnergizantes = 0
	
	method crearElementoEnergizante() {
		var elementoEnergizante = new ElementoEnergizante(energia = 30)
		if(0.randomUpTo(100) > 90) elementoEnergizante = new ElementoEnergizante(energia = -20)
		if (cantElementosEnergizantes == 0) {
			elementoEnergizante.configurate()
			cantElementosEnergizantes += 1
		}	
	}
	
	method restart() {
		game.clear()
		self.configurate()
	}
	
	method perder() {
		game.clear()
		game.addVisual(new Fondo(image="neanthy-game-over.png"))
		game.schedule(2500, {
			game.addVisual(new Fondo(image="neanthy-creditos.png"))
			})
		keyboard.r().onPressDo{ self.restart()}
	}

	method configurate() {
		cantElementosEnergizantes = 0	
		game.addVisual(new Fondo(image="neanthy-bgn.png"))
		game.addVisual(barraMarcador)
		neanthy.esAtacado(false)
		self.cargarPersonajesYObjetos()
		self.generarParedes()
		

		marcadorFuerza.actualizar()
		marcadorSalud.actualizar()
		game.onTick(4000, "elementosEnergizantes", { self.crearElementoEnergizante() })
		game.onTick(50, "perder", {if (neanthy.energia() <= 0 or neanthy.salud() <= 0) self.perder()})
		keyboard.t().onPressDo({ self.terminar() })
		keyboard.r().onPressDo{ self.restart()}
		keyboard.p().onPressDo{ juegoEnPausa = !juegoEnPausa }
		game.onTick(50, "estado juego",{self.estadoJuego()})
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
		(hastaX - desdeX).times{ x =>
			pared.add(new Pared(position = game.at(desdeX + x, y)))
		}
		pared.forEach{ p => game.addVisual(p) }
	}

	method generarParedEnY(x, desdeY, hastaY) {
		const pared = []
		pared.add(new Pared(position = game.at(x, desdeY)))
		(hastaY - desdeY).times{ y =>
			pared.add(new Pared(position = game.at(x, desdeY + y)))
		}
		pared.forEach{ p => game.addVisual(p) }
	}
}

