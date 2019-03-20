from iconservice import *


class Baseball(IconScoreBase):
    TAG = 'Baseball'

    _PLAYERS = 'players'
    _PLAYERS_NUMBERS = 'players_numbers'
    _USERNAME_TO_ADDR = 'username_to_addr'
    _ADDR_TO_USERNAME = 'addr_to_username'
    _WINNERS = 'winners'

    def __init__(self, db: IconScoreDatabase) -> None:
        super().__init__(db)
        self._players = ArrayDB(self._PLAYERS, db, value_type=Address)
        self._players_numbers = DictDB(self._PLAYERS_NUMBERS, db, value_type=str)
        self._username_to_addr = DictDB(self._USERNAME_TO_ADDR, db, value_type=Address)
        self._addr_to_username = DictDB(self._ADDR_TO_USERNAME, db, value_type=str)
        self._winners_username = DictDB(self._WINNERS, db, value_type=Address)

    def on_install(self):
        super().on_install()

    def on_update(self):
        super().on_update()

    # Players
    @external
    def set_each_numbers(self, _number_set: str) -> None:
        self._players_numbers[self.msg.sender] = _number_set

    @external
    def guess_numbers(self, _guess_num_str: str):
        _guess_num = json_loads(_guess_num_str)
        opponent_num = self.get_opponent_numbers()
        self.get_guess_result(_guess_num, opponent_num)

    # Game Helper
    @external
    def join_check(self) -> bool:
        player_num = len(self._players)
        if -1 < player_num < 2:
            self._players.put(self.msg.sender)
            return True
        else:
            return False

    @external
    def check_username(self, _username: str) -> bool:
        used_username = self._username_to_addr[_username]
        if used_username != _username:
            self._username_to_addr[_username] = self.msg.sender
            return True
        else:
            return False

    def create_random_nums(self) -> int:
        rand_num = int.from_bytes(
            sha3_256(self.now() + self._addr_to_username[self.msg.sender].to_bytes() + self.block_height), 'big')
        return rand_num

    @external
    def rock_scissors_paper(self, _num1: int, _num2: int) -> str:
        rand_num = self.create_random_nums()
        if _num1 == rand_num:
            return '1'
        else:
            return '2'

    def get_opponent_numbers(self) -> list:
        opponent_addr = ''
        for addr in self._players:
            if addr != self.msg.sender:
                opponent_addr = addr
        opponent_num = json_loads(self._players_numbers[opponent_addr])
        return opponent_num

    def get_guess_result(self, _guess_num: list, _opponent_num: list) -> str:
        strike = 0
        ball = 0
        result = []
        for i in range(0, len(_guess_num)):
            for k in range(0, len(_opponent_num)):
                if _guess_num[i] == _opponent_num[k]:
                    if i == k:
                        strike += 1
                    ball += 1
        result.append(ball)
        result.append(strike)
        result_str = json_dumps(result)
        return result_str

    @external
    def save_winner(self):
        winner_username = self._addr_to_username[self.msg.sender]
        self._winners_username[winner_username] = winner_username

    @external
    def end_game(self) -> None:
        while True:
            self._players.pop()

    @external(readonly=True)
    def select_winner_username(self, _username: str) -> str:
        winner_username = self._winners_username[_username]
        return winner_username

    @external(readonly=True)
    def select_all_winners(self) -> str:
        winners = []
        for winner in self._winners_username:
            winners.append(winner)
        winners_str = json_dumps(winners)
        return winners_str
