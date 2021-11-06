import wollok.game.*
import utilidades.*

// en la implementación real, conviene tener un personaje por nivel
// los personajes probablemente tengan un comportamiendo más complejo que solamente
// imagen y posición

object personajeSimple inherits Movimiento {
	const property image = "player.png"
	var property energia = 0
	var property salud = 0
	var property dinero = 0
	const property inventario = []
	override method esProtagonista() = true
	method agarrarItem(item) {
		inventario.add(item)
	}
	method desecharItem(item) {
		inventario.remove(item)
	}
	override method reaccionarA(obstaculo) {}
	override method configurate() {
		super()
		game.addVisual(self)
		energia = 1000
		salud = 100
		dinero = 0
		keyboard.up().onPressDo({ self.moverHacia(direccionArriba); energia -= 1 })
		keyboard.down().onPressDo({ self.moverHacia(direccionAbajo); energia -= 1 })
		keyboard.left().onPressDo({ self.moverHacia(direccionIzquierda); energia -= 1 })
		keyboard.right().onPressDo({ self.moverHacia(direccionDerecha); energia -= 1 })
	}
}

class EnemigoComun inherits Movimiento {
	const nombre
	const property image = "crab.png"

	override method reaccionarA(objeto) {
		if (objeto.esProtagonista()) objeto.salud(objeto.salud() - 5)
	}
	override method configurate() {
		super()
		game.addVisual(self)
		game.onTick(1000, nombre, {self.provocarMovimientoAleatorio()})
	}
}

class EnemigoSeguidor inherits Movimiento {
	const nombre
	const property image = "crab_black.png"
	

	override method reaccionarA(objeto) {
		if (objeto.esProtagonista()) objeto.salud(objeto.salud() - 5)
	}
	override method configurate() {
		super()
		game.addVisual(self)
		game.onTick(1000, nombre, {self.moverUnPasoHacia(personajeSimple)})
	}
}
