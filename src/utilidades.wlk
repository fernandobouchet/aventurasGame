import wollok.game.*
import personajes.*
import accesorios.*
import nivel1.*

object utilidadesParaJuego {
	var property nivel = 1
	method posicionArbitraria() {
		return game.at(
			2.randomUpTo(game.width() - 2).truncate(0), 2.randomUpTo(game.height() - 3).truncate(0)
		)
	}
	
	method posicionArbitrariaNoOcupada() {
		var posicionA = self.posicionArbitraria()
		if (game.getObjectsIn(posicionA).size() > 0)
			posicionA = self.posicionArbitrariaNoOcupada()
		return posicionA
	}
	method protagonista() = personajeSimple
}

object direccionArriba{
	method imagenPelo() = "neanthy_izq_"+ pelo.formaPelo() +".png"
	method imagenProtagonista(caminando)
		= "neanthy_izq" + (if(caminando) "_mov" else "") + ".png"
	method imagenAnteojos() = "neanthy_izq_anteojos.png"
}
object direccionAbajo{
	method imagenPelo() = "neanthy_der_"+ pelo.formaPelo() +".png"
	method imagenProtagonista(caminando)
		= "neanthy_der" + (if(caminando) "_mov" else "") +".png"
	method imagenAnteojos() = "neanthy_der_anteojos.png"
}
object direccionIzquierda{
	method imagenPelo() = "neanthy_izq_"+ pelo.formaPelo() +".png"
	method imagenProtagonista(caminando)
		= "neanthy_izq" + (if(caminando) "_mov" else "") +".png"
	method imagenAnteojos() = "neanthy_izq_anteojos.png"
}
object direccionDerecha{
	method imagenPelo() = "neanthy_der_"+ pelo.formaPelo() +".png"
	method imagenProtagonista(caminando)
		= "neanthy_der" + (if(caminando) "_mov" else "") +".png"
	method imagenAnteojos() = "neanthy_der_anteojos.png"
}

class Movimiento {
	var property position = game.at(0,0)
	var property image
	var property ultimoMovimiento = direccionDerecha

	method reaccionarA(obstaculo)
		
	method esAtravesable() = false
	
	method esInteractivo() = false	
	
	method configurate() { position = utilidadesParaJuego.posicionArbitrariaNoOcupada() }
	
	method actualizarImagen(movimiento) {}
	
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
		if (not nivelBloques.juegoEnPausa()) {
			ultimoMovimiento = direccion
			if (self.puedeMover(direccion)) {
				position = self.siguienteMovimientoHacia(direccion)
			}
			else {
				const objetoHacia = self.objetosHacia(direccion).find{objeto => not objeto.esAtravesable()}
				objetoHacia.reaccionarA(self)
				self.reaccionarA(objetoHacia)
			}
			self.actualizarImagen(false)
		}
	}
	
	method provocarMovimientoAleatorio() {
		const movimientosPosibles = [direccionArriba, direccionAbajo, direccionDerecha, direccionIzquierda]
		self.moverHacia(movimientosPosibles.anyOne())
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