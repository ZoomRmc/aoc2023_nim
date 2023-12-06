import std/[parseutils, strscans, math]
from std/strutils import Digits
import pkg/slicerator/itermacros

const INPUTF = "input/aoc06.txt"
const Seps = {' ', '\t', '\n', '\r'}

proc parseP1(input: string): seq[(int, int)] =
  var idx, num, i = 0
  discard input.scanp(idx, "Time:", *`Seps`,
     *(parseInt($input, num, $index) -> result.add((num, 0)), +`Seps`),
     "Distance:", *`Seps`,
     *(parseInt($input, num, $index) -> (result[i][1]=num; i.inc()), +`Seps`)
   )

proc parseP2(input: string): (int, int) =
  var idx, time, dist = 0
  proc parseDigits(n: var int; c: char) = n = n * 10 + ord(c) - ord('0')
  discard input.scanp(idx, "Time:", *`Seps`,
      +(`Digits` -> parseDigits(time, $_), *`Seps`),
      "Distance:", *`Seps`,
      +(`Digits` -> parseDigits(dist, $_), *`Seps`),
    )
  (time, dist)

proc runRace(time, target: int): int =
  var lose = 0
  for t in 0..(time div 2):
    let d = t * (time - t)
    if d <= target: lose.inc() else: break
  (time + 1 - (lose * 2))

proc countWins(time, target: int): int =
  ## Calculate the number of numbers between the roots
  let discriminant = float(time * time - 4 * target)
  if discriminant < 0: raise newException(ValueError, "No roots")
  let r1 = (float(time) - sqrt(discriminant)) / 2
  let r2 = (float(time) + sqrt(discriminant)) / 2
  int(r2.floor() - r1.ceil()) + 1

proc main*(silent: bool = false) =
  let inputStr = readFile(INPUTF)

  block Part1:
    let inputP1 = inputStr.parseP1()
    var wins: seq[int]
    for (time, target) in inputP1:
      let win = runRace(time, target)
      wins.add(win)
    let p1 = wins.items.product()
    if not silent: echo p1 # 500346

  block Part2:
    let (timeP2, distP2) = inputStr.parseP2()
    #let p2 = runRace(timeP2, distP2) # iterative
    let p2 = countWins(timeP2, distP2)
    if not silent: echo p2 # 42515755

when isMainModule:
  main()
