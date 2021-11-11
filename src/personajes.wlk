import wollok.game.*
import utilidades.*
import nivel1.*

// en la implementación real, conviene tener un personaje por nivel
// los personajes probablemente tengan un comportamiendo más complejo que solamente
// imagen y posición

object personajeSimple inherits Movimiento {
	const property image = "player.png"
	var property energia = 0
	var property salud = 0
	var property dinero = 0
	const property inventario = []
	method agarrarItem(item) {
		inventario.add(item)
	}
	method desecharItem(item) {
		inventario.remove(item)
	}
	method objetoInteractivoHacia() {
		return self.objetosHacia(ultimoMovimiento).find({ obj => not obj.esAtravesable() and obj.esInteractivo()})
	}
	
	method recibirAtaque(danio) {
		salud -= danio
		marcadorSalud.actualizar()
	}
	
	method cansarse(cantidad) {
		energia -= cantidad
		marcadorFuerza.actualizar()
	}
	
	method hayObjetoInteractivo() {
		return self.objetosHacia(ultimoMovimiento).any({ obj => not obj.esAtravesable() and obj.esInteractivo()})
	}
	override method reaccionarA(obstaculo) {}
	override method configurate() {
		super()
		game.addVisual(self)
		energia = 30
		salud = 100
		dinero = 0
		keyboard.up().onPressDo({ self.moverHacia(direccionArriba); self.cansarse(1) })
		keyboard.down().onPressDo({ self.moverHacia(direccionAbajo); self.cansarse(1) })
		keyboard.left().onPressDo({ self.moverHacia(direccionIzquierda); self.cansarse(1) })
		keyboard.right().onPressDo({ self.moverHacia(direccionDerecha); self.cansarse(1) })
		keyboard.space().onPressDo{if (self.hayObjetoInteractivo()) self.objetoInteractivoHacia().interactuarCon(self)}
	}
}

class EnemigoComun inherits Movimiento {
	const property image = "crab.png"

	override method reaccionarA(objeto) {
		if (objeto == utilidadesParaJuego.protagonista()) objeto.recibirAtaque(5)
	}
	override method configurate() {
		super()
		game.addVisual(self)
		game.onTick(1000, "enemigoComun", {self.provocarMovimientoAleatorio()})
	}
}

class EnemigoSeguidor inherits Movimiento {
	const property image = "crab_black.png"
	
	override method reaccionarA(objeto) {
		if (objeto == utilidadesParaJuego.protagonista()) objeto.recibirAtaque(5)
	}
	override method configurate() {
		super()
		game.addVisual(self)
		game.onTick(1000, "enemigoSeguidor", {self.moverUnPasoHacia(personajeSimple)})
	}
}
