.data

mensaje: .ascii "Elegir palabra: (1) (2) (3)\n"
longitudMensaje = .- mensaje

palabra1: .asciz "arbol"
longitud1 = . - palabra1

palabra2: .asciz "caspa"
longitud2 = . - palabra2

palabra3: .asciz "panel"
longitud3 = . - palabra3

eleccion: .ascii " "

palabraFinal: .ascii "     "
longitudFinal = . - palabraFinal

letra: .ascii " "
longitudLetra = . - letra

letrasIng: .ascii "                                                                                 "
longitudIng = . - letrasIng

mensajeNEL: .ascii "Por favor ingrese solo una letra del abecedario\n"
longitudNEL = . - mensajeNEL

mensajeNEN: .ascii "El caracter ingresado no es el correcto\n"
longitudNEN = . - mensajeNEN

mensajeRepetida: .ascii "Esta letra ya la ingresaste, ingresa otra:\n"
longitudRepetida = . - mensajeRepetida

mensajeEG: .ascii "___________________________________________________ \n                                                   |\n                *** END GAME ***                   |\n___________________________________________________|\n\n"
longitudEG = . - mensajeEG

mensajeWin: .ascii "___________________________________________________ \n                                                   |\n                *** GANASTE! ***                   |\n___________________________________________________|\n\n"
longitudWin = . - mensajeWin

mapa: .asciz "___________________________________________________|\n                                                   |\n     *** EL JUEGO DEL AHORCADO - ORGA 1 ***        |\n___________________________________________________|\n                                                   |\n                                                   |\n          +------------+             Vidas: 5      |\n          |            I                           |\n          |            I                           |\n          |                                        |\n          |                                        |\n          |                                        |\n          |                                        |\n          |                                        |\n          |                                        |\n +-------------------------------------------+     |\n |                                           |     |\n |                                           |     |\n |                                           |     |\n +-------------------------------------------+     |\n"
longitud = . - mapa

enter: .asciz "\n"

cls: .asciz "\x1b[H\x1b[2J" /*una manera de borrar la pantalla usando ansi escape codes*/
lencls = .-cls


/*----------------------------------------------------------*/
.text             @ Defincion de codigo del programa
/*----------------------------------------------------------*/

limpiarRegistros:
	.fnstart
	push {lr}

		sub r0, r0
		sub r1, r1
		sub r2, r2
		sub r3, r3
		sub r4, r4
		sub r5, r5
		sub r6, r6
		sub r7, r7
		sub r8, r8
		sub r9, r9
		sub r10, r10
		sub r11, r11
		sub r12, r12

	pop {lr}
	bx lr
	.fnend

/*----------------------------------------------------------*/
/* Elegir la palabra con la que jugar
/*----------------------------------------------------------*/

elegirPalabra:
	.fnstart
	push {lr}
		mov r7, #4
		mov r0, #1
		ldr r1, =mensaje
		mov r2, #longitudMensaje
		swi 0

		mov r7, #3
		mov r0, #0
		ldr r1, =eleccion
		mov r2, #2
		swi 0

		ldr r1, =eleccion
		ldrb r1, [r1]

		cmp r1, #0x31
		beq asignar1

		cmp r1, #0x32
		beq asignar2

		cmp r1, #0x33
		beq asignar3

		mov r7, #4
		mov r0, #1
		ldr r1, =mensajeNEN
		mov r2, #longitudNEN
		swi 0

		cmp r1, #0x31
		blt elegirPalabra

		cmp r1, #0x33
		bgt elegirPalabra
	pop {lr}
	bx lr
	.fnend

asignar1:
	.fnstart
	push {lr}
		bl limpiarRegistros

		ldr r1, =palabra1
		ldr r2, =palabraFinal

		pasarLetra1:
			add r4, #1

			ldrb r3, [r1]
			add r1, #1

			strb r3, [r2]
			add r2, #1

		cicloSumarLetra1:
			cmp r4, #longitud1
			blt pasarLetra1
	pop {lr}
	bx lr
	.fnend

asignar2:
	.fnstart
	push {lr}
		bl limpiarRegistros

		ldr r1, =palabra2
		ldr r2, =palabraFinal

		pasarLetra2:
			add r4, #1

			ldrb r3, [r1]
			add r1, #1

			strb r3, [r2]
			add r2, #1

		cicloSumarLetra2:
			cmp r4, #longitud2
			blt pasarLetra2
	pop {lr}
	bx lr
	.fnend


asignar3:
	.fnstart
	push {lr}
		bl limpiarRegistros

		ldr r1, =palabra3
		ldr r2, =palabraFinal

		pasarLetra3:
			add r4, #1

			ldrb r3, [r1]
			add r1, #1

			strb r3, [r2]
			add r2, #1

		cicloSumarLetra3:
			cmp r4, #longitud3
			blt pasarLetra3
	pop {lr}
	bx lr
	.fnend

/*----------------------------------------------------------*/
/* Poner "_" por cada letra de la palabra
/*----------------------------------------------------------*/

reemplazar:
	.fnstart
	push {lr}

	sub r3, r3
	mov r3, #4
	sub r5, r5
	sub r6, r6
	mov r6, #0

	remplazo:
		sub r0,r0
		sub r1,r1
		sub r2,r2
		sub r4,r4

		ldr r1, =mapa
		mov r0, #'_'

		mov r2, #17  @ filas
		add r3, #2
		mov r4, #53  @ elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

	condicionRemplazo:
		mov r5, #longitudFinal
		add r6, #1

		cmp r6, r5
		blt remplazo

	pop {lr}
	bx lr
	.fnend

/*----------------------------------------------------------*/
/* Corroborar si la letra ingresada esta en la palabra
/*----------------------------------------------------------*/

srLetras:
	.fnstart
	push {lr}

	ldr r12, =letrasIng          @ Cargamos la direccion de las letras ingresadas en r9

	pedirLetras:

		sub r3, r3              @ Reinicio indice de cicloComprobar

		cmp r10, #5 		@ Se admiten hasta 5 errores
		bge win

		cmp r9, #4 		@ Se admiten hasta 5 errores
		bgt endGame

		mov r7,#3               @ syscall de teclado
		mov r0,#0               @ input stream keyboard
		mov r2,#2               @ lee 2 caracteres
		ldr r1, =letra          @ guarda la letra
		swi 0

		ldrb r11, [r1]              @ Cargamos la letra que ingreso el usuario en r11

		ldr r8, =palabraFinal	    @ Cargamos la palabra en r8

		add r12, #1

		strb r11, [r12]

		cmp r11, #0x61
		blt msgNoEsLetra

		cmp r11, #0x7a
		bgt msgNoEsLetra

		cmp r11, #'ñ'
		beq comprobarLetraRepetida

		bl comprobarLetraRepetida

	msgNoEsLetra:

		ldr r2,=longitud          /*Tamaño de la cadena*/
		ldr r1,=mapa              /*Cargamos en r1 la direccion del mensaje*/
		bl imprimirString

		mov r7, #4
		mov r0, #1
		mov r2, #longitudNEL
		ldr r1, =mensajeNEL
		swi 0

		bl pedirLetras

	cicloComprobar:
		ldr r4, =longitudFinal

		cmp r3, r4		    @ Comprueba si r3 es menor que la longitud de la palabra
		blt comprobarLetra	    @ Si es menor, llama a comprobarLetra, si ya recorrio toda la palabra, termina el ciclo

		cmp r6, #1                  @ r6 tiene la suma de las veces que la letra ingresada coincidio
		blt escribirCuerpo          @ Si es menor a 1 nunca coincidio entonces dibujamos cuerpo

		sub r6, r6		    @ Reiniciamos el valor de r6 para una proxima comprobación

		cmp r3, r4
		bge pedirLetras

	comprobarLetra:
		add r3, #1                @ Aumenta en 1 r3 para que el cicloComprobar llegue a la longitud de la palabra

		ldrb r5, [r8]             @ Guarda el valor de r0 (la direccion de la palabra) en r5

		cmp r5, r11               @ R11 la letra ingresada, R5 la letra que estamos recorriendo de la palabra a adivinar
		beq escribirLetra	  @ Si son iguales escribe la letra, sino sigue el camino de esta subrutina

		add r8, #1

		bl cicloComprobar         @ Volvemos al ciclo

	escribirLetra:
		add r8, #1
		add r6, #1		  @ Aumenta en 1 r6 para comprobar luego si se acerto al menos una letra en el ciclo

		cmp r3, #1
		ble letra1
		cmp r3, #2
		ble letra2
		cmp r3, #3
		ble letra3
		cmp r3, #4
		ble letra4
		cmp r3, #5
		ble letra5

		bl comprobarLetra

	letra1:
		push {r3}

		add r10, #1                       @ Si r10 llega a 4, gana el juego

		sub r0, r0
		sub r1, r1
		sub r2, r2
		sub r4, r4
		sub r5, r5

		ldr r5, =letra
		ldr r5, [r5]
		ldr r1, =mapa

		mov r0, r5   @ Lo que vamos a reemplazar

		mov r2, #17  @ filas
		add r3, #5
		mov r4, #53  @ elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		pop {r3}

		ldr r2,=longitud          /*Tamaño de la cadena*/
		ldr r1,=mapa              /*Cargamos en r1 la direccion del mensaje*/
		bl imprimirString

		bl comprobarLetra

	letra2:
		push {r3}

		add r10, #1                       @ Si r10 llega a 4, gana el juego

		sub r0, r0
		sub r1, r1
		sub r2, r2
		sub r4, r4
		sub r5, r5

		ldr r5, =letra
		ldr r5, [r5]
		ldr r1, =mapa

		mov r0, r5   @ Lo que vamos a reemplazar

		mov r2, #17  @ filas
		add r3, #6
		mov r4, #53  @ elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		pop {r3}

		ldr r2,=longitud          /*Tamaño de la cadena*/
		ldr r1,=mapa              /*Cargamos en r1 la direccion del mensaje*/
		bl imprimirString

		bl comprobarLetra

	letra3:
		push {r3}

		add r10, #1                       @ Si r10 llega a 4, gana el juego

		sub r0, r0
		sub r1, r1
		sub r2, r2
		sub r4, r4
		sub r5, r5

		ldr r5, =letra
		ldr r5, [r5]
		ldr r1, =mapa

		mov r0, r5   @ Lo que vamos a reemplazar

		mov r2, #17  @ filas
		add r3, #7
		mov r4, #53  @ elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		pop {r3}

		ldr r2,=longitud          /*Tamaño de la cadena*/
		ldr r1,=mapa              /*Cargamos en r1 la direccion del mensaje*/
		bl imprimirString

		bl comprobarLetra

	letra4:
		push {r3}

		add r10, #1                       @ Si r10 llega a 4, gana el juego

		sub r0, r0
		sub r1, r1
		sub r2, r2
		sub r4, r4
		sub r5, r5

		ldr r5, =letra
		ldr r5, [r5]
		ldr r1, =mapa

		mov r0, r5   @ Lo que vamos a reemplazar

		mov r2, #17  @ filas
		add r3, #8
		mov r4, #53  @ elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		pop {r3}

		ldr r2,=longitud          /*Tamaño de la cadena*/
		ldr r1,=mapa              /*Cargamos en r1 la direccion del mensaje*/
		bl imprimirString

		bl comprobarLetra

	letra5:
		push {r3}

		add r10, #1                       @ Si r10 llega a 4, gana el juego

		sub r0, r0
		sub r1, r1
		sub r2, r2
		sub r4, r4
		sub r5, r5

		ldr r5, =letra
		ldr r5, [r5]
		ldr r1, =mapa

		mov r0, r5   @ Lo que vamos a reemplazar

		mov r2, #17  @ filas
		add r3, #9
		mov r4, #53  @ elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		pop {r3}

		ldr r2,=longitud          /*Tamaño de la cadena*/
		ldr r1,=mapa              /*Cargamos en r1 la direccion del mensaje*/
		bl imprimirString

		bl comprobarLetra

	escribirCuerpo:

		cmp r9, #0		  @ Codigo para escribir el cuerpo y restar vidas
		beq vida4
		cmp r9, #1
		beq vida3
		cmp r9, #2
		beq vida2
		cmp r9, #3
		beq vida1

		add r9, #1                @ Añade 1 al ciclo de pedirLetras

	@ VIDA EN 4 ESCRIBIR CUERPO
	vida4:
		add r9, #1                 @ Añade 1 al ciclo de pedirLetras

		sub r0,r0	    	  @ QUITAR UNA VIDA
		sub r2,r2
		sub r3,r3
		sub r4,r4

		ldr r1, =mapa
		mov r0, #'4'

		mov r2, #6   @ Filas
		add r3, #44   @ Columnas
		mov r4, #53  @ Elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		sub r0,r0		  @ DIBUJAR CABEZA
		sub r2,r2
		sub r3,r3
		sub r4,r4

		ldr r1, =mapa
		mov r0, #'O'

		mov r2, #9   @ Filas
		add r3, #23  @ Columnas
		mov r4, #53  @ Elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		ldr r2,=longitud
		ldr r1,=mapa
		bl imprimirString

		bl pedirLetras

	@ VIDA EN 3 ESCRIBIR CUERPO
	vida3:
		add r9, #1                @ Añade 1 al ciclo de pedirLetras
		sub r0,r0
		sub r2,r2
		sub r3,r3
		sub r4,r4

		ldr r1, =mapa
		mov r0, #'3'

		mov r2, #6   @ Filas
		add r3, #44   @ Columnas
		mov r4, #53  @ Elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		sub r0,r0		  @ DIBUJAR BRAZO1
		sub r2,r2
		sub r3,r3
		sub r4,r4

		ldr r1, =mapa
		mov r0, #0x5c

		mov r2, #10  @ Filas
		add r3, #24  @ Columnas
		mov r4, #53  @ Elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		sub r0,r0		  @ DIBUJAR BRAZO2
		sub r2,r2
		sub r3,r3
		sub r4,r4

		ldr r1, =mapa
		mov r0, #'/'

		mov r2, #10  @ Filas
		add r3, #22  @ Columnas
		mov r4, #53  @ Elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		ldr r2,=longitud
		ldr r1,=mapa
		bl imprimirString

		bl pedirLetras

	@ VIDA EN 2 ESCRIBIR CUERPO
	vida2:
		add r9, #1                @ Añade 1 al ciclo de pedirLetras

		sub r0,r0		  @ Resta una vida
		sub r2,r2
		sub r3,r3
		sub r4,r4

		ldr r1, =mapa
		mov r0, #'2'

		mov r2, #6   @ Filas
		add r3, #44  @ Columnas
		mov r4, #53  @ Elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		sub r0,r0		  @ DIBUJAR CUERPO1
		sub r2,r2
		sub r3,r3
		sub r4,r4

		ldr r1, =mapa
		mov r0, #'|'

		mov r2, #10  @ Filas
		add r3, #23  @ Columnas
		mov r4, #53  @ Elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		sub r0,r0		  @ DIBUJAR CUERPO2
		sub r2,r2
		sub r3,r3
		sub r4,r4

		ldr r1, =mapa
		mov r0, #'|'

		mov r2, #11  @ Filas
		add r3, #23  @ Columnas
		mov r4, #53  @ Elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		ldr r2,=longitud
		ldr r1,=mapa
		bl imprimirString

		bl pedirLetras

	@ VIDA EN 1 ESCRIBIR CUERPO
	vida1:
		add r9, #1                @ Añade 1 al ciclo de pedirLetras

		sub r0,r0		  @ Resta una vida
		sub r2,r2
		sub r3,r3
		sub r4,r4

		ldr r1, =mapa
		mov r0, #'1'

		mov r2, #6   @ Filas
		add r3, #44  @ Columnas
		mov r4, #53  @ Elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		sub r0,r0		  @ DIBUJAR PIERNA1
		sub r2,r2
		sub r3,r3
		sub r4,r4

		ldr r1, =mapa
		mov r0, #'/'

		mov r2, #12  @ Filas
		add r3, #22  @ Columnas
		mov r4, #53  @ Elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		sub r0,r0		  @ DIBUJAR PIERNA2
		sub r2,r2
		sub r3,r3
		sub r4,r4

		ldr r1, =mapa
		mov r0, #0x5c

		mov r2, #12  @ Filas
		add r3, #24  @ Columnas
		mov r4, #53  @ Elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		ldr r2,=longitud
		ldr r1,=mapa
		bl imprimirString

		bl pedirLetras

	endGame:
		sub r0,r0
		sub r2,r2
		sub r3,r3
		sub r4,r4

		ldr r1, =mapa
		mov r0, #'0'

		mov r2, #6   @ Filas
		add r3, #44  @ Columnas
		mov r4, #53  @ Elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		sub r0,r0		  @ DIBUJAR CABEZA
		sub r2,r2
		sub r3,r3
		sub r4,r4

		ldr r1, =mapa
		mov r0, #'X'

		mov r2, #9  @ Filas
		add r3, #23  @ Columnas
		mov r4, #53  @ Elementos

		mul r2, r4
		add r2, r3

		add r1, r2

		strb r0, [r1]

		ldr r2,=longitud
		ldr r1,=mapa
		bl imprimirString

		mov r7, #4		  @ Codigo que imprime mensaje de end game
		mov r0, #1
		ldr r1, =mensajeEG
		mov r2, #longitudEG
		swi 0

		mov r7, #1
		swi 0
	win:
		ldr r2,=longitud
		ldr r1,=mapa
		bl imprimirString

		mov r7, #4		  @ Codigo que imprime mensaje de end game
		mov r0, #1
		ldr r1, =mensajeWin
		mov r2, #longitudWin
		swi 0

		mov r7, #1
		swi 0		
	pop {lr}
	bx lr
	.fnend

comprobarLetraRepetida:
	.fnstart
	push {lr}
	push {r0}
	push {r1}
	push {r2}

	sub r0, r0
	sub r1, r1
	sub r2, r2		@ Indice para recorrer letrasIng
	sub r7, r7

	ldr r0, =letrasIng

	verLetraRepetida:
		ldrb r1, [r0]

		cmp r1, r11
		beq sumarLetra

		add r0, #1
		add r2, #1

	cicloLetraRepetida:
		cmp r2, #longitudIng
		ble verLetraRepetida
		
		bl comprobarRepeticion

	sumarLetra:
		add r0, #1
		add r2, #1
		add r7, #1

		bl cicloLetraRepetida

	comprobarRepeticion:
		pop {r0}
		pop {r1}
		pop {r2}

		cmp r7, #1
		bgt mensajeLetraRepetida
		
		bl cicloComprobar

	mensajeLetraRepetida:
		ldr r2,=longitud          /*Tamaño de la cadena*/
		ldr r1,=mapa              /*Cargamos en r1 la direccion del mensaje*/
		bl imprimirString

		mov r7, #4		  @ Codigo que imprime mensaje de end game
		mov r0, #1
		ldr r1, =mensajeRepetida
		mov r2, #longitudRepetida
		swi 0

		bl pedirLetras

	pop {lr}
	bx lr
	.fnend

/*----------------------------------------------------------*/

imprimirString:
   .fnstart
      /* Parametros inputs:
      /* r1=puntero al string que queremos imprimir
      /* r2=longitud de lo que queremos imprimir*/
	push {lr}
	push {r1}
	push {r2}
      	bl clearScreen
      	pop {r2}
      	pop {r1}
      	mov r7,#4   /* Salida por pantalla */
      	mov r0,#1   /* Indicamos a SWI que sera una cadena*/
      	swi 0       /* SWI, Software interrup*/
      	pop {lr}
      	bx lr       /*salimos de la funcion mifuncion*/
   .fnend

/*---------------------------------------------------------*/

clearScreen:
   	.fnstart
	push {r0}
	push {r1}
	push {r2}
     		mov r0, #1
      		ldr r1, =cls
      		ldr r2, =lencls
      		mov r7, #4
      		swi 0
	pop {r0}
	pop {r1}
	pop {r2}

      	bx lr /*salimos de la funcion mifuncion*/
  	.fnend

/*----------------------------------------------------------*/

.global main


main:
	bl elegirPalabra
	bl limpiarRegistros


	bl reemplazar             @ IMPRIME EL MAPA Y TANTOS '_' COMO LETRAS EN LA PALABRA 
	bl limpiarRegistros

		 	          /*imprimo el mapa para empezar*/
	ldr r2,=longitud          /*Tamaño de la cadena*/
	ldr r1,=mapa              /*Cargamos en r1 la direccion del mensaje*/
	bl imprimirString
	bl limpiarRegistros


	bl srLetras
	bl limpiarRegistros


mov r7, #1
swi 0
