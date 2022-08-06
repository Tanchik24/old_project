STATUS_USER_WIN = 0
STATUS_COMPUTER_WIN = 1
STATUS_TIE = 2
STATUS_COMPUTER_STEP = 3
STATUS_USER_STEP = 4

status = STATUS_USER_STEP


def is_finished():
    return status < STATUS_COMPUTER_STEP


def get_game_result():
    if status == STATUS_USER_WIN:
        return "Вы победили"
    return "Вы проиграли" if status == STATUS_COMPUTER_WIN else "Вы сыграли в ничью"
