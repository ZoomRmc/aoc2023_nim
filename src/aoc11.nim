import pkg/[slicerator/itermacros]

const INPUTF = "input/aoc11.txt"

type Point = tuple[y, x: int]

when false: # for later grepping
  func `$`(b: bool): string = [".", "#"][b.ord]
  func `$`(row: seq[bool]): string =
    var s = newString(row.len)
    for i, b in row: s[i] = ['.', '#'][b.ord]
    s
  func `$`(map: seq[seq[bool]]): string =
    for row in map: result.add $row; result.add '\n'
  func manhattanDistance(a, b: (int, int)): int =
    abs(a[0] - b[0]) + abs(a[1] - b[1])

proc parse(inputFName: string): seq[seq[bool]] =
  lines(inputFName).mapIt(
      it.items.mapIt(it == '#').collect()
    ).collect()

func manhattanDistance(a, b: (int, int); emptyYs, emptyXs: set[int16];
                        expFactor = 2): int =
  let
    (x1, x2) = if a[1] < b[1]: (a[1], b[1]) else: (b[1], a[1])
    (y1, y2) = if a[0] < b[0]: (a[0], b[0]) else: (b[0], a[0])
  var distX, distY = 0
  for y in y1 ..< y2:
    distY.inc(if y.int16 in emptyYs: expFactor else: 1)
  for x in x1 ..< x2:
    distX.inc(if x.int16 in emptyXs: expFactor else: 1)
  distX + distY

iterator pairCombs[T](s: openArray[T]): (T, T) =
  for i in 0..<s.len:
    for j in i+1..<s.len:
      yield (s[i], s[j])

proc main*(silent: bool = false) =
  let map = parse(INPUTF)
  var galaxies: seq[Point]
  for y, row in map.pairs():
    for x, b in row.pairs():
      if b: galaxies.add (y, x)

  var emptyRows, emptyCols: set[int16]
  for y, l in map.pairs():
    if l.items.allIt(it == false):
      emptyRows.incl y.int16
  for x in 0..<map[0].len:
    if (0..<map.len).items().allIt(map[it][x] == false):
      emptyCols.incl x.int16

  proc solve(factor: int): int =
    for p in galaxies.pairCombs():
      let dist = manhattanDistance(p[0], p[1], emptyRows, emptyCols, factor)
      result.inc(dist)

  block Part1:
    let p1 = solve(2)
    if not silent: echo p1 # 10154062

  block Part2:
    let p2 = solve(1000_000)
    if not silent: echo p2 # 553083047914

when isMainModule:
  main()
