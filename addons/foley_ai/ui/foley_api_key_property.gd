@tool
extends EditorProperty

const FoleySettings := preload("res://addons/foley_ai/core/foley_settings.gd")
const CONFIRM_SAVE_TEXT := "Save this Foley AI API key to Project Settings?"
const CONFIRM_CLEAR_TEXT := "Clear the saved Foley AI API key from Project Settings?"

var _line_edit: LineEdit
var _save_button: Button
var _confirm_dialog: ConfirmationDialog
var _editor_settings: EditorSettings
var _current_value := ""
var _pending_value := ""
var _updating := false
var _is_read_only := false


func _init(editor_settings: EditorSettings = null) -> void:
	_editor_settings = editor_settings
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(row)
	set_bottom_editor(row)

	_line_edit = LineEdit.new()
	_line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_line_edit.placeholder_text = "Foley AI API key"
	_line_edit.secret = true
	_line_edit.select_all_on_focus = true
	_line_edit.text_changed.connect(_on_text_changed)
	_line_edit.text_submitted.connect(_on_text_submitted)
	_line_edit.focus_entered.connect(_on_focus_entered)
	_line_edit.focus_exited.connect(_on_focus_exited)
	row.add_child(_line_edit)

	_save_button = Button.new()
	_save_button.text = "Save"
	_save_button.disabled = true
	_save_button.pressed.connect(_on_save_requested)
	row.add_child(_save_button)

	_confirm_dialog = ConfirmationDialog.new()
	_confirm_dialog.title = "Confirm Foley AI API Key"
	_confirm_dialog.confirmed.connect(_on_confirmed)
	add_child(_confirm_dialog)

	add_focusable(_line_edit)
	add_focusable(_save_button)


func _update_property() -> void:
	if _line_edit == null:
		return
	var value := FoleySettings.get_api_key(_editor_settings)
	_updating = true
	_current_value = value
	_pending_value = value
	_line_edit.text = value
	_line_edit.secret = not _line_edit.has_focus()
	_refresh_controls()
	_updating = false


func _set_read_only(read_only: bool) -> void:
	_is_read_only = read_only
	if _line_edit != null:
		_line_edit.editable = not read_only
	_refresh_controls()


func _on_text_changed(new_text: String) -> void:
	if _updating:
		return
	_pending_value = new_text.strip_edges()
	_refresh_controls()


func _on_text_submitted(_text: String) -> void:
	_on_save_requested()


func _on_focus_entered() -> void:
	if _line_edit == null:
		return
	_line_edit.secret = false
	_line_edit.select_all()


func _on_focus_exited() -> void:
	if _line_edit == null:
		return
	_line_edit.secret = true


func _on_save_requested() -> void:
	if _updating or _is_read_only:
		return
	_pending_value = _line_edit.text.strip_edges()
	if _pending_value == _current_value:
		return
	_confirm_dialog.dialog_text = CONFIRM_CLEAR_TEXT if _pending_value.is_empty() else CONFIRM_SAVE_TEXT
	_confirm_dialog.popup_centered()


func _on_confirmed() -> void:
	if _updating:
		return
	_current_value = _pending_value
	_updating = true
	_line_edit.text = _current_value
	_line_edit.secret = true
	_refresh_controls()
	_updating = false
	FoleySettings.save_api_key(_editor_settings, _current_value)
	emit_changed(get_edited_property(), "")


func _refresh_controls() -> void:
	if _save_button == null:
		return
	var dirty := _pending_value != _current_value
	_save_button.disabled = _is_read_only or not dirty
