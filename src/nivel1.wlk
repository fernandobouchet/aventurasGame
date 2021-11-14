import wollok.game.*
import fondo.*
import personajes.*
import marcadores.*
import accesorios.*
import elementos.*
import nivelbase.*
import nivel2.*
import utilidades.*

object nivelCocos inherits Nivel {

	var cantidadDeCocos = 10
	var property enemigosVivos = []

	method crearCoco() {
		const cocos = new Coco()
		if (cantidadDeCocos != 0) {
			cocos.configurate()
			cantidadDeCocos -= 1
			game.schedule(1000, { self.crearCoco()})
		}
	}

	override method configurate() {
		super()
		barraMarcador.image("marcadorNivel1.png")
		cantidadDeCocos = 10
		self.crearCoco()
		self.cargarPersonajesYObjetos()
		marcadorCoco.actualizar()
		keyboard.control().onPressDo({ neanthy.tirarCoco()})
	}

	override method estadoJuego() {
		if (enemigosVivos.size() == 0) self.terminar() else enemigosVivos.forEach{ enemigo =>
			if (not game.hasVisual(enemigo)) enemigosVivos.remove(enemigo)
		}
	}

	override method terminar() {
		juegoEnPausa = true
		game.schedule(2000, { game.clear()
			const pasarnivel = new Sound(file = "pasarnivel.mp3")
			pasarnivel.play()
			game.addVisual(new Fondo(image = "finNivel1.png"))
			game.schedule(2500, { game.clear()
				game.addVisual(new Fondo(image = "cargandoNivel2.png"))
				game.schedule(3000, { game.clear()
					utilidades.nivel(nivelHuevos)
					nivelHuevos.configurate()
				})
			})
		})
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
		enemigosVivos = [ dinoRex, dino, dino2 ]
		const elementosNivel = [ elementoTransportador1, elementoVit1, elementoSorp1, neanthy ]
		elementosNivel.addAll(enemigosVivos)
		elementosNivel.forEach{ obj => obj.configurate()}
	}

}

