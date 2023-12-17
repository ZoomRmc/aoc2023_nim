import std/[tables, sets]

const
  INPUTF = "input/aoc16.txt"
  CHARSET = r"./\|-"

type
  Tile = enum tE, tR, tL, tV, tH
  Direction = enum R, L, U, D
  Point = tuple[y, x: int]
  Map = seq[seq[Tile]]
  State = tuple[d: Direction, p: Point]

func toTile(c: char): Tile =
  for i, knd in CHARSET: (if c == knd: return Tile(i))
  raise newException(ValueError, "Wrong character")

when false:
  proc `$`(row: seq[Tile]): string =
    for c in row: result.add Charset[ord(c)]
  proc `$`(p: Point): string = result.addf("($1, $2)", p.y, p.x)
  proc `[]`[T, U: Ordinal](s: openArray[char]; x: HSlice[T, U]): string =
    let L = x.b - x.a + 1
    result = newString(L)
    for i in 0..<L: result[i] = s[i + x.a]

func `+`(a: Point; b: Point | (int, int)): Point = (y: a.y+b[0], x: a.x+b[1])

func `[]`(map: seq[seq[Tile]]; p: Point ): Tile =
  map[p.y][p.x]

proc parse(inputFName: string): Map =
  var map: Map
  for line in lines(inputFName):
    var row: seq[Tile]
    for c in line:
      row.add toTile(c)
    map.add row
  map

proc next(s: var State; w, h: Natural): bool =
  var oob = false
  case s.d
    of R:
      if s.p.x < w-1: s.p.x.inc() else: oob = true
    of L:
      if s.p.x > 0: s.p.x.dec() else: oob = true
    of D:
      if s.p.y < h-1: s.p.y.inc() else: oob = true
    of U:
      if s.p.y > 0: s.p.y.dec() else: oob = true
  not oob

func inside(p: Point; w, h: Natural): bool =
  p.y in 0..<h and p.x in 0..<w

func energized(map: Map; init: State = (R, (0,0))): int =
  let (w, h) = (Natural(map[0].len), Natural(map.len))
  var
    stack: seq[State] = @[init]
    passed: CountTable[Point]
    usedSplits: HashSet[Point]

  while stack.len > 0:
    var state = stack.pop()
    passed.inc(state.p)
    case map[state.p]
    of tE:
      while state.next(w, h):
        if map[state.p] != tE:
          stack.add state
          break
        passed.inc(state.p)
    of tR:
      let (d, delta) = case state.d
        of R: (U, (-1, 0))
        of L: (D, (1, 0))
        of U: (R, (0, 1))
        of D: (L, (0, -1))
      let p = state.p + delta
      if p.inside(w, h):
        stack.add (d: d, p: p)
    of tL:
      let (d, delta) = case state.d
        of R: (D, (1, 0))
        of L: (U, (-1, 0))
        of U: (L, (0, -1))
        of D: (R, (0, 1))
      let p = state.p + delta
      if p.inside(w, h):
        stack.add (d: d, p: p)
    of tV:
      if state.d in {D, U}:
        if state.next(w, h):
          stack.add state
      elif not usedSplits.containsOrIncl(state.p):
        let (exitU, exitD) = (state.p + (-1, 0), state.p + (1, 0))
        if exitU.inside(w, h):
          stack.add (d: U, p: exitU)
        if exitD.inside(w, h):
          stack.add (d: D, p: exitD)
    of tH:
      if state.d in {R, L}:
        if state.next(w, h):
          stack.add state
      elif not usedSplits.containsOrIncl(state.p):
        let (exitL, exitR) = (state.p + (0, -1), state.p + (0, 1))
        if exitL.inside(w, h):
          stack.add (d: L, p: exitL)
        if exitR.inside(w, h):
          stack.add (d: R, p: exitR)
  passed.len()

proc main*(silent: bool = false) =
  let map = parse(INPUTF)

  block Part1:
    let p1 = map.energized()
    echo p1 # 7608

  block Part2:
    let inits = block:
      let (w, h) = (Natural(map[0].len), Natural(map.len))
      var inits: seq[State]
      for x in 0..<w:
        inits.add (D, (0, x))
        inits.add (U, (h-1, x))
      for y in 0..<h:
        inits.add (R, (y, 0))
        inits.add (L, (y, w-1))
      inits
    var p2 = 0
    for s in inits:
      p2 = max(p2, map.energized(s))
    if not silent: echo p2 # 8221

when isMainModule:
  main()
