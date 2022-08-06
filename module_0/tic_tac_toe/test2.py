import game
import random
import field

PLAYER_SYMBOL = 'X'
COMPUTER_SYMBOL = '0'


def main():
    while True:
        field.print_it()
        update_game_status()
        if game.is_finished():
            print(game.get_game_result())
            break
        do_computer_step() if game.status == game.STATUS_COMPUTER_STEP else do_user_step()


def do_step(by, row_number, column_number):
    field.array[row_number][column_number] = PLAYER_SYMBOL if by == 'player' else COMPUTER_SYMBOL
    game.status = game.STATUS_COMPUTER_STEP if game.status == game.STATUS_USER_STEP else game.STATUS_USER_STEP


def do_user_step():
    print("Введите две цифры")
    row_index, column_index = int(input("Введите цифру для строки: ")), int(input("Введите цифру для столбца: "))

    if not is_correct_input(row_index, column_index):
        print('Вы ввели недопустимые значения')
        return

    if not field.is_cell_empty(row_index, column_index):
        print('Клетка занята!, найдите себе другую!!')
        return

    do_step('player', row_index, column_index)


def do_computer_step():
    print('Ход противника')
    row_index, column_index = random.choice([0, 1, 2]), random.choice([0, 1, 2])
    if field.is_cell_empty(row_index, column_index):
        do_step('computer', row_index, column_index)


def is_correct_input(row_index, column_index):
    return row_index in range(0, 3) and column_index in range(0, 3)


def update_game_status():
    if '-' not in field.array[0] + field.array[1] + field.array[2]:
        game.status = game.STATUS_TIE
        return
    for entity in [PLAYER_SYMBOL, COMPUTER_SYMBOL]:
        if field.array[0][0] == field.array[1][1] == field.array[2][2] == entity or \
                field.array[0][2] == field.array[1][1] == field.array[2][0] == entity:
            game.status = game.STATUS_USER_WIN if entity == PLAYER_SYMBOL else game.STATUS_COMPUTER_WIN
        for i in range(3):
            if field.array[i][0] == field.array[i][1] == field.array[i][2] == entity or \
                    field.array[0][i] == field.array[1][i] == field.array[2][i] == entity:
                game.status = game.STATUS_USER_WIN if entity == PLAYER_SYMBOL else game.STATUS_COMPUTER_WIN


if __name__ == '__main__':
    main()
