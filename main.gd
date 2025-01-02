extends Node


var PlayerAPI


func _ready():
	PlayerAPI = get_node_or_null("/root/BlueberryWolfiAPIs/PlayerAPI")

func get_actor_from_id(type:String,ownerID):
	var entities = get_node_or_null("/root/world/Viewport/main/entities")
	if not entities: return null

	for actor in entities.get_children():
		if actor.actor_type == type and actor.owner_id == ownerID:
			return actor

	return null

func _physics_process(dt):
	var playerData = get_node_or_null("/root/PlayerData")
	if not is_instance_valid(playerData) or not is_instance_valid(PlayerAPI.local_player):
		return
	
	
	var player:Actor = PlayerAPI.local_player  
	var skeleton:Skeleton = player.get_node("body/player_body/Armature/Skeleton")
	var torso_bone_index = skeleton.find_bone("torso")
	var torso_global_transform = skeleton.global_transform * skeleton.get_bone_global_pose(torso_bone_index)
	var offset = Transform(Basis(), Vector3(0, -0.5, 0.125))
	var toilet = get_actor_from_id("toilet", player.owner_id)
	if not is_instance_valid(toilet): return
	toilet.global_transform = torso_global_transform*offset
	Network._send_P2P_Packet({"type": "actor_update", "actor_id": toilet.actor_id, "pos": toilet.global_transform.origin, "rot": toilet.rotation}, "peers", Network.CHANNELS.ACTOR_UPDATE)
