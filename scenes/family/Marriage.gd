extends Node2D


onready var person_container_scene = preload("res://scenes/person/PersonContainer.tscn")

onready var container := $"%PersonContainer"

onready var timer: SceneTreeTimer = get_tree().create_timer(0.5)

onready var top_container = $PanelContainer


func _ready():
	# for demo purposes (when marriage starts with 2 persons pre-added
	relayout()
	
	# warning-ignore:RETURN_VALUE_DISCARDED
	top_container.connect("resized", self, "_on_resize")


func add_married_couple(p1: Person, p2: Person):
	var pc1 = person_container_scene.instance()
	pc1.add_child(p1)
	var pc2 = person_container_scene.instance()
	pc2.add_child(p2)
	container.add_child(pc1)
	container.add_child(pc2)
	relayout()


func relayout():
	if not container.get_child_count():
		print("Marriage not relayout, as no persons yet...")
		return
	# assumes a 2-person marriage
	var shortest_person = container.get_child(0).get_child(0)
	var tallest_person = container.get_child(0).get_child(0)
	for person_container in container.get_children():
		var person = person_container.get_child(0)
		if person.my_size().y < shortest_person.my_size().y:
			shortest_person = person
		if person.my_size().y > tallest_person.my_size().y:
			tallest_person = person
	
	shortest_person.position.y += (tallest_person.my_size().y - shortest_person.my_size().y)


# TODO put my_size() and _on_resize in a behaviour to attach to people, marriages, etc
# Take care with the people in the marriages, as the marriage signal ought to take precedence.
func my_size():
	old_size = $PanelContainer.rect_size
	return $PanelContainer.rect_size


var old_size = Vector2.ZERO
func _on_resize():
	
	var _old_size = old_size
	var new_size = my_size()
	if _old_size:
		S.emit_signal("signal_child_resized", self, _old_size, new_size)


func get_couple():
	return [
		container.get_child(0).get_child(0),
		container.get_child(1).get_child(0),
	]


func _to_string():
	var couple = get_couple()
	var p1 = couple[0]
	var p2 = couple[1]
	return "Marriage of %s to %s" % [p1, p2]
