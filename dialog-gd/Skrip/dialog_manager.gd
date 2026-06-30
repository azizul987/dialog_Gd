extends Node

signal dialog_selesai

@export var dialog_data: data_dialog

@onready var dialog_box: Control = $"../ui/Dialog"
@onready var label_penutur: Label = $"../ui/Dialog/Name/name"
@onready var label_narasi: Label = $"../ui/Dialog/Isi/dialog_txt"

@onready var luffy: CharacterBody2D = $"../world/Luffy"
@onready var aster: CharacterBody2D = $"../world/Aster"
@onready var cut: CharacterBody2D = $"../world/Cut"

@onready var button_container: VBoxContainer = $"../ui/Dialog/button_Container"

const PILIHAN__BUTTON = preload("uid://cmmdy22thy3uv")
var id_awal: String = "start"
var dialog_aktif: bool = false
var node_sekarang: node_dialog


func _ready() -> void:
	dialog_box.hide()
	sembunyikan_semua_tanda()


func mulai_dialog(id_dialog: String = "") -> void:
	if dialog_aktif:
		return

	if id_dialog.is_empty():
		id_dialog = id_awal

	dialog_aktif = true
	dialog_box.show()

	tampilkan_dialog(id_dialog)

	await dialog_selesai


func tampilkan_dialog(id_dialog: String) -> void:
	node_sekarang = cari_node_dialog(id_dialog)

	if node_sekarang == null:
		push_warning("Dialog dengan ID '" + id_dialog + "' tidak ditemukan.")
		selesai_dialog()
		return

	label_penutur.text = node_sekarang.penutur
	label_narasi.text = node_sekarang.narasi

	atur_tanda_penutur(node_sekarang.penutur)
	if node_sekarang.pilihan.is_empty() == false:
		show_pilihan(node_sekarang.pilihan)


func cari_node_dialog(id_dialog: String) -> node_dialog:
	for node in dialog_data.nodes:
		if node == null:
			continue

		if node.id.strip_edges() == id_dialog.strip_edges():
			return node

	return null


func _input(event: InputEvent) -> void:
	if not dialog_aktif:
		return

	if event.is_action_pressed("ui_accept"):
		lanjut_dialog()


func lanjut_dialog() -> void:
	var id_tujuan: String = node_sekarang.id_selanjutnya.strip_edges()
	if id_tujuan.is_empty():
		selesai_dialog()
		return
	else:
		tampilkan_dialog(id_tujuan)


func selesai_dialog() -> void:
	dialog_box.hide()
	dialog_aktif = false

	sembunyikan_semua_tanda()

	dialog_selesai.emit()


func atur_tanda_penutur(nama_penutur: String) -> void:
	sembunyikan_semua_tanda()

	match nama_penutur.strip_edges().to_lower():
		"luffy":
			ubah_tanda(luffy, true)
		"aster":
			ubah_tanda(aster, true)
		"Cut":
			ubah_tanda(cut, true)
		_:
			pass


func sembunyikan_semua_tanda() -> void:
	ubah_tanda(luffy, false)
	ubah_tanda(aster, false)
	ubah_tanda(cut, false)


func ubah_tanda(karakter: Node, tampil: bool) -> void:
	var tanda := karakter.get_node_or_null("TandaDialog") as CanvasItem

	if tanda != null:
		tanda.visible = tampil
		
func show_pilihan(Pilihan: Array)->void:
	print("kwkwwkk")
	for  child in button_container.get_children():
		child.queue_free()
	for opsi in Pilihan:
		var btn = PILIHAN__BUTTON.instantiate() as Button
		btn.text=opsi.text
		button_container.add_child(btn)
