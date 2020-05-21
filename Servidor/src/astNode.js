const TIPO_VALOR = {
	ENTERO:         'VAL_ENTERO',
  DECIMAL:        'VAL_DECIMAL',
	IDENTIFICADOR:  'VAL_IDENTIFICADOR',
	CADENA:         'VAL_CADENA',
  CARACTER:       'VAL_CARACTER',
  BOOLEANO:				'VAL_BOOLEANO'
}

const TIPO_OPERACION = {

	SUMA:           'OP_SUMA',
	RESTA:          'OP_RESTA',
	MULTIPLICACION: 'OP_MULTIPLICACION',
	DIVISION:       'OP_DIVISION',
  POTENCIA:       'OP_POTENCIA',
  MODULO:         'OP_MODULO',
	NEGATIVO:       'OP_NEGATIVO',

	MAYOR_QUE:      'OP_MAYOR_QUE',
	MENOR_QUE:      'OP_MENOR_QUE',
	MAYOR_IGUAL: 	  'OP_MAYOR_IGUAL',
	MENOR_IGUAL:    'OP_MENOR_IGUAL',
	ES_IGUAL:       'OP_ES_IGUAL',
	NO_IGUAL:    	  'OP_NO_IGUAL',

	AND:  					'OP_AND',
	OR: 			  		'OP_OR',
	NOT:   					'OP_NOT',

};

const TIPO_INSTRUCCION = {
	FILE:					'FILE',
	CLASS:				'CLASS',
	FUNCTION:			'FUNCTION',
	MAIN:					'MAIN',
	PRINT:		 		'INSTR_PRINT',
	WHILE:		    'INSTR_WHILE',
	DECLARATION:	'INSTR_DECLARATION',
	ASIGNATION:		'INSTR_ASIGANATION',
	IF:				    'INSTR_IF',
	IF_ELSE:		  'INSTR_IF_ELSE',
  ELSE:         'INSTR_ELSE',
	FOR:					'INSTR_FOR',
	DO_WHILE:			'INSTR_DO_WHILE',
	BREAK: 			  'INSTR_BREAK',
  CONTINUE:			'INSTR_CONTINUE',
	RETURN:				'INSTR_RETURN',
	SWITCH:			  'SWITCH',
	SWITCH_OP:		'SWITCH_OP',
	SWITCH_DEF:		'SWITCH_DEF',
	IMPORT:				'INSTR_IMPORT'
}

const TIPO_OPCION_SWITCH = {
	CASO: 			'CASO',
	DEFECTO: 		'DEFECTO'
}

const instrucciones = {
	OperacionBinaria: function(operandoIzq, operandoDer, tipo) {
		return {
			operandoIzq: operandoIzq,
			operandoDer: operandoDer,
			tipo: tipo
		}
	},

	OperacionUnaria: function(operando, tipo) {
		return {
			operando: operando,
			tipo: tipo
		}
	},

	Valor: function(valor, tipo) {
		return {
			tipo: tipo,
			valor: valor
		}
	},

	File: function(imports, clases)	{
		return {
			tipo: TIPO_INSTRUCCION.FILE,
			imports: imports,
			clases: clases
		}
	},

	Class: function(identificador)	{
		return {
			tipo: TIPO_INSTRUCCION.CLASS,
			identificador: identificador
		}
	},

	Function: function(identificador)	{
		return {
			tipo: TIPO_INSTRUCCION.FUNCTION,
			identificador: identificador
		}
	},

	Main: function()	{
		return {
			tipo: TIPO_INSTRUCCION.MAIN,
			identificador: 'main'
		}
	},

	Print: function(expresion) {
		return {
			tipo: TIPO_INSTRUCCION.PRINT,
			expresion: expresion
		};
	},

	While: function(expresion, instrucciones) {
		return {
			tipo: TIPO_INSTRUCCION.WHILE,
			expresion: expresion,
			instrucciones: instrucciones
		};
	},

	Declaration: function(identificador, expresion, tipo) {
		return {
			tipo: TIPO_INSTRUCCION.DECLARATION,
			identificador: identificador,
			expresion: expresion,
			tipo_dato: tipo
		}
	},

	Asignation: function(identificador, expresion) {
		return {
			tipo: TIPO_INSTRUCCION.ASIGNATION,
			identificador: identificador,
			expresion: expresion
		}
	},

	If: function(expresion, instrucciones) {
		return {
			tipo: TIPO_INSTRUCCION.IF,
			expresion: expresion,
			instrucciones: instrucciones
		}
	},

	IfElse: function(expresion, instrucciones) {
		return {
			tipo: TIPO_INSTRUCCION.IF_ELSE,
			expresion: expresion,
			instrucciones: instrucciones
		}
	},

	Else:	function(instrucciones){
		return{
			tipo:	TIPO_INSTRUCCION.ELSE,
			instrucciones:	instrucciones
		}
	},

	For: function (declaracion, expresion, cambio, instrucciones) {
		return {
			tipo: TIPO_INSTRUCCION.FOR,
			declaracion: declaracion,
			expresion: expresion,
			cambio: cambio,
			instrucciones: instrucciones,
		}
	},

	DoWhile: function (instrucciones, expresion) {
		return {
				tipo: TIPO_INSTRUCCION.DO_WHILE,
				expresion: expresion,
				instrucciones: instrucciones
		}
	},

	Break: function () {
		return{
				tipo: TIPO_INSTRUCCION.BREAK
		}
	},

	Continue: function () {
		return{
				tipo: TIPO_INSTRUCCION.CONTINUE
		}
	},

	Return: function (expresion) {
		return{
				tipo: TIPO_INSTRUCCION.RETURN,
				expresion: expresion
		}
	},

	Import: function (identificador) {
		return{
				tipo: TIPO_INSTRUCCION.IMPORT,
				identificador: identificador
		}
	},

	Switch: function(expresion, casos) {
		return {
			tipo: TIPO_INSTRUCCION.SWITCH,
			expresion: expresion,
			casos: casos
		}
	},

	ListaCasos: function (caso) {
		var casos = [];
		casos.push(caso);
		return casos;
	},

	Case: function(expresion, instrucciones) {
		return {
			tipo: TIPO_OPCION_SWITCH.CASO,
			expresion: expresion,
			instrucciones: instrucciones
		}
	},

	Default: function(instrucciones) {
		return {
			tipo: TIPO_OPCION_SWITCH.DEFECTO,
			instrucciones: instrucciones
		}
	},

	Operador: function(operador){
		return operador
	}
}

module.exports.TIPO_OPERACION = TIPO_OPERACION;
module.exports.TIPO_INSTRUCCION = TIPO_INSTRUCCION;
module.exports.TIPO_VALOR = TIPO_VALOR;
module.exports.instrucciones = instrucciones;
module.exports.TIPO_OPCION_SWITCH = TIPO_OPCION_SWITCH;
