extends Node


var PlayerAPI


func _ready():
	PlayerAPI = get_node_or_null("/root/BlueberryWolfiAPIs/PlayerAPI")

func get_actor_from_id(id):
	var entities = get_node_or_null("/root/world/Viewport/main/entities")
	if not entities: return null

	for actor in entities.get_children():
		if actor.actor_id == id:
			return actor

	return null

func _physics_process(dt):
	var playerData = get_node_or_null("/root/PlayerData")
	if not is_instance_valid(playerData) or not is_instance_valid(PlayerAPI.local_player):
		return
	
	var player = PlayerAPI.local_player
	var skeleton:Skeleton = player.get_node("body/player_body/Armature/Skeleton")
	var torso_bone_index = skeleton.find_bone("torso")
	var torso_global_transform = skeleton.global_transform * skeleton.get_bone_global_pose(torso_bone_index)
	var offset = Transform(Basis(), Vector3(0, -0.5, 0.125))
	
	for prop_data in playerData.props_placed:
		if prop_data.ref == 781022529:
			var toilet:Actor = get_actor_from_id(prop_data.id)
			if not toilet:
				return
			toilet.global_transform = torso_global_transform*offset
