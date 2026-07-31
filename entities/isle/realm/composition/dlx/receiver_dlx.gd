class_name DLXSolutionReceiver
extends RefCounted


# вернуть false -> остановить поиск
func on_solution(row_ids: Array[int]) -> bool:
	if row_ids.size() != 12:
		print("BAD SOLUTION SIZE:", row_ids.size())
	return true
