.data								#SEGMENTO .DATA PROVEIDO POR EL ENUNCIADO
slist: 		.word 0
cclist:		.word 0
wclist: 	.word 0
schedv: 	.space 32
menu: 		.ascii "Colecciones de objetos categorizados\n"
			.ascii "====================================\n"
			.ascii "1-Nueva categoria\n"
			.ascii "2-Siguiente categoria\n"
			.ascii "3-Categoria anterior\n"
			.ascii "4-Listar categorias\n"
			.ascii "5-Borrar categoria actual\n"
			.ascii "6-Anexar objeto a la categoria actual\n"
			.ascii "7-Listar objetos de la categoria\n"
			.ascii "8-Borrar objeto de la categoria\n"
			.ascii "0-Salir\n"
			.asciiz "Ingrese la opcion deseada: "
error: 		.asciiz "Error: "
return: 	.asciiz "\n"
catName: 	.asciiz "\nIngrese el nombre de una categoria: "
selCat: 	.asciiz "\nSe ha seleccionado la categoria: "
idObj: 		.asciiz "\nIngrese el ID del objeto a eliminar: "
objName: 	.asciiz "\nIngrese el nombre de un objeto: "
success: 	.asciiz "La operación se realizo con exito\n\n"

.text
main: 								#INICIALIZACION DEL VECTOR QUE CONTIENE LAS OPCIONES PARA MANEJAR LAS LISTAS (TEMPLATE PROVEIDA POR EL ENUNCIADO)
		la $t0, schedv 				# initialization scheduler vector
		la $t1, newcaterogy
		sw $t1, 0($t0)
		la $t1, nextcategory
		sw $t1, 4($t0)
		la $t1, previouscategory
		sw $t1, 8($t0)
		la $t1, listcategories
		sw $t1, 12($t0)
		#la $t1, delcategory
		#sw $t1, 16($t0)
		#la $t1, newobject
		#sw $t1, 20($t0)
		#la $t1, listobjects
		#sw $t1, 24($t0)
		#la $t1, delobject
		#sw $t1, 28($t0)
		
		j menu_loop
		
#LOOP DEL MENU PRINCIPAL Y LECTOR DEL INPUT DEL USUARIO
menu_loop:
		li $v0, 4					# Salto de linea para mejor visualizacion
		la $a0, return  			
		syscall
		la $a0, menu					# Muestro menu
		li $v0, 4
		syscall
		
		li $v0, 5  					# Leer opción ingresada por el usuario
		syscall

		beq $v0, 0, exit				# Verificar opción para salir

		ble $v0, -1, error_invalidoption		# Verificar rango de opciones válidas
		bge $v0, 9, error_invalidoption
		
		sub $v0, $v0, 1          			# Ajustar índice a base 0
		la $t0, schedv 
		sll $t1, $v0, 2          			# Multiplicar base por 4 para obtener puntero a funcion solicitada
		add $t0, $t0, $t1        			# Apuntar a la funcion solicitada
		lw $t1, 0($t0)           			# Cargamos dirección de la función
		jalr $t1                 			# Llamamos a la función
		
		j menu_loop					#Finalizada la ejecucion de funcion volver a listar menu
		
error_invalidoption:						
		li $a0, 101					#Código de error cuando el usuario introduce un numero que no corresponde a una opción
		j printerror  		
		
exit:
		li $v0, 10             				#Syscall para terminar el programa
		syscall

#FUNCION PARA AGREGAR UNA NUEVA CATEGORIA (PROVEIDA POR EL ENUNCIADO)
newcaterogy:
		addiu $sp, $sp, -4
		sw $ra, 4($sp)
		la $a0, catName 					# input category name
		jal getblock
		move $a2, $v0 						# $a2 = *char to category name
		la $a0, cclist 						# $a0 = list
		li $a1, 0 							# $a1 = NULL
		jal addnode
		lw $t0, wclist
		bnez $t0, newcategory_end
		sw $v0, wclist 						# update working list if was NULL
				
newcategory_end:
		li $v0, 0 							# return success
		lw $ra, 4($sp)
		addiu $sp, $sp, 4
		j successmsg

#FUNCIONES PARA MOVERSE POR LA LISTA ENLAZADA DE CATEGORIAS		
nextcategory:
		lw $t0, cclist
		beqz $t0, error_nocategorytoselect		#No hay categorias seleccionadas
		lw $t0, wclist
		lw $t1, 0($t0)
		lw $t2, 12($t0)
		beq $t0, $t1, error_onecategory			#Solo hay una categoria
		sw $t2, wclist
		li $v0, 4
		la $a0, selCat  				#Mensaje de nueva categoria seleccionada
		syscall
		lw $a0, 8($t2)
		syscall
		li $v0, 0
		jr $ra
		
previouscategory:
		lw $t0, cclist
		beqz $t0, error_nocategorytoselect		#No hay categorias seleccionadas
		lw $t0, wclist
		lw $t1, 0($t0)
		lw $t2, 12($t0)
		beq $t0, $t1, error_onecategory			#Solo hay una categoria
		sw $t1, wclist
		li $v0, 4
		la $a0, selCat  				#Mensaje de nueva categoria seleccionada
		syscall
		lw $a0, 8($t1)
		syscall
		li $v0, 0
		jr $ra
		
error_nocategorytoselect:
		li $a0, 201					#Codigo de error cuando no hay categorias y se intenta acceder a la siguiente/anterior
		j printerror  		
		
error_onecategory:
		li $a0, 202					#Codigo de error cuando hay solo una categoria y se intenta acceder a la siguiente/anterior
		j printerror  		
		
#FUNCION PARA LISTAR CATEGORIAS
listcategories:
		lw $t0, cclist
		beqz $t0, error_nocategoriestolist
		li $v0, 4
		la $a0, return
		syscall
		lw $t1, wclist
		move $t2, $t0					#En t2 queda guardada la direccion de la primer categoria

checkcurrentcategory:
		bne $t0, $t1, listloop              		#Si el nodo actual es igual a wclist, queda marcado
		li $v0, 11					#Op code para imprimir char
		li $a0, '>'					
		syscall	
		
listloop:
		lw $a0, 8($t0)
		li $v0, 4
		syscall
		lw $t0, 12($t0)
		beq $t0, $t2, exitloop				#Compara que el nodo a imprimir no sea el nodo con el que empezamos
		j checkcurrentcategory
			
exitloop:
		li $v0, 0
		jr $ra	
				
error_nocategoriestolist:
		li $a0, 301					#Codigo de error cuando no hay categorias para listar
		j printerror  		

#FUNCION PARA ELIMINAR UNA CATEGORIA
delcategory:
		lw $t0, cclist
		beqz $t0, error_nocatnodel			#Chequea si no hay categorias
		
error_nocatnodel:
		li $a0, 401					#Codigo de error cuando no hay categorias para eliminar
		j printerror
		
#FUNCION PARA LA CREACION DE UN NUEVO OBJETO
newobject:
		lw $t0, cclist
		beqz $t0, error_nocategoryforobj		#Checquea si no hay categorias
		
error_nocategoryforobj:
		li $a0, 501					#Codigo de error cuando se quiere anexar un objeto y no hay categorías
		j printerror

#FUNCION PARA LISTAR OBJETOS DE LA CATEGORIA SELECCIONADA
listobjects:	
		lw $t0, cclist
		beqz $t0, error_nocatnolist			#Chequea si no hay categorias
		
error_nocatnolist:
		li $a0, 601					#Codigo de error cuando se quiere listar los objetos de una categoría, pero no hay categorías
		j printerror
		
error_noobjects:
		li $a0, 602					#Codigo de error cuando no hay objetos anexados a la categoria que se quiere listar
		j printerror

#FUNCION PARA BORRAR UN OBJETO DE LA CATEGORIA SELECCIONADA
delobject:
		lw $t0, cclist
		beqz $t0, error_nocatnodelobj			#Chequea si no hay categorias
		
error_nocatnodelobj:
		li $a0, 701					#Codigo de error cuando no hay categorias y, por lo tanto, no hay objetos para eliminar
		j printerror

#MENSAJE DE OPERACION EXITOSA
successmsg:
		li $v0, 4
		la $a0, success
		syscall
		jr $ra
		
#TEMPLATE DE MENSAJE DE ERROR		
printerror:		
		move $t0, $a0					#La función recibe el código de error
		li $v0, 4
		la $a0, error  					#Nuevo mensaje de error
		syscall
		li $v0, 1
		move $a0, $t0					
		syscall
		li $v0, 4					#Salto de linea para volver a imprimir menu
		la $a0, return  				
		syscall
		li $v0, 1
		j menu_loop
		
#FUNCIONES DE GESTIÓN DE MEMORIA (PROVEIDAS POR EL ENUNCIADO)	
addnode:
		addi $sp, $sp, -8
		sw $ra, 8($sp)
		sw $a0, 4($sp)
		jal smalloc
		sw $a1, 4($v0) 			# set node content
		sw $a2, 8($v0)
		lw $a0, 4($sp)
		lw $t0, ($a0) 			# first node address
		beqz $t0, addnode_empty_list
		
addnode_to_end:
		lw $t1, ($t0) 			# last node address
		# update prev and next pointers of new node
		sw $t1, 0($v0)
		sw $t0, 12($v0)
		# update prev and first node to new node
		sw $v0, 12($t1)
		sw $v0, 0($t0)
		j addnode_exit
		
addnode_empty_list:
		sw $v0, ($a0)
		sw $v0, 0($v0)
		sw $v0, 12($v0)
		
addnode_exit:
		lw $ra, 8($sp)
		addi $sp, $sp, 8
		jr $ra
		
# a0: node address to delete
# a1: list address where node is deleted
delnode:
		addi $sp, $sp, -8
		sw $ra, 8($sp)
		sw $a0, 4($sp)
		lw $a0, 8($a0) 			# get block address
		jal sfree # free block
		lw $a0, 4($sp) 			# restore argument a0
		lw $t0, 12($a0) 		# get address to next node of a0 node
		beq $a0, $t0, delnode_point_self
		lw $t1, 0($a0) 			# get address to prev node
		sw $t1, 0($t0)
		sw $t0, 12($t1)
		lw $t1, 0($a1) 			# get address to first node again
		bne $a0, $t1, delnode_exit
		sw $t0, ($a1) 			# list point to next node
		j delnode_exit
	
delnode_point_self:
		sw $zero, ($a1) 		# only one node
	
delnode_exit:
		jal sfree
		lw $ra, 8($sp)
		addi $sp, $sp, 8
		jr $ra
	
# a0: msg to ask
# v0: block address allocated with string
getblock:
		addi $sp, $sp, -4
		sw $ra, 4($sp)
		li $v0, 4
		syscall
		jal smalloc
		move $a0, $v0
		li $a1, 16
		li $v0, 8
		syscall
		move $v0, $a0
		lw $ra, 4($sp)
		addi $sp, $sp, 4
		jr $ra
		
smalloc:
		lw $t0, slist
		beqz $t0, sbrk
		move $v0, $t0
		lw $t0, 12($t0)
		sw $t0, slist
		jr $ra
		
sbrk:
		li $a0, 16 				# node size fixed 4 words
		li $v0, 9
		syscall 				# return node address in v0
		jr $ra
		
sfree:
		lw $t0, slist
		sw $t0, 12($a0)
		sw $a0, slist 			# $a0 node address in unused list
		jr $ra