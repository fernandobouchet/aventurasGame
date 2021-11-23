import wollok.game.*
import fondo.*
import personajes.*
import marcadores.*
import accesorios.*
import elementos.*
import nivelbase.*
import nivel3.*
import utilidades.*

object nivelHuevos inherits Nivel {

	const ruidofogata = new Sound(file = "fuegonivel2.mp3")
	var elementoTransportador = new ElementoTransportador()

	method crearElementoTransportador() {
		if (not game.hasVisual(elementoTransportador)) {
			elementoTransportador = new ElementoTransportador()
			elementoTransportador.configurate()
		}
		game.schedule(4000.randomUpTo(8000).truncate(0), { self.crearElementoTransportador()})
	}

	override method estadoJuego() {
		if (fogata.estaCompleta() and neanthy.inventario().size() == 3) self.terminar()
	}

	override method terminar() {
		juegoEnPausa = true
		game.schedule(2000, { ruidofogata.stop()
			game.clear()
			const pasarnivel = new Sound(file = "pasarnivel.mp3")
			pasarnivel.play()
			game.addVisual(new Fondo(image = "finNivel2.png"))
			game.schedule(2500, { game.clear()
				game.addVisual(new Fondo(image = "cargandoNivel3.png"))
				game.schedule(3000, { game.clear()
					utilidades.nivel(nivelBitcoin)
					nivelBitcoin.configurate()
				})
			})
		})
	}
	
	override method perder() {
		super()
		game.schedule(2500, { game.addVisual(new Fondo(image = "neanthy-creditos2.png"))})
	}
	
	override method configurate() {
		super()
		if (not ruidofogata.played()) {
			ruidofogata.shouldLoop(true)
			ruidofogata.play()
		}
		utilidades.protagonista().vaciarInventario()
		barraMarcador.image("marcadorNivel2.png")
		self.crearElementoTransportador()
	}

	override method cargarPersonajesYObjetos() {
		const dinoRex = new EnemigoSeguidor()
		const dino = new EnemigoComun()
		const elementoVit1 = new ElementoVitalidad(salud = 50)
		const elementoSorp1 = new ElementoSorpresa()
		const huevo1 = new Huevo()
		const huevo2 = new Huevo()
		const huevo3 = new Huevo()
		const elementosNivel = [ fogata, sarten, huevo1, huevo2, huevo3, peine, reloj, anteojos, elementoVit1, elementoSorp1, dinoRex, dino, neanthy ]
		elementosNivel.forEach{ obj => obj.configurate()}
	}
}

