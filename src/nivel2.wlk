import wollok.game.*
import fondo.*
import personajes.*

object nivelBitcoin {
	var property juegoEnPausa = false

	method configurate() {
		game.addVisual(new Fondo(image="neanthy-bgn.png"))
		neanthy.configurate()
		
		// teclado
		// este es para probar, no es necesario dejarlo
		keyboard.g().onPressDo({ self.ganar() })

		// colisiones, acá sí hacen falta
	}
	
	method ganar() {
		// es muy parecido al terminar() de nivelBloques
		// el perder() también va a ser parecido
		
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(image="fondoCompleto.png"))
		// después de un ratito ...
		game.schedule(2500, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo(image="ganamos.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// fin del juego
				game.stop()
			})
		})
	}
	
	
}
