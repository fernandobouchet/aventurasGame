import wollok.game.*
import personajes.*

object utilidadesParaJuego {
	method posicionArbitraria() {
		return game.at(
			0.randomUpTo(game.width()).truncate(0), 0.randomUpTo(game.height() - 1).truncate(0)
		)
	}
}

object direccionArriba{}
object direccionAbajo{}
object direccionIzquierda{}
object direccionDerecha{}

object marcador{
    method position() = game.at(1,game.height() - 1)
    method text() = "Energia: " + personajeSimple.energia() + " - " + " Salud: " + personajeSimple.salud()
    + " - " + "Dinero: " + personajeSimple.dinero()
}

object marcadorPerder {
    method position() = game.at(1,game.height() - 1)
    method text() = "Perdiste el nivel"}

class Movimiento {
	var property position = utilidadesParaJuego.posicionArbitraria()
	var property ultimoMovimiento = direccionAbajo

	method reaccionarA(obstaculo)
	
	method esAtravesable() = false
	
	method siguienteMovimientoHacia(direccion) {
		var siguiente
		if (direccion == direccionDerecha) 
			siguiente =
				if (position.x() == game.width() - 1)
					game.at(0, position.y())
				else
					position.right(1)
		if (direccion == direccionIzquierda) 
			siguiente =
				if (position.x() == 0)
					game.at(game.width() - 1, position.y())
				else
					position.left(1) 
		if (direccion == direccionArriba) 
			siguiente =
				if (position.y() == game.height() - 2)
					game.at(position.x(), 0)
				else
					position.up(1)
		if (direccion == direccionAbajo) 
			siguiente =
				if (position.y() == 0)
					game.at(position.x(), game.height() - 2)
				else
					position.down(1)
		return siguiente
	}

	method objetosHacia(direccion) {
		return game.getObjectsIn(self.siguienteMovimientoHacia(direccion))
	}
	
	method puedeMover(direccion) {
		return self.objetosHacia(direccion).all{ objeto => objeto.esAtravesable() }
	} 

	method moverHacia(direccion) {
		ultimoMovimiento = direccion
		if (self.puedeMover(direccion)) position = self.siguienteMovimientoHacia(direccion)
		else {
			const objetoHacia = self.objetosHacia(direccion).find{objeto => not objeto.esAtravesable()}
			objetoHacia.reaccionarA(self)
			self.reaccionarA(objetoHacia)
		}
	}
	
	method provocarMovimientoAleatorio() {
		const numAleatorio = 0.randomUpTo(100)
		if (numAleatorio < 25) self.moverHacia(direccionArriba)
		else
			if (numAleatorio < 50) self.moverHacia(direccionDerecha)
			else
				if (numAleatorio < 75) self.moverHacia(direccionAbajo)
					else self.moverHacia(direccionIzquierda)
	}
	method moverUnPasoHacia(objetivo) {
		const xObjetivo = objetivo.position().x()
		const yObjetivo = objetivo.position().y()
		const numAleatorio = 0.randomUpTo(100)
		if (numAleatorio < 50){
			if(xObjetivo != position.x()) {
				if (xObjetivo < position.x()) self.moverHacia(direccionIzquierda)
				else self.moverHacia(direccionDerecha)
			}
			else {
				if (yObjetivo < position.y()) self.moverHacia(direccionAbajo)
				else self.moverHacia(direccionArriba)
			}
		}
		else {
			if(yObjetivo != position.y()) {
				if (yObjetivo < position.y()) self.moverHacia(direccionAbajo)
				else self.moverHacia(direccionArriba)
			}
			else {
				if (xObjetivo < position.x()) self.moverHacia(direccionIzquierda)
				else self.moverHacia(direccionDerecha)
			}
		}
	}
}