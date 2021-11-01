import wollok.game.*
import utilidades.*
import personajes.*

class Bloque {
	var property position
	const property image = "market.png" 
	method esAtravesable() = false
	method reaccionarA(objeto) {}
}

class CajaMovible inherits Movimiento {
	const property image = "chest.png" 
	method tipo() = "cajaMovible"
	override method reaccionarA(objeto) {
		if (objeto.tipo() == "protagonista") {
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
	var property position = utilidadesParaJuego.posicionArbitraria()
	
	method initialize() {
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			objeto.reaccionarA(self)
		})
	}
	
	method esAtravesable() = true
	method tipo() = "ElementoVitalidad"
	method reaccionarA(objeto) {}
}

class ElementoEnergizante {
	const property image = "beer.png"
	var property energia
	var property position = utilidadesParaJuego.posicionArbitraria()
	
	method initialize() {
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			objeto.reaccionarA(self)
		})
	}
	method esAtravesable() = true
	method tipo() = "ElementoEnergizante"
	method reaccionarA(objeto) {}
}

class ElementoEnriquecedor {
	const property image = "buck.png"
	var property dinero
	var property position = utilidadesParaJuego.posicionArbitraria()
	
	method initialize() {
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			objeto.reaccionarA(self)
		})
	}
	
	method esAtravesable() = true
	method tipo() = "ElementoEnriquecedor"
	method reaccionarA(objeto) {}
}


class ElementoSorpresa {
	const property image = "random.png"
	var property position = utilidadesParaJuego.posicionArbitraria()
	
	method initialize() {
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			self.reaccionarA(objeto)
		})
	}
	
	method esAtravesable() = true
	method tipo() = "ElementoSorpresa"
	method reaccionarA(objeto) {
		const numeroRandom = 0.randomUpTo(100)
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

class ElementoTransportador {
	const property image = "stars.png"
	var property position = utilidadesParaJuego.posicionArbitraria()
	
	method initialize() {
		game.addVisual(self)
		game.onCollideDo(self, {
			objeto =>
			objeto.reaccionarA(self)
		})
	}
	
	method esAtravesable() = true
	method tipo() = "ElementoTransportador"
	method reaccionarA(objeto) {
	}
}