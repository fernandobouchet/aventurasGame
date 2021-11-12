import wollok.game.*
import utilidades.*
import personajes.*
import nivel1.*
import marcadores.*

class Pared {
	const property image = "piedra.png"
	const property position
	method esAtravesable() = false
	method reaccionarA(objeto) {}
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
	
	method esInteractivo() = false
	method esAtravesable() = true
	method reaccionarA(objeto) {}
	method configurate() {
		tieneSarten = false
		cantHuevos = 0
		position = utilidadesParaJuego.posicionArbitrariaNoOcupada()
		game.addVisual(self)
	}
}

class ObjetoMovible inherits Movimiento {
	
	override method configurate() {
		super()
		game.addVisual(self)
	}
	

	override method reaccionarA(objeto) {
		if (objeto == utilidadesParaJuego.protagonista()) {
			if (self.puedeMover(objeto.ultimoMovimiento())) {
				self.moverHacia(objeto.ultimoMovimiento())
				objeto.moverHacia(objeto.ultimoMovimiento())
			}
		}
		if (fogata.position() == position) {
			nivelBloques.agregarItem(objeto)
			game.removeVisual(self)
			game.schedule(500,{if(nivelBloques.inventario().size() == 4)
			nivelBloques.terminar()})
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

class ElementoVitalidad {
	const property image = "burger.png"
	var property salud
	var position = game.at(0,0)
	
	method position() = position
	method configurate() {
		position = utilidadesParaJuego.posicionArbitrariaNoOcupada()
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			if(not objeto.esAtravesable()) self.reaccionarA(objeto)
		})
	}
	
	method esAtravesable() = true
	method esInteractivo() = false
	
	method reaccionarA(objeto) {
		if (objeto == utilidadesParaJuego.protagonista()) {
			objeto.salud(objeto.salud()+ salud)
			game.removeVisual(self)
		}
	}
}

class ElementoEnergizante {
	const property image = "beer.png"
	var property energia
	var position = game.at(0,0)
	
	method esInteractivo() = true
	
	method position() = position
	method configurate() {
		position = utilidadesParaJuego.posicionArbitrariaNoOcupada()
		game.addVisual(self)
	}
	method esAtravesable() = false

	method reaccionarA(objeto) {
	}
	method interactuarCon(objeto) {
		if (objeto == utilidadesParaJuego.protagonista()) {
			nivelBloques.cantElementosEnergizantes(nivelBloques.cantElementosEnergizantes() - 1)
			objeto.energia(objeto.energia()+ energia)
			marcadorFuerza.actualizar()
			game.removeVisual(self)
		}
	}
}

class ElementoEnriquecedor {
	const property image = "buck.png"
	var property dinero
	var position = game.at(0,0)
	
	method esInteractivo() = false
	method position() = position
	method configurate() {
		position = utilidadesParaJuego.posicionArbitrariaNoOcupada()
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			if(not objeto.esAtravesable()) self.reaccionarA(objeto)
		})
	}
	
	method esAtravesable() = true
	method reaccionarA(objeto) {
		if (objeto == utilidadesParaJuego.protagonista()) {
			objeto.dinero(objeto.dinero() + dinero)
			game.removeVisual(self)
		}
	}
}


class ElementoSorpresa {
	const property image = "random.png"
	var position = game.at(0,0)
	
	method esInteractivo() = false
	method position() = position
	method configurate() {
		position = utilidadesParaJuego.posicionArbitrariaNoOcupada()
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			if(not objeto.esAtravesable()) self.reaccionarA(objeto)
		})
	}
	
	method esAtravesable() = true
	method reaccionarA(objeto) {
		var numeroRandom = 0.randomUpTo(100)
		if (utilidadesParaJuego.nivel() == 1) numeroRandom = 0.randomUpTo(66)
		if(objeto == utilidadesParaJuego.protagonista()) {
			var nuevoObjeto
			if ( numeroRandom.between(0 , 33) ) {
				nuevoObjeto = new ElementoVitalidad(salud = 25)
			}
			else if (numeroRandom.between(33 , 66)) {
				nuevoObjeto = new ElementoEnergizante(energia = 40)
			}
			else {
				nuevoObjeto = new ElementoEnriquecedor(dinero = 200)
			}
			nuevoObjeto.configurate()
			game.removeVisual(self)
		}
	}
}

class ElementoTransportador {
	var property image = "agujero.png"
	var activado = true
	var position = game.at(0,0)
	
	method position() = position
	method configurate() {
		position = utilidadesParaJuego.posicionArbitrariaNoOcupada()
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			if(not objeto.esAtravesable() and activado) self.reaccionarA(objeto)
		})
	}
	
	method esAtravesable() = true
	method reaccionarA(objeto) {
		if (objeto == utilidadesParaJuego.protagonista()) {
			activado = false
			const posicion = utilidadesParaJuego.posicionArbitrariaNoOcupada()
			position = posicion
			objeto.position(posicion)
			objeto.actualizarImagen(false)
			game.schedule(500, {game.removeVisual(self)})
		}
	}
}

class ElementoAcumulable {
	const property image = "chicken.png"
	var position = game.at(0,0)
	
	method position() = position
	method configurate() {
		position = utilidadesParaJuego.posicionArbitrariaNoOcupada()
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			if(not objeto.esAtravesable()) self.reaccionarA(objeto)
		})
	}
	
	method esAtravesable() = true
	method reaccionarA(objeto) {
		if (objeto == utilidadesParaJuego.protagonista()) {
			objeto.agarrarItem(self)
			game.removeVisual(self)
		}
	}
}