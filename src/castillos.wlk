class Castillo {
	const property burocratas = []
	const property guardias = []
	var property estabilidad = 0
	var murallaExterior=100
	const property ambientes = []
	method construirAmbiente(ambiente) {
		ambientes.add(ambiente)   //crear ambiente antes del metodo por consola
	}
	method incapacesDePelear() {
		return ambientes.any{ambiente => ambiente.guardias().any{guardia => guardia.agotamiento() == 5}}
	}
	method entrenarGuardias(cantidad) {
		(cantidad).times{x => guardias.add(new Guardia())}
	}
	method asignarGuardiasA(ambiente, cantidad) {
		(cantidad.min(guardias.size())).times{x => ambientes.get(ambiente).guardias().add(new Guardia())}
		(cantidad.min(guardias.size())).times{x => guardias.remove(guardias.first())}
	}
	method designarBurocrata( nombre) {
		burocratas.add(nombre)
	}
	method estabilidadCastillo() {
		estabilidad = ambientes.map{x => x.estabilidad()}.sum() + murallaExterior
	}
	method capacidadTotalGuardias() {
		return ambientes.map{z => z.guardias().sum{x => x.capacidad()}}.sum()
	}
	method prepararDefensas() {
		estabilidad = (estabilidad + self.capacidadTotalGuardias()) * (1 + burocratas.filter{x => x.noTieneMiedo()}.map{y => y.planificarDefensa()}.sum())
		return estabilidad
	}
	method recibirAtaqueDe(castilloAtacante) {
		self.prepararDefensas()
		burocratas.filter{x => x.tieneMiedo()}.forEach{y => y.miedo(true)} 
		ambientes.forEach{x => x.guardias().forEach {y => y.combatir()}}
		estabilidad = estabilidad - castilloAtacante.capacidadTotalGuardias()
		castilloAtacante.ambientes().forEach{x => x.guardias().forEach {y => y.combatir()}}
		if (estabilidad < 100) {
			todocastillos.sacarCastillo(self)
		}
		else {
			guardias.removeAll(guardias.filter{x => x.noPuedePelear()})
			castilloAtacante.guardias().removeAll(guardias.filter{x => x.noPuedePelear()})
		}
	}
	method construirAlmenas() {
		murallaExterior = (murallaExterior + 25).min(175)
	}
	method construirTorreon() {
		murallaExterior = (murallaExterior + 5).min(175)
	}
	method murallaDestruida() {
		murallaExterior = 100
	}
}

/*class Muralla {
	var tamanio = pequenio
	var material = madera
	var property estabilidad = 30
	const property guardias = []
	method reparar() {
		estabilidad = (estabilidad + guardias.size() * 2).min(150)
	}
	method nuevaEstabilidad() {
		estabilidad = (20 + material.bonusMaterial()) * tamanio.bonusTamanio()
	}
	method mejorarMuralla(nuevoTamanio, nuevoMaterial) {
		tamanio = nuevoTamanio
		material = nuevoMaterial
		self.nuevaEstabilidad()
	}
}*/

class SalaDelTrono {
	var tamanio
	var estabilidad = 30
	var estabilidadAdicional = 0
	const property guardias = []
	method aumentarTamanio(nuevoTamanio) {
		tamanio = nuevoTamanio
	}
	method nuevaEstabilidad() {
		estabilidad = 30 * tamanio.bonusTamanio() + estabilidadAdicional
	}
	method estabilidad() {
		self.nuevaEstabilidad()
		return estabilidad
	}
	method especial() {
		guardias.forEach{x => x.capacidad(5)}
		estabilidadAdicional = guardias.map{x => x.capacidad()}.sum() * 2
		guardias.clear()
	}
}

class PatioDeArmas {
	var tamanio
	var estabilidad = 20
	const property guardias = []
	method aumentarTamanio(nuevoTamanio) {
		tamanio = nuevoTamanio
	}
	method nuevaEstabilidad() {
		estabilidad = 20 * tamanio.bonusTamanio()
	}
	method estabilidad() {
		self.nuevaEstabilidad()
		return estabilidad
	}
	method especial() {
		guardias.forEach{x => x.entrenar()}
	}
}

class Armeria {
	var tamanio
	var estabilidad = 20
	const property guardias = []
	method aumentarTamanio(nuevoTamanio) {
		tamanio = nuevoTamanio
	}
	method nuevaEstabilidad() {
		estabilidad = 20 * tamanio.bonusTamanio()
	}
	method estabilidad() {
		self.nuevaEstabilidad()
		return estabilidad
	}
	method especial() {
		guardias.forEach{x => x.pulirArmas()}
	}
}

class Capilla {
	var tamanio
	var estabilidad = 20
	const property guardias = []
	method aumentarTamanio(nuevoTamanio) {
		tamanio = nuevoTamanio
	}
	method nuevaEstabilidad() {
		estabilidad = 20 * tamanio.bonusTamanio()
	}
	method estabilidad() {
		self.nuevaEstabilidad()
		return estabilidad
	}
	method especial() {
		guardias.forEach{x => x.recibirBendicion()}
	}
}

class TallerDeMamposteria {
	var tamanio
	var estabilidad = 20
	var estabilidadAdicional = 0
	const property guardias = []
	method aumentarTamanio(nuevoTamanio) {
		tamanio = nuevoTamanio
	}
	method nuevaEstabilidad() {
		estabilidad = (20 * tamanio.bonusTamanio() + estabilidadAdicional).min(100)
		estabilidadAdicional = 0
	}
	method estabilidad() {
		self.nuevaEstabilidad()
		return estabilidad
	}
	method especial() {
		estabilidadAdicional = estabilidad * 1.5
		self.nuevaEstabilidad()
	}
}

class Rey {
	var property castillo
	method organizarFiesta() {
		if (not self.castilloBajoAmenaza()) {
			castillo.ambientes().forEach{ambiente => ambiente.guardias().forEach{guardia => guardia.descansar()}}
			castillo.burocratas().forEach{burocrata => burocrata.miedo(false)}
		}
	}
	method castilloBajoAmenaza() {
		return castillo.estabilidad() < 125 and self.porcentajeMoradoresConMiedo() > 0.6
	}
	method porcentajeMoradoresConMiedo() {
		return castillo.burocratas().filter{x => x.miedo()}.size() / castillo.burocratas().size()
	}
	method consultarCastillos() {
		return todocastillos.listaDeCastillos()
	}
	method consultarEstabilidadCastillos() {
		return self.consultarCastillos().map{x => x.prepararDefensas()}
	}
	method atacarA(castilloAAtacar) {
		if (self.consultarCastillos().contains(castilloAAtacar) and not castillo.incapacesDePelear() ) {
			castilloAAtacar.recibirAtaqueDe(castillo)
		}
	}
}

class Burocrata {
	
	const fechaNacimiento
	var aniosExperiencia
	var property miedo = false
	method esJoven() {
		return fechaNacimiento > new Date(day = 1, month = 1, year = 1500)
	}
	method esInexperto() {
		return aniosExperiencia <= 10
	}
	method tieneMiedo() {
		return self.esJoven() or self.esInexperto()
	}
	method noEsJoven() {
		return fechaNacimiento < new Date(day = 1, month = 1, year = 1500)
	}
	method noEsInexperto() {
		return aniosExperiencia >= 10
	}
	method noTieneMiedo() {
		return self.noEsJoven() and self.noEsInexperto()
	}
	method planificarDefensa() {
		return 0.01
	}
}

class Guardia {
	var property capacidad = 3
	var property agotamiento = 0
	method combatir() {
		agotamiento += 4
	}
	method descansar() {
		agotamiento = (agotamiento - 3).max(0)
	}
	method noPuedePelear() {
		return agotamiento >= 10
	}
	method recibirBendicion() {
		agotamiento = 0
	}
	method pulirArmas() {
		capacidad = (capacidad + 1).min(5)
	}
	method entrenar() {
		agotamiento = (agotamiento + 1).min(6)
		capacidad = (capacidad + 1).min(10)
	}
}

object todocastillos {
	const property listaDeCastillos = []
	method agregarCastillo(nombreCastillo) {
		nombreCastillo.estabilidadCastillo()
		listaDeCastillos.add(nombreCastillo)
	}
	method sacarCastillo(nombreCastillo) {
		listaDeCastillos.remove(nombreCastillo)
	}
}

object madera {
	method bonusMaterial() = 10
}

object ladrillo {
	method bonusMaterial() = 20
}

object piedra {
	method bonusMaterial() = 30
}

object pequenio {
	method bonusTamanio() = 1
}

object mediano {
	method bonusTamanio() = 2
}

object grande {
	method bonusTamanio() = 3
}

object papa {
	method visitar(rey) {
		rey.castillo().ambientes().forEach{ambiente => ambiente.guardias().forEach{guardia => guardia.descansar()}}
		rey.castillo().burocratas().forEach{burocrata => burocrata.miedo(false)}
	}
}

object alquimista {
	method visitar(rey) {
		rey.castillo().burocratas().remove(rey.castillo().burocratas().last())
		2.times{x => rey.castillo().guardias().add(new Guardia(capacidad = 10))}
	}
}

object reinaJuanitaLaFiestera {
	var property castillo
	method coronarseEn(reino) {
		castillo = reino
	}
	method organizarFiesta() {
		castillo.ambientes().forEach{ambiente => ambiente.guardias().forEach{guardia => guardia.descansar()}}
		castillo.burocratas().forEach{burocrata => burocrata.miedo(false)}
	}
	method consultarCastillos() {
		return todocastillos.listaDeCastillos()
	}
	method consultarEstabilidadCastillos() {
		return self.consultarCastillos().map{x => x.prepararDefensas()}
	}
	method atacarA(castilloAAtacar) {
		if (self.consultarCastillos().contains(castilloAAtacar)) {
			castilloAAtacar.recibirAtaqueDe(castillo)
		}
	}
}