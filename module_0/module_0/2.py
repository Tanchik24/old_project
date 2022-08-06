import numpy as np


# Первый алгоритм
def main():
    print("Игра началась")
    print('Первый алгоритм')
    score_game(find_the_number)
    print('Второй алгоритм')
    score_game(find_the_number2)


def score_game(game_core):
    # '''Запускаем игру 1000 раз, чтобы узнать, как быстро игра угадывает число'''
    number_of_attempts_for_each_game_array = []
    np.random.seed(1)  # фиксируем RANDOM SEED, чтобы ваш эксперимент был воспроизводим!
    random_array = np.random.randint(1, 101, size=(1000))
    for number in random_array:
        number_of_attempts_for_each_game_array.append(game_core(number))
    score = int(np.mean(number_of_attempts_for_each_game_array))
    print(f"Ваш алгоритм угадывает число в среднем за {score} попыток")
    return (score)


def increase_temporary_variable(number, temporary_variable):
    count = 0
    while number != temporary_variable:
        count += 1
        if number > temporary_variable:
            temporary_variable += 1
        elif number < temporary_variable:
            temporary_variable -= 1
    return count


def find_the_number(number):
    if 1 <= number <= 20:
        temporary_variable = 10
    elif 21 <= number <= 40:
        temporary_variable = 31
    elif 41 <= number <= 60:
        temporary_variable = 51
    elif 61 <= number <= 80:
        temporary_variable = 71
    elif 81 <= number <= 100:
        temporary_variable = 91
    result = increase_temporary_variable(number, temporary_variable)
    return result




# Второй алгоритм

def find_the_number2(number):
    left_border = 1
    right_border = 101
    attempt = np.random.randint(left_border, right_border)
    count = 1

    if number == attempt:
        return count
    else:
        while attempt != number:
            if number > attempt:
                left_border = attempt
                attempt = np.random.randint(left_border, right_border)
                count += 1
            elif number < attempt:
                right_border = attempt + 1
                attempt = np.random.randint(left_border, right_border)
                count += 1
        return count


if __name__ == '__main__':
    main()