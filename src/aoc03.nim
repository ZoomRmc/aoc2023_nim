import std/[tables]
from std/strutils import Digits
import pkg/slicerator/itermacros

const INPUTF = "input/aoc03.txt"

type
  Point = tuple[y, x: int]
  Number = object
    p: Point
    len: Natural
    v: int

func `+`(a, b: Point): Point = (y: a.y + b.y, x: a.x + b.x)

iterator neighbors(num: Number): Point =
  var neis: seq[Point]
  for nei in [(-1, -1), (0, -1), (1, -1)]: # start
    neis.add (num.p + nei)
  for xoffset in 0..<num.len:
    for nei in [(-1, 0), (1, 0)]:
      neis.add (num.p + (0, xoffset) + nei)
  for nei in [(-1, 1), (0, 1), (1, 1)]: # end
    neis.add (num.p + (0, num.len - 1) + nei)
  for nei in neis: yield nei

func isPartNumber(num: Number; symbols: Table[Point, char]): bool =
  neighbors(num).anyIt(it in symbols)

proc main*(silent: bool = false) =
  var
    nums: seq[Number]
    num: Number
    parsing = false
    symbols: Table[Point, char]
    gearsToCheck: Table[Point, seq[int]]

  template push() = nums.add num; num = default(Number); parsing = false
  for (y, line) in lines(INPUTF).enumerate():
    for (x, c) in line.pairs:
      if x == 0 and parsing: push() # !BUG misses last number if touches corner
      let p = (y: y, x: x)
      if c in Digits:
        if not parsing:
          num.p = p
          parsing = true
        num.v = num.v * 10 + (c.ord - '0'.ord)
        num.len.inc()
      else:
        if parsing: push()
        if c != '.':
          symbols[p] = c
          if c == '*':
            discard gearsToCheck.hasKeyOrPut(p, newSeq[int]())

  block Part1:
    var p1 = 0
    #for v in nums.items.filterIt(it.isPartNumber(symbols)).mapIt(it.v): # BUG
    for num in nums.items:
      if num.isPartNumber(symbols): p1.inc(num.v)
    if not silent: echo p1 # 527364

  block Part2:
    for num in nums:
      for nei in neighbors(num):
        gearsToCheck.withValue(nei, value):
          value[].add num.v
    let p2 = gearsToCheck.values.filterIt(it.len == 2).mapIt(it.items.product()).sum()
    if not silent: echo p2 # 79026871

when isMainModule:
  main()
