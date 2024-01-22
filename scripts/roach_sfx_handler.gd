extends Node

func play_sfx(sound : AudioStream, parent_node : Node, volume : float = 0):
	if sound != null or parent_node != null:
		var stream = AudioStreamPlayer2D.new()
		
		stream.stream = sound
		if volume != 0: stream.volume_db = volume
		else: stream.volume_db = 20
		
		stream.connect('finished', stream.queue_free)
		
		parent_node.add_child(stream)
		stream.play()
		
		return stream
		
func stop_sfx(stream : AudioStreamPlayer2D):
	if stream != null:
		stream.queue_free()
