extends Node

func play_sfx(sound : AudioStream, parent_node : Node, volume : float):
	if sound != null or parent_node != null:
		var stream = AudioStreamPlayer2D.new()
		
		stream.stream = sound
		stream.volume_db = volume
		
		stream.connect('finished', stream.queue_free)
		
		parent_node.add_child(stream)
		stream.play()
		
		return stream
		
func stop_sfx(stream : AudioStreamPlayer2D):
	if stream != null:
		stream.queue_free()
