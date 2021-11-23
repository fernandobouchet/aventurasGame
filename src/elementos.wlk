import wollok.game.*
import utilidades.*
import personajes.*
import nivel2.*
import marcadores.*

class Pared inherits ElementoBase {
	const property image = "piedra.png"
	const property position
	override method esAtravesable() = false
}

object puertaVictoriosa inherits ElementoBase { 
	var position = game.at(0,0)
	var property image = "pilchas.png" 
	
    method position() = position
	
	override method reaccionarA(objeto) {
		if (objeto == utilidades.protagonista()) {
			const sonidoPuerta = new Sound(file = "puerta.mp3")
			sonidoPuerta.play()
			utilidades.nivel().terminar()
		}
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

object fogata inherits ElementoBase {
	var position = game.at(0,0)
	var property image = "fogata.png"
	var tieneSarten = false
	var property cantHuevos = 0
	
	method tieneSarten() = tieneSarten
	
	method ponerSarten() {
		const sarten = new Sound(file = "sarten.mp3")
		sarten.play()
		tieneSarten = true
		image = "fogataConSarten.png"
	}
	
	method position() = position
	
	method ponerHuevo() {
		cantHuevos += 1
		image = "fogataHuevos_"+ cantHuevos + ".png"
	}
	
	method estaCompleta() = cantHuevos == 3
	
	method configurate() {
		image = "fogata.png"
		tieneSarten = false
		cantHuevos = 0
		position = utilidades.posicionArbitrariaNoOcupada()
		game.addVisual(self)
	}
}

class ObjetoMovible inherits Movimiento {

	override method esAtravesable() = false
	
	override method configurate() {
		super()
		game.addVisual(self)
	}

	override method reaccionarA(objeto) {
		objeto.empujar(self)
	}
}

object sarten inherits ObjetoMovible(image = "sarten.png") {
	override method reaccionarA(objeto) {
		super(objeto)
		if (fogata.position() == position) {
			const sonidoSarten = new Sound(file = "sarten.mp3")
			sonidoSarten.play()
			fogata.ponerSarten()
			game.removeVisual(self)
		}
	}
}

class Huevo inherits ObjetoMovible(image = "huevo.png") {
	override method reaccionarA(objeto) {
		super(objeto)
		if (fogata.position() == position and fogata.tieneSarten()) {
			const sonidoHuevo = new Sound(file = "huevo.mp3")
			sonidoHuevo.play()
			fogata.ponerHuevo()
			game.removeVisual(self)
		}
	}
}

class Elemento inherits ElementoBase {
	var position = game.at(0,0)
	
	method position() = position
	method configurate() {
		position = utilidades.posicionArbitrariaNoOcupada()
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			if(not objeto.esAtravesable()) self.reaccionarA(objeto)
		})
	}
	
	override method reaccionarA(objeto) {
		objeto.accionarEfecto(self)
	}
}

class ElementoVitalidad inherits Elemento {
	const property image = "mate.png"
	var property salud
	
	override method accionarEfecto(objeto) {
		const tomarmate = new Sound(file = "tomarmate.mp3")
		tomarmate.play()
		objeto.salud(objeto.salud()+ salud)
		game.removeVisual(self)
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
		const tomar = new Sound(file = "abrirlata.mp3")
		tomar.play()
		objeto.energia(objeto.energia()+ energia)
		game.removeVisual(self)
	}
}

class ElementoEnriquecedor inherits Elemento {
	const property image = "bitcoin.png"

	override method accionarEfecto(objeto) {
		const moneda = new Sound(file = "coin.mp3")
		moneda.play()
		objeto.dinero(objeto.dinero() + 1)
		game.removeVisual(self)
	}
}


class ElementoSorpresa inherits Elemento {
	const property image = "medialuna.png"

	override method accionarEfecto(objeto) {
	    const numeroRandom = 0.randomUpTo(66)
		var nuevoObjeto
		const medialuna = new Sound(file = "comer.mp3")
		medialuna.play()
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

class ElementoTransportador inherits Elemento {
	var property image = "agujero.png"
	var activado = true

	override method accionarEfecto(objeto) {
		if (activado) {
			const agujero = new Sound(file = "teletransporta.mp3")
			agujero.play()
			activado = false
			const posicion = utilidades.posicionArbitrariaNoOcupada()
			position = posicion
			objeto.position(posicion)
			objeto.actualizarImagen()
			game.schedule(500, {game.removeVisual(self)})
		}
	}
}

class Coco inherits Movimiento(image = "coco.png") {
	
	var esAtravesable = true
	
	var esProyectil = false
	
	method atacar(objeto) {
		if (not objeto.esAtravesable()) {
			const impacto = new Sound(file = "impactococo.mp3")
			esAtravesable = false
			objeto.recibirAtaque(0)
			position = objeto.position()
			image = "cocopum.png"
			impacto.play()
			game.schedule(150, { if (game.hasVisual(self)) game.removeVisual(self) })
		}
	}
	
	override method reaccionarA(objeto) {
		if (esAtravesable) {
			if(esProyectil) { self.atacar(objeto) }
			else { objeto.agarrar(self) }
		}
	}
	
	override method configurate() {
		super()
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
				self.reaccionarA(objeto)
		})
	}
	
	override method esAtravesable() = esAtravesable
	
	method distanciaLanzamientoCoco(direccion, veces) {
		if(esAtravesable and game.hasVisual(self)) {
			if (veces > 0) {
				self.moverHacia(direccion)
				game.schedule(150, {self.distanciaLanzamientoCoco(direccion, veces - 1)})
			}
			else {
				game.removeVisual(self)
			}
		}
	}
	
	method lanzar () {
		const direccionPersonaje = utilidades.protagonista().ultimoMovimiento()
		esProyectil = true
		position = utilidades.protagonista().position()
		game.addVisual(self)
		self.distanciaLanzamientoCoco(direccionPersonaje, 3)
	}
}