@tool
extends SubViewport

@export var text_color:Color = Color(0.0, 0.745, 0.0):
	set(value):
		text_color = value
		$Label.label_settings.font_color = value
