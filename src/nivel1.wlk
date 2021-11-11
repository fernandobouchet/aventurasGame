import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel2.*
import utilidades.*

object nivelBloques {
	var property juegoEnPausa = false
	var property inventario = []
	method agregarItem(item) {
		inventario.add(item)
	}
	
	method restart() {
		game.clear()
		self.configurate()
	}
	
	method perder() {
		game.clear()
		game.addVisual(new Fondo(image="neanthy-bgn.png"))
		game.addVisual(marcadorPerder)
		keyboard.r().onPressDo{ self.restart()}
	}

	method configurate() {
		inventario = []
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image="neanthy-bgn.png")) //nuevo fondo de juego
		game.addVisual(barraMarcador)
		// otros visuals, p.ej. bloques o llaves
		var enemigo2
		const enemigo = new EnemigoSeguidor(); enemigo.configurate()
		2.times {i => enemigo2 = new EnemigoComun(); enemigo2.configurate()}
		const elementoEnergizante = new ElementoEnergizante(energia = 30)
		const elementoEnergizanteQuita = new ElementoEnergizante(energia = -15)
		const elementoVit1 = new ElementoVitalidad(salud = 50)
		const elementoSorp1 = new ElementoSorpresa()
		const elementoTran1 = new ElementoTransportador()
		const caja1 = new CajaMovible()
		const caja2 = new CajaMovible()
		const caja3 = new CajaMovible()
		const llave1 = new LlavePesada()
		const llave2 = new LlavePesada()
		const llave3 = new LlavePesada()
		const listaElementos = [caja1,caja2,caja3,llave1,llave2,llave3,deposito,elementoEnergizante,elementoEnergizanteQuita,elementoVit1,elementoSorp1,elementoTran1, personajeSimple]

		// personaje, es importante que sea el último visual que se agregue
		//game.addVisual(marcador)
		listaElementos.forEach{ obj => obj.configurate()}
		marcadorFuerza.actualizar()
		marcadorSalud.actualizar()
		// teclado
		// este es para probar, no es necesario dejarlo
		game.onTick(50, "perder", {if (personajeSimple.energia() <= 0 or personajeSimple.salud() <= 0) self.perder()})
		keyboard.t().onPressDo({ self.terminar() })
		keyboard.r().onPressDo{ self.restart()}
		keyboard.p().onPressDo{ juegoEnPausa = !juegoEnPausa }
		// en este no hacen falta colisiones
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
		
}

