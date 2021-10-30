import wollok.game.*
import personajes.*

object utilidadesParaJuego {
	method posicionArbitraria() {
		return game.at(
			0.randomUpTo(game.width()).truncate(0), 0.randomUpTo(game.height() - 1).truncate(0)
		)
	}
}

object marcador{
    method position() = game.at(1,14)
    method text() = "Energia: " + personajeSimple.energia() + " - " + " Salud: " + personajeSimple.salud()
    + " - " + "Dinero: " + personajeSimple.dinero()
}

object marcadorPerder {
    method position() = game.at(1,14)
    method text() = "Perdiste el nivel"}

class Movimiento {
	var property position
	var ultimaPosicion = new Position(x = position.x(), y = position.y())
	var enMovimiento = false
	var puedeMover = true
	const bloqueMovimiento = { obstaculo =>
		if (not obstaculo.esAtravesable() && enMovimiento) position = ultimaPosicion
		self.reaccionarA(obstaculo)
		obstaculo.reaccionarA(self)
	}

	method reaccionarA(obstaculo)
	method esAtravesable() = false
	
	method moverHaciaArriba() {
		if (puedeMover) {
			puedeMover = false
			enMovimiento = true
			ultimaPosicion = new Position(x = position.x(), y = position.y())
			if (position.y() == game.height() - 2) position = new Position(x = position.x(), y = 0)
			else position = position.up(1)
			game.schedule(10, {enMovimiento = false; puedeMover = true})
		}
	}
	method moverHaciaAbajo() {
		if (puedeMover) {
			puedeMover = false
			enMovimiento = true
			ultimaPosicion = new Position(x = position.x(), y = position.y())
			if (position.y() == 0) position = new Position(x = position.x(), y = game.height() - 2)
			else position = position.down(1)
			game.schedule(10, {enMovimiento = false; puedeMover = true})
		}
	}
	method moverHaciaIzquierda() {
		if (puedeMover) {
			puedeMover = false
			enMovimiento = true
			ultimaPosicion = new Position(x = position.x(), y = position.y())
			if (position.x() == 0) position = new Position(x = game.width() - 1, y = position.y())
			else position = position.left(1)
			game.schedule(10, {enMovimiento = false; puedeMover = true})
		}
	}
	method moverHaciaDerecha() {
		if (puedeMover) {
			puedeMover = false
			enMovimiento = true
			ultimaPosicion = new Position(x = position.x(), y = position.y())
			if (position.x() == game.width() - 1) position = new Position(x = 0, y = position.y())
			else position = position.right(1)
			game.schedule(10, {enMovimiento = false; puedeMover = true})
		}
	}
	method provocarMovimientoAleatorio() {
		const numAleatorio = 0.randomUpTo(100)
		if (numAleatorio < 25) self.moverHaciaArriba()
		else
			if (numAleatorio < 50) self.moverHaciaDerecha()
			else
				if (numAleatorio < 75) self.moverHaciaAbajo()
					else self.moverHaciaIzquierda()
	}
	method moverUnPasoHacia(objetivo) {
		const xObjetivo = objetivo.position().x()
		const yObjetivo = objetivo.position().y()
		const numAleatorio = 0.randomUpTo(100)
		if (numAleatorio < 50){
			if(xObjetivo != position.x()) {
				if (xObjetivo < position.x()) self.moverHaciaIzquierda()
				else self.moverHaciaDerecha()
			}
			else {
				if (yObjetivo < position.y()) self.moverHaciaAbajo()
				else self.moverHaciaArriba()
			}
		}
		else {
			if(yObjetivo != position.y()) {
				if (yObjetivo < position.y()) self.moverHaciaAbajo()
				else self.moverHaciaArriba()
			}
			else {
				if (xObjetivo < position.x()) self.moverHaciaIzquierda()
				else self.moverHaciaDerecha()
			}
		}
	}
}