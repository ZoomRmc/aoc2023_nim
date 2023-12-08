import std/[tables]
from std/math import lcm
import pkg/slicerator/itermacros

const INPUTF = "input/aoc08.txt"

type
  Position = array[3, char]
  Map = Table[Position, array[bool, Position]]

func `$`(p: Position): string =
  result.setLen(3)
  for i in 0..2: result[i] = p[i]

func endsWith(p: Position; c: char = 'A'): bool = p[2]==c

func stepsToExit(p: Position; map: Map; path: seq[bool]; p1cond: static bool = true): int =
  var
    pos: Position = p #
    i = 0
  while (when p1cond: pos != ['Z', 'Z', 'Z'] else: not pos.endsWith('Z')):
    let turn = path[i mod path.len]
    pos = map[pos][turn]
    i.inc()
  i

proc parse(inputFName: string): (seq[bool], Map) =
  var path: seq[bool]
  var map: Map
  for (i, line) in lines(inputFName).enumerate():
    if i == 0:
      for c in line:
        path.add(c == 'R')
    elif i > 1:
      var pos, left, right: Position
      for i in 0..2: pos[i]=line[i]; left[i]=line[i+7]; right[i]=line[i+12]
      map[pos] = [left, right]
  (path, map)

proc main*(silent: bool = false) =
  let (path, map) = parse(INPUTF)

  block Part1:
    let p1 = ['A', 'A', 'A'].stepsToExit(map, path, true)
    if not silent: echo p1 # 21251

  block Part2:
    let starting = map.keys().filterIt(it.endsWith('A')).collect()
    var lengths: seq[int]
    for p in starting: lengths.add(p.stepsToExit(map, path, false))

    let p2 = lcm(lengths)
    if not silent: echo p2 # 11678319315857

when isMainModule:
  main()
