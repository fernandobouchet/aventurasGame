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
	method tipo() = "protagonista"
	override method reaccionarA(obstaculo) {
		if (obstaculo.tipo() == "enemigo") salud -= 5
		if (obstaculo.tipo() == "ElementoVitalidad") { salud += obstaculo.salud(); game.removeVisual(obstaculo)}
		if (obstaculo.tipo() == "ElementoEnergizante") { energia += obstaculo.energia(); game.removeVisual(obstaculo)}
		if (obstaculo.tipo() == "ElementoEnriquecedor") { dinero += obstaculo.dinero(); game.removeVisual(obstaculo)}
		if (obstaculo.tipo() == "ElementoTransportador") { position = utilidadesParaJuego.posicionArbitraria(); game.removeVisual(obstaculo)}
	}
	method iniciarPersonaje() {
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
	method tipo() = "enemigo"

	override method reaccionarA(obstaculo) {}
	method iniciarMovimiento() {
		game.onTick(1000, nombre, {self.provocarMovimientoAleatorio()})
	}
}

class EnemigoSeguidor inherits Movimiento {
	const nombre
	const property image = "crab_black.png"
	method tipo() = "enemigo"

	override method reaccionarA(obstaculo) {}
	method iniciarMovimiento() {
		game.onTick(1000, nombre, {self.moverUnPasoHacia(personajeSimple)})
	}
}
