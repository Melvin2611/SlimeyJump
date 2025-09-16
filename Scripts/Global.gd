extends Node

signal coin_collected(new_count: int)  # Signal, das beim Sammeln einer Münze gesendet wird

var coin_count: int = 0  # Aktuelle Anzahl gesammelter Münzen
const MAX_COINS: int = 3  # Maximale Münzen im Level

func collect_coin():
	if coin_count < MAX_COINS:
		coin_count += 1
		coin_collected.emit(coin_count)  # Signal senden
