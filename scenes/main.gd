extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var data = {
	game_name = "untitled",
	game_author = "unknown",
	game_world = {
		items = []
	}	
}

class Item:
	var type = "text"
	var content = "Some text"
	
var textItem = {
	label = 'unnamed',
	type = 'textItem',
	content = "empty"
}	
	
	
var reset_data = data.duplicate(true)

var file_name = "untitled"

signal update_data(label, value)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_btn_new_pressed():
	print("btn_new pressed")
	data = reset_data.duplicate(true)
	$TabContainer/Source/output.text = str(data)
	$label_title/LineEdit.text = ""
	pass # Replace with function body.


func _on_btn_save_pressed():
	print('btn_save_pressed')
	$dialog_save.popup_centered()
	pass # Replace with function body.


func _on_btn_load_pressed():
	print('btn_load_pressed')
	open_file_dialog()
	return
	
	pass # Replace with function body.


func _on_btn_quit_pressed():
	print('btn_quit_pressed')
	get_tree().quit()
	pass # Replace with function body.


func _on_output_text_changed():
	print('output_text_changed')
	pass # Replace with function body.


func _on_LineEdit_text_changed(new_text):
	# data["game_name"] = $label_title/LineEdit.text
	emit_signal("update_data", "game_name", $label_title/LineEdit.text)

	pass # Replace with function body.



func _on_main_update_data(label, value):
	print(str("update data signal called with: label - ", label, " value - ", value))
	data[label] = value
	$TabContainer/Source/output.text = str(data)
	pass # Replace with function body.


func _on_btn_item_add_pressed():
	print("btn_item_add_pressed")
	$CenterContainer/ConfirmationDialog.popup()

	pass # Replace with function body.


func open_file_dialog():
	$FileDialog.popup()
	
	pass


func _on_FileDialog_file_selected(path): 
	print(str("on file selected:", path))
	# Check if there is a saved file
	var file = File.new()
	if not file.file_exists(path):
		print("No file saved!")
		return
	# Open existing file
	if file.open(path, File.READ) != 0:
		print("Error opening file")
		return
		
	# Get the data
	var data = {}
	data = parse_json(file.get_line())

	# Then do what you want with the data		
	# $output.text = str(data)
	$TabContainer/Source/output.text = str(data)
	
	pass # Replace with function body.


	


func _on_dialog_save_file_selected(path):
	# Open a file
	var file = File.new()
	if file.open(path, File.WRITE) != 0:
		print("Error opening file")
		return
	
	
	# Save the dictionary as JSON (or whatever you want, JSON is convenient here because it's built-in)
	file.store_line(to_json(data))
	file.close()
	$dialog_gamesaved.popup_centered()
	pass # Replace with function body.
	pass # Replace with function body.


func _on_ConfirmationDialog_confirmed():
	print("Text confirmation dialog accepted")
	print(str("text: ",$CenterContainer/ConfirmationDialog/VBoxContainer/TextEdit.text))
	var textString = $CenterContainer/ConfirmationDialog/VBoxContainer/TextEdit.text
	var nodeName = $CenterContainer/ConfirmationDialog/VBoxContainer/HBoxContainer/edit_node_name.text
	# var newItem = Item.new()
	# print(str(newItem))
	# newItem.content = textString
	# print(JSON.print(newItem))
	# print(newItem.get_property_list())
	# pass # Replace with function body.
	var newItem = textItem.duplicate(true)
	print(newItem)
	newItem["label"] = nodeName
	newItem["content"] = textString
	print(newItem)
	print(data.game_world.items)
	data.game_world.items.append(newItem)
	print(data)
	render_data_to_list()	


func render_data_to_list():
	print("render data to list")
	#$TabContainer/World/ItemList.add_item(str("placeholder", rand_range(0,300)))
	$TabContainer/World/ItemList.clear()
	for i in data.game_world.items :
		print(i['label'])
		$TabContainer/World/ItemList.add_item(i.label)	
	$TabContainer/Source/output.text = str(data)

func delItem(itemName): 
	print(str("delItem called with itemName:", itemName))
	var foundIdx = 0
	for x in data.game_world.items:
		if x.label == itemName:
			print("found it!", x.label)
			break
		else:
			foundIdx+=1	
	
	data.game_world.items.remove(foundIdx)
	$TabContainer/Source/output.text = str(data)
	render_data_to_list()


func _on_btn_item_remove_pressed():
	print("on_btn_item_remove pressed")
	var itemList = $TabContainer/World/ItemList
	var selItemArr = itemList.get_selected_items()
	var selItemName = itemList.get_item_text(selItemArr[0])
	print(selItemArr)
	print(selItemName)
	delItem(selItemName)
	pass # Replace with function body.
