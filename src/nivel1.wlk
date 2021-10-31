import wollok.game.*
import fondo.*
import personajes.*
import elementos.*
import nivel2.*
import utilidades.*

object nivelBloques {
	method perder() {
		game.clear()
		game.addVisual(new Fondo(image="fondoCompleto.png"))
		game.addVisual(marcadorPerder)
	}

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image="fondoCompleto.png"))
				 
		// otros visuals, p.ej. bloques o llaves
		game.addVisual(new Bloque(position=game.at(3,12)))
		const enemigo = new EnemigoComun(nombre = "malo")
		const enemigo2 = new EnemigoSeguidor(nombre = "malo2")
		5.times{ i => new ElementoEnergizante(energia = 1500)}
	
		// personaje, es importante que sea el último visual que se agregue
		game.addVisual(marcador)
		game.addVisual(enemigo)
		game.addVisual(enemigo2)
		game.addVisual(new CajaMovible())
		game.addVisual(new ElementoVitalidad(salud = 5220))
		game.addVisual(new ElementoEnriquecedor(dinero = 1000))
		personajeSimple.iniciarPersonaje()
		enemigo.iniciarMovimiento()
		enemigo2.iniciarMovimiento()
		// teclado
		// este es para probar, no es necesario dejarlo
		game.onTick(50, "perder", {if (personajeSimple.energia() <= 0 or personajeSimple.salud() <= 0) self.perder()})
		keyboard.t().onPressDo({ self.terminar() })

		// en este no hacen falta colisiones
	}
	
	method terminar() {
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image="fondoCompleto.png"))
		personajeSimple.iniciarPersonaje()
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

