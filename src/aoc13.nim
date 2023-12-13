import std/[bitops]
import pkg/[slicerator/itermacros]

const INPUTF = "input/aoc13.txt"

type Pattern = tuple[orig, rot: seq[uint]]

when false:
  proc `$`(s: seq[bool] | openArray[bool]): string =
    for c in s: result.add ['.', '#'][c.ord]
  proc `$`(p: Pattern): string =
    for row in p: result.add($row); result.add('\n')

func rotate(p: openArray[seq[bool]]): seq[seq[bool]] =
  for x in 0..<p[0].len:
    result.add(newSeqOfCap[bool](p.len))
    for y in countDown(p.len-1, 0):
      result[x].add(p[y][x])

func toBits(s: openArray[bool]): uint =
  assert s.len <= sizeOf(uint) * 8
  s.pairs().foldIt(0'u, acc or (uint it[1].ord shl it[0]))

proc parse(inputFName: string): seq[Pattern] =
  var pattern: seq[seq[bool]]
  for line in lines(inputFName):
    if line == "":
      let orig = pattern.items().mapIt(it.toBits).collect()
      let rot = pattern.rotate().items().mapIt(it.toBits).collect()
      pattern = @[]
      result.add((orig, rot))
    else:
      pattern.add(line.items().mapIt(it == '#').collect())

proc diff(a, b: uint): int = countSetBits(a xor b)

proc findAxis(p: Pattern; smudged: static bool): tuple[vert: bool, axis: int] =
  for (vert, pattern) in [(false, p.orig), (true, p.rot)]:
    let height = pattern.len - 1
    for y in 1..height:
      var (a, b) = (y - 1, y)
      var diffAcc = 0
      while a >= 0 and b <= height:
        diffAcc.inc(diff(pattern[a], pattern[b]))
        if diffAcc > smudged.ord: break
        a.dec(); b.inc()
      if diffAcc == smudged.ord: return (vert, y)
  raiseAssert("No reflection in the pattern!")

proc solve(patterns: openArray[Pattern]; smudged: static bool = false): int =
  patterns.items().mapIt(findAxis(it, smudged))
                  .mapIt((let (v, n) = it; n * [100, 1][v.ord])).sum()

proc main*(silent: bool = false) =
  let patterns = parse(INPUTF)

  block Part1:
    let p1 = solve(patterns)
    if not silent: echo p1 # 37561

  block Part2:
    let p2 = solve(patterns, smudged=true)
    if not silent: echo p2 # 31108

when isMainModule:
  main()
