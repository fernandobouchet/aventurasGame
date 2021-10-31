import wollok.game.*
import utilidades.*
import personajes.*

class Bloque {
	var property position
	const property image = "market.png" 
	method esAtravesable() = false
	method reaccionarA(objeto) {}
}

class CajaMovible inherits Movimiento(position = utilidadesParaJuego.posicionArbitraria()) {
	const property image = "enemigoVivo.png" 
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
	const property image = "bomba.png"
	var property salud
	var property position = utilidadesParaJuego.posicionArbitraria()
	
	method esAtravesable() = true
	method tipo() = "ElementoVitalidad"
	method reaccionarA(objeto) {}
}

class ElementoEnergizante {
	const property image = "bomba.png"
	var property energia
	var property position = utilidadesParaJuego.posicionArbitraria()
	
	method esAtravesable() = true
	method tipo() = "ElementoEnergizante"
	method reaccionarA(objeto) {}
}

class ElementoEnriquecedor {
	const property image = "bomba.png"
	var property dinero
	var property position = utilidadesParaJuego.posicionArbitraria()
	
	method esAtravesable() = true
	method tipo() = "ElementoEnriquecedor"
	method reaccionarA(objeto) {}
}
