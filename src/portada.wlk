import wollok.game.*
import fondo.*
import nivel1.*

object portada {
	method configurate() {
		game.addVisual(new Fondo(image="portada.png"))
		keyboard.i().onPressDo{ game.addVisual(new Fondo(image="instrucciones.png"))}
		keyboard.enter().onPressDo{ self.comenzarJuego()}
	}
	
	method comenzarJuego() {
		game.clear()
		nivelBloques.configurate()
	}
}