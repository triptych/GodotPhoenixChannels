extends Node

var phoenix : PhoenixSocket
var channel : PhoenixChannel

func _ready():
	phoenix = PhoenixSocket.new("ws://localhost:4000/socket", {
		heartbeat_interval = 10000,
		params = {user_id = 4}
	})
	#phoenix.connect("on_event", self, "_on_channel_event")
	phoenix.connect("on_open", self, "_on_Phoenix_socket_open")
	phoenix.connect("on_close", self, "_on_Phoenix_socket_close")
	phoenix.connect("on_error", self, "_on_Phoenix_socket_error")
	phoenix.connect("on_connecting", self, "_on_Phoenix_socket_connecting")
	
	channel = phoenix.channel("game:abc")
	channel.connect("on_event", self, "_on_channel_event")
	channel.connect("on_join_result", self, "_on_channel_join_result")
	channel.connect("on_error", self, "_on_channel_error")
	channel.connect("on_close", self, "_on_channel_close")
	
	get_parent().call_deferred("add_child", phoenix, true)
	phoenix.connect_socket()

func _on_Phoenix_socket_open(payload):
	channel.join()
	print("_on_Phoenix_socket_open: ", " ", payload)
	
func _on_Phoenix_socket_close(payload):
	print("_on_Phoenix_socket_close: ", " ", payload)
	
func _on_Phoenix_socket_error(payload):
	print("_on_Phoenix_socket_error: ", " ", payload)
	
func _on_channel_event(event, payload, status):
	if status == PhoenixChannel.STATUS.ok:
		print("OK!")
		
	print("_on_channel_event:  ", event, ", ", status, ", ", payload)
	
func _on_channel_join_result(status, result):
	print("_on_channel_join_result:  ", status, result)
	
func _on_channel_error(error):
	print("_on_channel_error:  ", error)
	
func _on_channel_close(closed):
	print("_on_channel_close:  ", closed)
	
func _on_Phoenix_socket_connecting(is_connecting):
	print("_on_Phoenix_socket_connecting: ", " ", is_connecting)

func _on_Button_pressed():
	phoenix.disconnect_socket()
	
func _on_Button2_pressed():
	phoenix.connect_socket()	

func _on_Button3_pressed():
	channel.push("hit", {error = false})

func _on_Button4_pressed():
	channel.push("hit", {error = true})

func _on_Button5_pressed():
	channel.leave()


func _on_Button6_pressed():
	channel.join()


func _on_Button7_pressed():
	channel.queue_free()


func _on_Button8_pressed():
	phoenix.queue_free()
	
