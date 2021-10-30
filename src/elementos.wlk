import wollok.game.*
import utilidades.*
import personajes.*

class Bloque {
	var property position
	const property image = "market.png" 	
	
	// agregar comportamiento	
}

class CajaMovible inherits Movimiento(position = utilidadesParaJuego.posicionArbitraria()) {
	const property image = "enemigoVivo.png" 
	method tipo() = "CajaMovible"
	override method reaccionarA(objeto) {
		const positionX = personajeSimple.position().x()
		const positionY = personajeSimple.position().y()
		if (positionX == game.width() - 1 or positionX < position.x()) self.moverHaciaDerecha()
		if (positionX == 0 or positionX > position.x()) self.moverHaciaIzquierda()
		if (positionY == 0 or positionY < position.y()) self.moverHaciaArriba()
		if (positionY == game.height() - 2 or positionY > position.y()) self.moverHaciaAbajo()
	}	
}
