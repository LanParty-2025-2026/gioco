extends Control

@onready var giuste: Label = $giuste
@onready var sbagliate: Label = $sbagliate

var risposte_giuste: int
var risposte_sbagliate: int

@onready var checkrisposte: Node = $"../paginaDomande/checkrisposte"
@onready var pagina_domande: Control = $"../paginaDomande"

#termina partita e nasconde domande
func assegna_valori():
	
	risposte_giuste = checkrisposte.risposte_giuste
	risposte_sbagliate = checkrisposte.risposte_sbagliate
	visible = true
	pagina_domande.queue_free()
	giuste.text = str("risposte giuste: ", risposte_giuste)
	sbagliate.text = str("risposte sbagliate: ", risposte_sbagliate)
	
	get_parent().get_parent().get_parent().get_parent().addPunti(risposte_giuste * 10)
