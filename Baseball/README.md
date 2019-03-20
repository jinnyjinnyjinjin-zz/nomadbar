# Overview
베이스볼 게임용 ICON 기반의 스마트 컨트랙트 SCORE. 

# 게임 요구사항
1. 게임 시작을 위한 플레이어는 두명.
2. 각 플레이어는 게임 시작 전 중복되지 않는 닉네임을 정해야 한다.
3. 닉네임을 정하고 게임에 참여 했을 때 참여 인원이 두명이면 게임을 시작한다.

# 게임 방법
1. 각 플레이어는 상대가 맞추길 원하는 4자리 숫자를 입력한다.
2. 각 플레이어는 상대의 4자리 숫자를 맞춘다.
3. 추측한 숫자가 상대가 정한 숫자가 맞으면 ball, 자리 수 까지 맞으면 strike.
4. 먼저 4 strike 하는 사람이 승리한다.

# Development Environment
* MacOS Mojave 10.14.2
* pyCharm
* iconservice
* Pytho 3.6.x

# 파일구성
* python pkg
<img src="https://github.com/jinnyjinnyjinjin/smart-contracts/blob/master/Baseball/img/tree.png"></img>

* Main contract
```
baseball.py
```
* Dependency
```
iconservice
```
# Author
> jinnyjinnyjinjin
