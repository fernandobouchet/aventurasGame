import wollok.game.*
import fondo.*
import personajes.*
import marcadores.*
import accesorios.*
import elementos.*
import utilidades.*


object nivelBonus {
	
	var property juegoEnPausa = false
	var property cantElementosEnergizantes = 0
	
	//cambiar todo enriquecedor por cocos
	var cantidadDeCocos = 10
	
	method crearCoco() {
		const cocos = new Coco()
		
		if (cantidadDeCocos != 0) {
			cocos.configurate()
		    cantidadDeCocos  -= 1
		    game.schedule(1000, {self.crearCoco()})
		}
		
	}
	
	method crearElementoEnergizante() {
		var elementoEnergizante = new ElementoEnergizante(energia = 30)
		if(0.randomUpTo(100) > 90) elementoEnergizante = new ElementoEnergizante(energia = -20)
		if (cantElementosEnergizantes == 0) {
			elementoEnergizante.configurate()
			cantElementosEnergizantes += 1
		}
		
	}
	
	method restart() {
		game.clear()
		self.configurate()
	}
	
	method perder() {
		game.clear()
		game.addVisual(new Fondo(image="neanthy-game-over.png"))
		game.schedule(2500, {
			game.addVisual(new Fondo(image="neanthy-creditos.png"))
			})
		keyboard.r().onPressDo{ self.restart()}
	}

	method configurate() {
		cantElementosEnergizantes = 0
		cantidadDeCocos = 10
		
		game.addVisual(new Fondo(image="neanthy-bgn.png"))
		game.addVisual(barraMarcador)
		neanthy.esAtacado(false)
		self.cargarPersonajesYObjetos()
		self.crearCoco()
		self.generarParedesInvisibles()
		

		marcadorFuerza.actualizar()
		marcadorSalud.actualizar()
		marcadorCoco.actualizar()
		game.onTick(4000, "elementosEnergizantes", { self.crearElementoEnergizante() })
		game.onTick(50, "perder", {if (neanthy.energia() <= 0 or neanthy.salud() <= 0) self.perder()})
		keyboard.space().onPressDo({ neanthy.tirarCoco() })
		keyboard.t().onPressDo({ self.terminar() })
		keyboard.r().onPressDo{ self.restart()}
		keyboard.p().onPressDo{ juegoEnPausa = !juegoEnPausa }
		game.onTick(50, "estado juego",{self.estadoJuego()})
	}
	
	method estadoJuego() {
		if(neanthy.dinero() == 10 and not game.hasVisual(puertaVictoriosa)) puertaVictoriosa.configurate()
	}
	
	method terminar() {
		juegoEnPausa = true
		game.schedule(2000,{
		game.clear()
		game.addVisual(new Fondo(image="finNivel1.png"))
		game.schedule(2500, {
			game.clear()
			game.addVisual(new Fondo(image="cargandoNivel2.png"))
			game.schedule(3000, {
				game.clear()
			})
		})})
	}
	
	method cargarPersonajesYObjetos(){
		const dinoRex = new EnemigoSeguidor();
		const dino = new EnemigoComun();
		const dino2 = new EnemigoComun();
		const elementoVit1 = new ElementoVitalidad(salud = 50)
		const elementoSorp1 = new ElementoSorpresa()
		const elementoTransportador1 = new ElementoTransportador()
		
		const elementosNivel = [
			elementoTransportador1,
			elementoVit1,
			elementoSorp1,
			dinoRex,
			dino,
			dino2,
			neanthy
			]
			
		elementosNivel.forEach{ obj => obj.configurate()}
	}
	
	method generarParedesInvisibles() {
		self.generarParedInvisibleEnX(1, 4, 0)
		self.generarParedInvisibleEnX(7, game.width() - 2, 0)
		self.generarParedInvisibleEnX(1, 4, game.height() - 2)
		self.generarParedInvisibleEnX(7, 10, game.height() - 2)
		self.generarParedInvisibleEnY(0, 1, 3)
		self.generarParedInvisibleEnY(0, 7, game.height() - 3)
		self.generarParedInvisibleEnY(game.width() - 1, 1, 3)
		self.generarParedInvisibleEnY(game.width() - 1, 7, game.height() - 3)
	}
	
	method generarParedInvisibleEnX(desdeX, hastaX, y) {
		const pared = []
		pared.add(new Pared(position = game.at(desdeX, y)))
		(hastaX - desdeX).times{ x =>
			pared.add(new Pared(position = game.at(desdeX + x, y)))
		}
		pared.forEach{ p => game.addVisual(p) }
	}

	method generarParedInvisibleEnY(x, desdeY, hastaY) {
		const pared = []
		pared.add(new Pared(position = game.at(x, desdeY)))
		(hastaY - desdeY).times{ y =>
			pared.add(new Pared(position = game.at(x, desdeY + y)))
		}
		pared.forEach{ p => game.addVisual(p) }
	}
}

