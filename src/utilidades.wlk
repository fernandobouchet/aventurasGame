import wollok.game.*
import personajes.*
import accesorios.*
import nivel1.*

object utilidades {

	var property nivel = nivelCocos

	method posicionArbitraria() {
		return game.at(2.randomUpTo(game.width() - 2).truncate(0), 2.randomUpTo(game.height() - 3).truncate(0))
	}

	method posicionArbitrariaNoOcupada() {
		var posicionA = self.posicionArbitraria()
		if (game.getObjectsIn(posicionA).size() > 0) posicionA = self.posicionArbitrariaNoOcupada()
		return posicionA
	}

	method protagonista() = neanthy

}

object direccionArriba {

	method siguienteMovimiento(desdePosicion) {
		return 
			if (desdePosicion.y() == game.height() - 2) game.at(desdePosicion.x(), 0) 
			else desdePosicion.up(1)
	}

	method imagenPelo() = "neanthy_izq_" + pelo.formaPelo() + ".png"

	method imagenProtagonista() = 
		if (neanthy.esAtacado()) "neanthy_atacado.png" 
		else "neanthy_izq" + (if(neanthy.enMovimiento()) "_mov" else "") + ".png"

	method imagenAnteojos() = "neanthy_izq_anteojos.png"

	method imagenReloj() = "neanthy_izq_" + (if(neanthy.enMovimiento()) "watch2" else "watch") + ".png"

	method imagenDino() = "dino-izq.png"

	method imagenDinoRex() = "dino-rex-izq.png"

}

object direccionAbajo {

	method siguienteMovimiento(desdePosicion) {
		return 
			if (desdePosicion.y() == 0) game.at(desdePosicion.x(), game.height() - 2) 
			else desdePosicion.down(1)
	}

	method imagenPelo() = "neanthy_der_" + pelo.formaPelo() + ".png"

	method imagenProtagonista() = 
		if (neanthy.esAtacado()) "neanthy_atacado.png" 
		else "neanthy_der" + (if(neanthy.enMovimiento()) "_mov" else "") + ".png"

	method imagenAnteojos() = "neanthy_der_anteojos.png"

	method imagenReloj() = "transparente.png"

	method imagenDino() = "dino-der.png"

	method imagenDinoRex() = "dino-rex-der.png"

}

object direccionIzquierda {

	method siguienteMovimiento(desdePosicion) {
		return 
			if (desdePosicion.x() == 0) game.at(game.width() - 1, desdePosicion.y()) 
			else desdePosicion.left(1)
	}

	method imagenPelo() = "neanthy_izq_" + pelo.formaPelo() + ".png"

	method imagenProtagonista() = 
		if (neanthy.esAtacado()) "neanthy_atacado.png" 
		else "neanthy_izq" + (if(neanthy.enMovimiento()) "_mov" else "") + ".png"

	method imagenAnteojos() = "neanthy_izq_anteojos.png"

	method imagenReloj() = "neanthy_izq_" + (if(neanthy.enMovimiento()) "watch2" else "watch") + ".png"

	method imagenDino() = "dino-izq.png"

	method imagenDinoRex() = "dino-rex-izq.png"

}

object direccionDerecha {

	method siguienteMovimiento(desdePosicion) {
		return 
			if (desdePosicion.x() == game.width() - 1) game.at(0, desdePosicion.y()) 
			else desdePosicion.right(1)
	}

	method imagenPelo() = "neanthy_der_" + pelo.formaPelo() + ".png"

	method imagenProtagonista() = if (neanthy.esAtacado()) "neanthy_atacado.png" else "neanthy_der" + (if(neanthy.enMovimiento()) "_mov" else "") + ".png"

	method imagenAnteojos() = "neanthy_der_anteojos.png"

	method imagenReloj() = "transparente.png"

	method imagenDino() = "dino-der.png"

	method imagenDinoRex() = "dino-rex-der.png"

}

class ElementoBase {
	method reaccionarA(objeto) {}

	method esAtravesable() = true

	method esInteractivo() = false
	
	method morir() {}
	
	method accionarEfecto(objeto) {}

	method agarrar(item) {}

	method recibirAtaque(danio) {}
}

class Movimiento inherits ElementoBase {

	var property position = game.at(0, 0)
	var property image
	var property ultimoMovimiento = direccionDerecha
	var enMovimiento = false

	override method esAtravesable() = false
	
	method empujar(objeto) {}

	method enMovimiento() = enMovimiento

	method configurate() {
		position = utilidades.posicionArbitrariaNoOcupada()
	}

	method actualizarImagen() {
	}

	method objetosHacia(direccion) {
		return game.getObjectsIn(direccion.siguienteMovimiento(position))
	}

	method puedeMover(direccion) {
		return self.objetosHacia(direccion).all{ objeto => objeto.esAtravesable() }
	}

	method moverHacia(direccion) {
		if (not utilidades.nivel().juegoEnPausa()) {
			ultimoMovimiento = direccion
			if (self.puedeMover(direccion)) {
				if (game.hasVisual(self)) {
					game.removeVisual(self)
					game.addVisual(self)
				}
				position = direccion.siguienteMovimiento(position)
			} else {
				const objetoHacia = self.objetosHacia(direccion).find{ objeto => not objeto.esAtravesable() }
				objetoHacia.reaccionarA(self)
				self.reaccionarA(objetoHacia)
			}
			enMovimiento = false
			self.actualizarImagen()
		}
	}

	method provocarMovimientoAleatorio() {
		const movimientosPosibles = [ direccionArriba, direccionAbajo, direccionDerecha, direccionIzquierda ]
		self.moverHacia(movimientosPosibles.anyOne())
	}

	method moverUnPasoHacia(objetivo) {
		const xObjetivo = objetivo.position().x()
		const yObjetivo = objetivo.position().y()
		const numAleatorio = 0.randomUpTo(100)
		if (numAleatorio < 50) {
			if (xObjetivo != position.x()) {
				if (xObjetivo < position.x()) self.moverHacia(direccionIzquierda) 
				else self.moverHacia(direccionDerecha)
			} else {
				if (yObjetivo < position.y()) self.moverHacia(direccionAbajo) 
				else self.moverHacia(direccionArriba)
			}
		} else {
			if (yObjetivo != position.y()) {
				if (yObjetivo < position.y()) self.moverHacia(direccionAbajo) 
				else self.moverHacia(direccionArriba)
			} else {
				if (xObjetivo < position.x()) self.moverHacia(direccionIzquierda) 
				else self.moverHacia(direccionDerecha)
			}
		}
	}
}

