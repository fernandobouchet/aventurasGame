import wollok.game.*
import utilidades.*
import accesorios.*
import nivel2.*
import marcadores.*
import nivel1.*

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
		if (utilidades.nivel() == nivelCocos) cocos.add(item) else inventario.add(item)
	}

	method tiene(item) = inventario.contains(item)

	method objetoInteractivoHacia() {
		return self.objetosHacia(ultimoMovimiento).find({ obj => not obj.esAtravesable() and obj.esInteractivo() })
	}

	method recibirAtaque(danio) {
		esAtacado = true
		const recibirgolpe = new Sound(file = "recibirgolpe.mp3")
		recibirgolpe.play()
		salud -= danio
		marcadorSalud.actualizar()
		self.actualizarImagen()
		game.schedule(100, { esAtacado = false
		; self.actualizarImagen()
		})
	}

	method cansarse(cantidad) {
		energia -= cantidad
		marcadorFuerza.actualizar()
	}

	method hayObjetoInteractivo() {
		return self.objetosHacia(ultimoMovimiento).any({ obj => not obj.esAtravesable() and obj.esInteractivo() })
	}

	method tirarCoco() {
		if (not cocos.isEmpty()) {
			const coco = cocos.first()
			cocos.remove(coco)
			coco.lanzar()
		}
	}

	override method actualizarImagen() {
		pelo.actualizar()
		reloj.actualizar()
		anteojos.actualizar()
		image = ultimoMovimiento.imagenProtagonista()
	}

	override method reaccionarA(obstaculo) {
	}

	override method configurate() {
		super()
		if (utilidades.nivel() == nivelHuevos) inventario = []
		energia = 30
		salud = 50
		dinero = 0
		game.addVisual(self)
		game.addVisual(pelo)
		self.actualizarImagen()
		keyboard.up().onPressDo({ self.ejecutarMovimiento(direccionArriba)})
		keyboard.down().onPressDo({ self.ejecutarMovimiento(direccionAbajo)})
		keyboard.left().onPressDo({ self.ejecutarMovimiento(direccionIzquierda)})
		keyboard.right().onPressDo({ self.ejecutarMovimiento(direccionDerecha)})
		keyboard.space().onPressDo{ if (self.hayObjetoInteractivo()) self.objetoInteractivoHacia().interactuarCon(self)
		}
	}

	method ejecutarMovimiento(direccion) {
		enMovimiento = true
		self.actualizarImagen()
		game.schedule(100, { if (not utilidades.nivel().juegoEnPausa()) {
				self.moverHacia(direccion)
				self.cansarse(1)
			}
		})
	}

}

class EnemigoComun inherits Movimiento(image = "dino-izq.png") {

	override method actualizarImagen() {
		image = ultimoMovimiento.imagenDino()
	}
		
	override method reaccionarA(objeto) {
		if (objeto == utilidades.protagonista()) objeto.recibirAtaque(10)
	}

	override method configurate() {
		super()
		game.addVisual(self)
		self.moverEnemigo()
	}

	method moverEnemigo() {
		if (game.hasVisual(self)) {
			self.provocarMovimientoAleatorio()
			game.schedule(1000, { self.moverEnemigo()})
		}
	}

}

class EnemigoSeguidor inherits EnemigoComun(image = "dino-rex-izq.png") {

	override method actualizarImagen() {
		image = ultimoMovimiento.imagenDinoRex()
	}

	override method reaccionarA(objeto) {
		if (objeto == utilidades.protagonista()) objeto.recibirAtaque(20)
	}

	override method moverEnemigo() {
		if (game.hasVisual(self)) {
			self.moverUnPasoHacia(neanthy)
			game.schedule(1000, { self.moverEnemigo()})
		}
	}

}

