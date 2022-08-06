array = [['-' for j in range(3)] for i in range(3)]


def print_it():
    print('-' * 17)
    for row in array:
        for symbol in row:
            print(f'| {symbol} |', end=' ')
        print()
    print('-' * 17)


def is_cell_empty(row_index, column_index):
    return array[row_index][column_index] == '-'
