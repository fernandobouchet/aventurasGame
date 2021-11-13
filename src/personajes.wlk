import wollok.game.*
import utilidades.*
import accesorios.*
import nivel1.*
import marcadores.*
import nivel3.*

// en la implementación real, conviene tener un personaje por nivel
// los personajes probablemente tengan un comportamiendo más complejo que solamente
// imagen y posición

object neanthy inherits Movimiento(image = "neanthy_der.png") {
	var property energia = 0
	var property salud = 0
	var property dinero = 0
	var property esAtacado = false
	const property cocos = [] 
	
	var inventario = []
	
	
	method inventario() = inventario
	
	method agarrarItem(item) {
		if (utilidadesParaJuego.nivel() == nivelBonus) { 
		cocos.add(item)}
	    else {
	    inventario.add(item)
		}
	}

	method tiene(item) = inventario.contains(item)
	
	method objetoInteractivoHacia() {
		return self.objetosHacia(ultimoMovimiento).find({ obj => not obj.esAtravesable() and obj.esInteractivo()})
	}
	
	method recibirAtaque(danio) {
		esAtacado = true
		salud -= danio
		marcadorSalud.actualizar()
		self.actualizarImagen(false)
		game.schedule(100, { esAtacado = false; self.actualizarImagen(false) })
	}
	
	method cansarse(cantidad) {
		energia -= cantidad
		marcadorFuerza.actualizar()
	}
	
	method hayObjetoInteractivo() {
		return self.objetosHacia(ultimoMovimiento).any({ obj => not obj.esAtravesable() and obj.esInteractivo()})
	}
	
	method tirarCoco(coco) { 
		
	}
	
	
	override method actualizarImagen(movimiento) {
		pelo.actualizar(ultimoMovimiento)
		reloj.actualizar(ultimoMovimiento, movimiento)
		anteojos.actualizar(ultimoMovimiento)
		image = ultimoMovimiento.imagenProtagonista(movimiento)
	}
	
	override method reaccionarA(obstaculo) {}
	override method configurate() {
		super()
		if (utilidadesParaJuego.nivel() == nivelBloques) {
			inventario = []
		}
		energia = 30
		salud = 100
		dinero = 0
		game.addVisual(self)
		game.addVisual(pelo)
		self.actualizarImagen(false)
		keyboard.up().onPressDo({self.ejecutarMovimiento(direccionArriba) })
		keyboard.down().onPressDo({ self.ejecutarMovimiento(direccionAbajo) })
		keyboard.left().onPressDo({ self.ejecutarMovimiento(direccionIzquierda) })
		keyboard.right().onPressDo({ self.ejecutarMovimiento(direccionDerecha) })
		keyboard.space().onPressDo{if (self.hayObjetoInteractivo()) self.objetoInteractivoHacia().interactuarCon(self)}
	}
	
	method ejecutarMovimiento(direccion) {
		self.actualizarImagen(true)
		game.schedule(100,{
			self.moverHacia(direccion)
			self.cansarse(1)
		})
	}
}



class EnemigoComun inherits Movimiento(image = "dino-izq.png") {

	override method actualizarImagen(movimiento) {
		image = ultimoMovimiento.imagenDino()
	}

	override method reaccionarA(objeto) {
		if (objeto == utilidadesParaJuego.protagonista()) objeto.recibirAtaque(5)
	}
	override method configurate() {
		super()
		game.addVisual(self)
		game.onTick(1000, "enemigoComun", {self.provocarMovimientoAleatorio()})
	}
}

class EnemigoSeguidor inherits Movimiento(image = "dino-rex-izq.png") {
	
	override method actualizarImagen(movimiento) {
		image = ultimoMovimiento.imagenDinoRex()
	}
	
	override method reaccionarA(objeto) {
		if (objeto == utilidadesParaJuego.protagonista()) objeto.recibirAtaque(5)
	}
	override method configurate() {
		super()
		game.addVisual(self)
		game.onTick(1000, "enemigoSeguidor", {self.moverUnPasoHacia(neanthy)})
	}
}
