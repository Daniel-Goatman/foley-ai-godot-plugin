@tool
extends EditorInspectorPlugin

const FoleySettings := preload("res://addons/foley_ai/core/foley_settings.gd")
const FoleyApiKeyProperty := preload("res://addons/foley_ai/ui/foley_api_key_property.gd")

var _editor_settings: EditorSettings


func _init(editor_settings: EditorSettings = null) -> void:
	_editor_settings = editor_settings


func _can_handle(object: Object) -> bool:
	return object == ProjectSettings or object is ProjectSettings


func _parse_property(
	object: Object,
	type: Variant.Type,
	name: String,
	hint_type: PropertyHint,
	hint_string: String,
	usage_flags: int,
	wide: bool
) -> bool:
	if name != FoleySettings.KEY_API_KEY_LEGACY:
		return false
	if type != TYPE_STRING:
		return false
	add_property_editor(name, FoleyApiKeyProperty.new(_editor_settings))
	return true
