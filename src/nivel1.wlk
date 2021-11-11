import wollok.game.*
import fondo.*
import personajes.*
import marcadores.*
import accesorios.*
import elementos.*
import nivel2.*
import utilidades.*

object nivelBloques {
	var property juegoEnPausa = false
	var property cantElementosEnergizantes = 0
	const maximoElementosEnergizantes = 2
	var property inventario = []
	var elementosNivel1 = []
	
	method crearElementoEnergizante() {
		const elementoEnergizante = new ElementoEnergizante(energia = 30)
		if (maximoElementosEnergizantes >= cantElementosEnergizantes) {
			elementoEnergizante.configurate()
			cantElementosEnergizantes += 1
		}
		
	}
	
	method agregarItem(item) {
		inventario.add(item)
	}
	
	method restart() {
		game.clear()
		self.configurate()
	}
	
	method perder() {
		game.clear()
		game.addVisual(new Fondo(image="neanthy-game-over.png"))
		keyboard.r().onPressDo{ self.restart()}
	}

	method configurate() {
		inventario = []
		game.addVisual(new Fondo(image="neanthy-bgn.png"))
		game.addVisual(barraMarcador)
		
		self.cargarPersonajesYObjetos()
		elementosNivel1.forEach{ obj => obj.configurate()}
		
		self.generarParedesInvisibles()
		
		shampoo.configurate()

		marcadorFuerza.actualizar()
		marcadorSalud.actualizar()
		game.onTick(2000, "elementosEnergizantes", { self.crearElementoEnergizante() })
		game.onTick(50, "perder", {if (personajeSimple.energia() <= 0 or personajeSimple.salud() <= 0) self.perder()})
		
		keyboard.t().onPressDo({ self.terminar() })
		keyboard.r().onPressDo{ self.restart()}
		keyboard.p().onPressDo{ juegoEnPausa = !juegoEnPausa }

	}
	
	method terminar() {
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image="neanthy-bgn.png"))
		// después de un ratito ...
		game.schedule(2500, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo(image="finNivel1.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// ... limpio todo de nuevo
				game.clear()
				// y arranco el siguiente nivel
				nivelLlaves.configurate()
			})
		})
	}
	
	method cargarPersonajesYObjetos(){
		const enemigo = new EnemigoSeguidor();
		const elementoEnergizante = new ElementoEnergizante(energia = 30)
		const elementoEnergizanteQuita = new ElementoEnergizante(energia = -15)
		const elementoVit1 = new ElementoVitalidad(salud = 50)
		const elementoSorp1 = new ElementoSorpresa()
		const elementoTran1 = new ElementoTransportador()
		const huevo1 = new Huevo()
		const huevo2 = new Huevo()
		const huevo3 = new Huevo()
		elementosNivel1 = [
			enemigo,
			sarten,
			huevo1,
			huevo2,
			huevo3,
			fogata,
			elementoEnergizante,
			elementoEnergizanteQuita,
			elementoVit1,
			elementoSorp1,
			elementoTran1,
			personajeSimple
		]
	}
	
	method generarParedesInvisibles() {
		self.generarParedInvisibleEnX(1, 4, 0)
		self.generarParedInvisibleEnX(7, game.width() - 2, 0)
		self.generarParedInvisibleEnX(1, 4, game.height() - 2)
		self.generarParedInvisibleEnX(7, 10, game.height() - 2)
		self.generarParedInvisibleEnY(0, 1, 3)
		self.generarParedInvisibleEnY(0, 7, game.height() - 3)
		self.generarParedInvisibleEnY(game.width() - 1, 1, 3)
		self.generarParedInvisibleEnY(game.width() - 1, 7, game.height() - 3)
	}
	
	method generarParedInvisibleEnX(desdeX, hastaX, y) {
		const pared = []
		pared.add(new Pared(position = game.at(desdeX, y)))
		(hastaX - desdeX).times{ x =>
			pared.add(new Pared(position = game.at(desdeX + x, y)))
		}
		pared.forEach{ p => game.addVisual(p) }
	}

	method generarParedInvisibleEnY(x, desdeY, hastaY) {
		const pared = []
		pared.add(new Pared(position = game.at(x, desdeY)))
		(hastaY - desdeY).times{ y =>
			pared.add(new Pared(position = game.at(x, desdeY + y)))
		}
		pared.forEach{ p => game.addVisual(p) }
	}
}

