import wollok.game.*
import fondo.*
import personajes.*
import marcadores.*
import accesorios.*
import elementos.*
import nivelbase.*
import nivel2.*
import utilidades.*

object nivelCocos inherits Nivel {
	var cantidadDeCocos = 10
	
	method crearCoco() {
		const cocos = new Coco()
		
		if (cantidadDeCocos != 0) {
			cocos.configurate()
		    cantidadDeCocos  -= 1
		    game.schedule(1000, {self.crearCoco()})
		}	
	}
	
	override method configurate() {
		super()
		cantidadDeCocos = 10
		self.crearCoco()		
		marcadorCoco.actualizar()
	}
	
	override method estadoJuego() {
		if(neanthy.dinero() == 10 and not game.hasVisual(puertaVictoriosa)) puertaVictoriosa.configurate()
	}
	
	override method terminar() {
		juegoEnPausa = true
		game.schedule(2000,{
		game.clear()
		game.addVisual(new Fondo(image="finNivel1.png"))
		game.schedule(2500, {
			game.clear()
			game.addVisual(new Fondo(image="cargandoNivel2.png"))
			game.schedule(3000, {
				game.clear()
				utilidadesParaJuego.nivel(nivelHuevos)
				nivelHuevos.configurate()			
			})
		})})
	}
	
	override method cargarPersonajesYObjetos(){
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
}

