import wollok.game.*
import utilidades.*
import personajes.*

class Bloque {
	var property position
	const property image = "market.png" 
	method esAtravesable() = false
	method reaccionarA(objeto) {}
	method configurate() {
		game.addVisual(self)
	}
}

class CajaMovible inherits Movimiento {
	const property image = "chest.png" 
	
	override method esAtravesable() {
		if (caja esta en la celda tal) return true
	}
	
	override method configurate() {
		super()
		game.addVisual(self)
	}

	override method reaccionarA(objeto) {
		if (objeto.esProtagonista()) {
			if (self.puedeMover(objeto.ultimoMovimiento())) {
				self.moverHacia(objeto.ultimoMovimiento())
				objeto.moverHacia(objeto.ultimoMovimiento())
			}
		}
	}
}



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
	method reaccionarA(objeto) {
		if (objeto.esProtagonista()) {
			objeto.salud(objeto.salud()+ salud)
			game.removeVisual(self)
		}
	}
}

class ElementoEnergizante {
	const property image = "beer.png"
	var property energia
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
		if (objeto.esProtagonista()) {
			objeto.energia(objeto.energia()+ energia)
			game.removeVisual(self)
		}
	}
}

class ElementoEnriquecedor {
	const property image = "buck.png"
	var property dinero
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
		if (objeto.esProtagonista()) {
			objeto.dinero(objeto.dinero() + dinero)
			game.removeVisual(self)
		}
	}
}


class ElementoSorpresa {
	const property image = "random.png"
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
		const numeroRandom = 0.randomUpTo(100)
		if(objeto.esProtagonista()) {
			if ( numeroRandom.between(0 , 33) ) {
				const vitalidad =	new ElementoVitalidad(salud = 5220)
			}
			else if (numeroRandom.between(33 , 66)) {
				const energizante =	new ElementoEnergizante(energia = 5220)
			}
			else {
				const enriquecedor = new ElementoEnriquecedor(dinero = 5220)
			}
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
		if (objeto.esProtagonista()) {
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
		if (objeto.esProtagonista()) {
			objeto.agarrarItem(self)
			game.removeVisual(self)
		}
	}
}