import wollok.game.*
import utilidades.*
import personajes.*
import nivel2.*
import marcadores.*

class Pared {
	const property image = "piedra.png"
	const property position
	method esAtravesable() = false
	method reaccionarA(objeto) {}
	method esInteractivo() = false
}


object puertaVictoriosa { 
	var position = game.at(0,0)
	var property image = "pilchas.png" 
	
    method position() = position
	
	method esAtravesable() = true
	method reaccionarA(objeto) {
		if (objeto == utilidades.protagonista()) utilidades.nivel().terminar()
	}
	
	
	method configurate() {
		position = utilidades.posicionArbitrariaNoOcupada()
	    game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			if(not objeto.esAtravesable()) self.reaccionarA(objeto)
		})		
	}
}

object fogata {
	var position = game.at(0,0)
	var property image = "fogata.png"
	var tieneSarten = false
	var cantHuevos = 0
	method tieneSarten() = tieneSarten
	method ponerSarten() {
		tieneSarten = true
		image = "fogataConSarten.png"
	}
	
	method position() = position
	
	method ponerHuevo() {
		cantHuevos += 1
		image = "fogataHuevos_"+ cantHuevos + ".png"
	}
	
	method estaCompleta() = cantHuevos == 3
	
	method esInteractivo() = false
	method esAtravesable() = true
	method reaccionarA(objeto) {}
	method configurate() {
		image = "fogata.png"
		tieneSarten = false
		cantHuevos = 0
		position = utilidades.posicionArbitrariaNoOcupada()
		game.addVisual(self)
	}
}

class ObjetoMovible inherits Movimiento {
	
	override method configurate() {
		super()
		game.addVisual(self)
	}
	

	override method reaccionarA(objeto) {
		if (objeto == utilidades.protagonista()) {
			if (self.puedeMover(objeto.ultimoMovimiento())) {
				self.moverHacia(objeto.ultimoMovimiento())
				objeto.moverHacia(objeto.ultimoMovimiento())
			}
		}
	}
}

object sarten inherits ObjetoMovible(image = "sarten.png") {
	override method reaccionarA(objeto) {
		super(objeto)
		if (fogata.position() == position) {
			fogata.ponerSarten()
			game.removeVisual(self)
		}
	}
}

class Huevo inherits ObjetoMovible(image = "huevo.png") {
	override method reaccionarA(objeto) {
		super(objeto)
		if (fogata.position() == position and fogata.tieneSarten()) {
			fogata.ponerHuevo()
			game.removeVisual(self)
		}
	}
}

class Elemento {
	var position = game.at(0,0)

	method esAtravesable() = true
	method esInteractivo() = false
	
	method position() = position
	method configurate() {
		position = utilidades.posicionArbitrariaNoOcupada()
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			if(not objeto.esAtravesable()) self.reaccionarA(objeto)
		})
	}
	
	method reaccionarA(objeto) {}
}
class ElementoVitalidad inherits Elemento {
	const property image = "mate.png"
	var property salud
	
	override method reaccionarA(objeto) {
		if (objeto == utilidades.protagonista()) {
			const tomarmate = new Sound(file = "tomarmate.mp3")
			tomarmate.play()
			objeto.salud(objeto.salud()+ salud)
			game.removeVisual(self)
		}
	}
}

class ElementoEnergizante inherits Elemento {
	const property image = "red_bull.png"
	var property energia

	override method esAtravesable() = false
	override method esInteractivo() = true
	
	override method configurate() {
		position = utilidades.posicionArbitrariaNoOcupada()
		game.addVisual(self)
	}

	method interactuarCon(objeto) {
		if (objeto == utilidades.protagonista()) {
			const tomar = new Sound(file = "abrirlata.mp3")
			tomar.play()
			objeto.energia(objeto.energia()+ energia)
			marcadorFuerza.actualizar()
			game.removeVisual(self)
		}
	}
}

class ElementoEnriquecedor inherits Elemento {
	const property image = "bitcoin.png"
		
	override method reaccionarA(objeto) {
		if (objeto == utilidades.protagonista()) {
			const moneda = new Sound(file = "coin.mp3")
			moneda.play()
		    objeto.dinero(objeto.dinero() + 1)
		    marcadorBitcoin.actualizar()
		    game.removeVisual(self)
		}
	}
}


class ElementoSorpresa inherits Elemento {
	const property image = "medialuna.png"
	
	override method reaccionarA(objeto) {
	    const numeroRandom = 0.randomUpTo(66)
		if(objeto == utilidades.protagonista()) {
			var nuevoObjeto
			if ( numeroRandom.between(0 , 33) ) {
				nuevoObjeto = new ElementoVitalidad(salud = 25)
			}
			else {
				nuevoObjeto = new ElementoEnergizante(energia = 40)
			}
			
			nuevoObjeto.configurate()
			game.removeVisual(self)
		}
	}
}

class ElementoTransportador inherits Elemento {
	var property image = "agujero.png"
	var activado = true
	
	override method reaccionarA(objeto) {
		if (objeto == utilidades.protagonista()) {
			activado = false
			const posicion = utilidades.posicionArbitrariaNoOcupada()
			position = posicion
			objeto.position(posicion)
			objeto.actualizarImagen()
			game.schedule(500, {game.removeVisual(self)})
		}
	}
}

class ElementoAcumulable inherits Elemento {
	
	const property image = "chicken.png"
	
	override method reaccionarA(objeto) {
		if (objeto == utilidades.protagonista()) {
		objeto.agarrarItem(self)
		game.removeVisual(self)
		}
	}
}

class Coco inherits Movimiento(image = "coco.png") {
	
	var esAtravesable = true
	
	override method reaccionarA(objeto) {    		
		if (objeto == utilidades.protagonista()) {
			if (esAtravesable) {
				objeto.agarrarItem(self)
				game.removeVisual(self)
			}
		}
		else {
			if (not esAtravesable and game.hasVisual(self)) {
				const impacto = new Sound(file = "impactococo.mp3")
				game.removeVisual(objeto)
				self.moverHacia(ultimoMovimiento)
				image = "cocopum.png"
				impacto.play()
				game.schedule(150, { if (game.hasVisual(self)) game.removeVisual(self) })
			}
		}
		marcadorCoco.actualizar()
	}
	
	override method configurate() {
		super()
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			if(not objeto.esAtravesable()) self.reaccionarA(objeto)
		})
		
	}
	
	override method esAtravesable() = esAtravesable
	
	method lanzar () {
		const direccionPersonaje = neanthy.ultimoMovimiento()
		
		position = neanthy.position()
		esAtravesable = false
		game.addVisual(self)
		self.moverHacia(direccionPersonaje)
		var cantMov = 0
        game.onTick(150,"coco" , {
        	self.moverHacia(direccionPersonaje)
        	if(cantMov == 3) {
        		if (game.hasVisual(self)) {
        			game.removeVisual(self)
					game.removeTickEvent("coco")
        		}
        	}
        	cantMov += 1
        })
	}
}