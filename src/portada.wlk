import wollok.game.*
import fondo.*
import nivel1.*

object portada {
	method configurate() {
		game.addVisual(new Fondo(image="portada.png"))
		//game.schedule(1000, {game.addVisual(new Fondo(image="neanthy-game-over.png"))
		//})
		keyboard.enter().onPressDo{ self.comenzarJuego()}
	}
	
	method comenzarJuego() {
		game.clear()
		nivelBloques.configurate()
	}
}