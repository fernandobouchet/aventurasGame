import wollok.game.*
import utilidades.*
import personajes.*
import nivel1.*

object deposito {
	var property position = utilidadesParaJuego.posicionArbitraria()
	const property image = "market.png" 
	method esInteractivo() = false
	method esAtravesable() = true
	method reaccionarA(objeto) {}
	method configurate() {
		game.addVisual(self)
	}
}

class ObjetoMovible inherits Movimiento {
	const property image
	
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
		if (deposito.position() == position) {
			nivelBloques.agregarItem(objeto)
			game.removeVisual(self)
			game.schedule(500,{if(nivelBloques.inventario().size() == 2)
			nivelBloques.terminar()})
		}
	}
}

class CajaMovible inherits ObjetoMovible(image = "chest.png") {}
class LlavePesada inherits ObjetoMovible(image = "pizza.png") {}

class ElementoVitalidad {
	const property image = "burger.png"
	var property salud
	var property position = game.at(0,0)
	
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
	var property position = utilidadesParaJuego.posicionArbitraria()
	method esInteractivo() = true
	
	method configurate() {
		position = utilidadesParaJuego.posicionArbitrariaNoOcupada()
		game.addVisual(self)
	}
	method esAtravesable() = false

	method reaccionarA(objeto) {
	}
	method interactuarCon(objeto) {
		if (objeto == utilidadesParaJuego.protagonista()) {
			objeto.energia(objeto.energia()+ energia)
			marcadorFuerza.actualizar()
			game.removeVisual(self)
		}
	}
}

class ElementoEnriquecedor {
	const property image = "buck.png"
	var property dinero
	var property position = utilidadesParaJuego.posicionArbitraria()
	method esInteractivo() = false
	
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
	var property position = utilidadesParaJuego.posicionArbitraria()
	method esInteractivo() = false
	
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
	var property image = "stars.png"
	const animacionEstrella = new Animacion(imagenes = ["estrellas1.png","estrellas2.png","estrellas3.png","estrellas4.png","estrellas3.png","estrellas2.png"], duracion = 500)
	var property position = utilidadesParaJuego.posicionArbitraria()
	
	method configurate() {
		position = utilidadesParaJuego.posicionArbitrariaNoOcupada()
		animacionEstrella.repetir()
		animacionEstrella.animar(self)
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			if(not objeto.esAtravesable()) self.reaccionarA(objeto)
		})
	}
	
	method esAtravesable() = true
	method reaccionarA(objeto) {
		if (objeto == utilidadesParaJuego.protagonista()) {
			objeto.position(utilidadesParaJuego.posicionArbitraria())
			animacionEstrella.repetir(false)
			game.removeVisual(self)
		}
	}
}

class ElementoAcumulable {
	const property image = "chicken.png"
	var property position = utilidadesParaJuego.posicionArbitraria()
	
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