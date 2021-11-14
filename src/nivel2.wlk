import wollok.game.*
import fondo.*
import personajes.*
import marcadores.*
import accesorios.*
import elementos.*
import nivelbase.*
import nivel3.*
import utilidades.*

object nivelHuevos inherits Nivel {

	override method estadoJuego() {
		if(fogata.estaCompleta() and
		neanthy.inventario().size() == 3) self.terminar()
	}
	
	override method terminar() {
		juegoEnPausa = true
		game.schedule(2000,{
		game.clear()
		game.addVisual(new Fondo(image="finNivel2.png"))
		game.schedule(2500, {
			game.clear()
			game.addVisual(new Fondo(image="cargandoNivel3.png"))
			game.schedule(3000, {
				game.clear()
				utilidadesParaJuego.nivel(nivelBitcoin)
				nivelBitcoin.configurate()
			})
		})})
	}
	
	override method configurate() {
		super()
		//const fondosemioscuro = new Fondo(image = "mediasombra.png")
		//game.addVisual(fondosemioscuro)
		const ruidofogata = new Sound(file = "fuegonivel2.mp3")
		ruidofogata.shouldLoop(true)
		ruidofogata.play()
		barraMarcador.image("marcadorNivel2.png")
	}
	
	override method cargarPersonajesYObjetos(){
		const dinoRex = new EnemigoSeguidor();
		const dino = new EnemigoComun();
		const elementoVit1 = new ElementoVitalidad(salud = 50)
		const elementoSorp1 = new ElementoSorpresa()
		const elementoTran1 = new ElementoTransportador()
		const huevo1 = new Huevo()
		const huevo2 = new Huevo()
		const huevo3 = new Huevo()
	
		const elementosNivel = [
			elementoTran1,
			fogata,
			sarten,
			huevo1,
			huevo2,
			huevo3,
			peine,
			reloj,
			anteojos,
			elementoVit1,
			elementoSorp1,
			dinoRex,
			dino,
			neanthy
		]
		
		elementosNivel.forEach{ obj => obj.configurate()}
	}
}

