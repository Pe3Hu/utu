class_name DragDropGrid
extends GridContainer


# Emit signal when any drag is completed by child cells
signal dragged(from: Vector2i, to: Vector2i)

# 2D array of cells [row] [column]
var cells: Array = []


func _ready() -> void:
	init_cells()

func init_cells() -> void:
	# Initialize _cells array
	for x in columns:
		cells.append([])
	
	var row: int = 0
	var column: int = 0
	
	for cell in get_children():
		cells[column].append(cell)
		# Tell each cell its grid position
		cell.grid_position = Vector2i(column, row)
		# Connect dragged signal
		cell.dragged.connect(dragged.emit)
		column += 1
		
		if column >= columns:
			column = 0
			row += 1
