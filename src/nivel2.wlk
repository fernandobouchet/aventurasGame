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
		game.addVisual(new Fondo(image="finNivel1.png"))
		game.schedule(2500, {
			game.clear()
			game.addVisual(new Fondo(image="cargandoNivel2.png"))
			game.schedule(3000, {
				game.clear()
				utilidadesParaJuego.nivel(nivelBitcoin)
				nivelBitcoin.configurate()
			})
		})})
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

