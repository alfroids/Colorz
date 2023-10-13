extends TextureButton


@export var ID: Global.PC = Global.PC.SIMPLE_PIPE


func _ready():
	ResourceManager.quantity_changed.connect(_on_quantity_changed)
	update_number()


func _on_pressed():
	ResourceManager.selected_piece = ID


func update_number() -> void:
	if ResourceManager.quantities[ID] == 0:
		self.disabled = true
	else:
		self.disabled = false

	$Number.text = str(ResourceManager.quantities[ID])


func _on_quantity_changed(piece: Global.PC) -> void:
	if piece == ID:
		update_number()
