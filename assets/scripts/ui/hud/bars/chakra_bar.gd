extends TextureProgressBar

func _ready():
	%ChakraCounter.text = str(ChakraManager.current_chakra) + "/"+ str(ChakraManager.max_chakra)
	max_value = ChakraManager.max_chakra
	#Connecting signal that is emmited from the ChakraManager
	ChakraManager.chakra_changed.connect(update_chakra)
	await get_tree().create_timer(0.001).timeout
	update_chakra()
func update_chakra():
	#ChakraBar update
	value = round(ChakraManager.current_chakra)
	#ChakraLabel update
	%ChakraCounter.text = str(round(ChakraManager.current_chakra)) + "/"+ str(ChakraManager.max_chakra)
