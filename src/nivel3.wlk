import wollok.game.*
import fondo.*
import personajes.*
import marcadores.*
import accesorios.*
import elementos.*
import utilidades.*
import nivelbase.*

object nivelBitcoin inherits Nivel {

	const money = new Sound(file = "money.mp3")
	var elementosEnriquecedores = 10

	method crearElementoEnriquecedor() {
		const elementoEnriquecedor = new ElementoEnriquecedor()
		if (elementosEnriquecedores != 0) {
			elementoEnriquecedor.configurate()
			elementosEnriquecedores -= 1
			game.schedule(2500, { self.crearElementoEnriquecedor()})
		}
	}

	override method configurate() {
		super()
		if (not money.played()) {
			money.play()
			money.volume(0.1)
		}
		barraMarcador.image("marcadorNivel3.png")
		elementosEnriquecedores = 10
		marcadorBitcoin.actualizar()
		self.crearElementoEnriquecedor()
	}

	override method estadoJuego() {
		if (neanthy.dinero() == 10 and not game.hasVisual(puertaVictoriosa)) puertaVictoriosa.configurate()
	}

	override method terminar() {
		juegoEnPausa = true
		game.schedule(2000, { game.clear()
			const pasarnivel = new Sound(file = "pasarnivel.mp3")
			pasarnivel.play()
			game.addVisual(new Fondo(image = "finNivel3.png"))
			game.schedule(2500, { game.clear()
				game.addVisual(new Fondo(image = "neanthy-creditos.png"))
			})
		})
	}

	override method perder() {
		super()
		game.schedule(2500, { game.addVisual(new Fondo(image = "neanthy-creditos3.png"))})
	}

	override method cargarPersonajesYObjetos() {
		const dinoRex = new EnemigoSeguidor()
	;
		const dino = new EnemigoComun()
	;
		const dino2 = new EnemigoComun()
	;
		const elementoVit1 = new ElementoVitalidad(salud = 50)
		const elementoSorp1 = new ElementoSorpresa()
		const elementoTransportador1 = new ElementoTransportador()
		const elementosNivel = [ elementoTransportador1, elementoVit1, elementoSorp1, dinoRex, dino, dino2, neanthy ]
		elementosNivel.forEach{ obj => obj.configurate()}
	}

}

