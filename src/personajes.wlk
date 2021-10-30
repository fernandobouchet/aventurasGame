import wollok.game.*
import utilidades.*

// en la implementación real, conviene tener un personaje por nivel
// los personajes probablemente tengan un comportamiendo más complejo que solamente
// imagen y posición

object personajeSimple inherits Movimiento(position = game.at(0,0)) {
	const property image = "player.png"
	var property energia = 1000
	var property salud = 100
	method tipo() = "protagonista"
	override method reaccionarA(obstaculo) {
		if (obstaculo.tipo() == "enemigo") salud -= 5
		if (obstaculo.tipo() == "ElementoVitalidad") { salud += obstaculo.salud(); game.removeVisual(obstaculo)}
	}
	method iniciarPersonaje() {
		game.addVisual(self)
		game.onCollideDo(self, bloqueMovimiento)
		keyboard.up().onPressDo({ self.moverHaciaArriba(); energia -= 1 })
		keyboard.down().onPressDo({ self.moverHaciaAbajo(); energia -= 1 })
		keyboard.left().onPressDo({ self.moverHaciaIzquierda(); energia -= 1 })
		keyboard.right().onPressDo({ self.moverHaciaDerecha(); energia -= 1 })
	}
}

class EnemigoComun inherits Movimiento(position = game.at(5,5)) {
	const nombre
	const property image = "player.png"
	method tipo() = "enemigo"

	override method reaccionarA(obstaculo) {}
	method iniciarMovimiento() {
		game.onCollideDo(self, bloqueMovimiento)
		game.onTick(1000, nombre, {self.provocarMovimientoAleatorio()})
	}
}

class EnemigoSeguidor inherits Movimiento(position = game.at(5,5)) {
	const nombre
	const property image = "player.png"
	method tipo() = "enemigo"

	override method reaccionarA(obstaculo) {}
	method iniciarMovimiento() {
		game.onCollideDo(self, bloqueMovimiento)
		game.onTick(1000, nombre, {self.moverUnPasoHacia(personajeSimple)})
	}
}
