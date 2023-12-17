import std/[tables, sets, heapqueue]

type
  Point = tuple[y, x: int]
  Map = seq[seq[int]]
  Cardinality = enum U = -1, N, E, S, W

const
  INPUTF = "input/aoc17.txt"
  DIRS: array[Cardinality, (int, int)] = [(0, 0), (-1, 0), (0, 1), (1, 0), (0, -1)]

when false:
  proc `$`(row: seq[int]): string = (for n in row: result.add $n)
  proc `$`(p: Point): string = result.addf("($1, $2)", p.y, p.x)

func `+`[T: Point | (int, int)](a, b: T): Point = (y: a.y + b[0], x: a.x + b[1])
func `*`[T: Point | (int, int)](a, b: T): Point = (y: a[0] * b[0], x: a[1] * b[1])
func `[]`(map: Map; p: Point): int = map[p.y][p.x]

proc parse(inputFName: string): Map =
  var map: Map
  for line in lines(inputFName):
    var row: seq[int]
    for c in line:
      row.add (c.ord - '0'.ord)
    map.add row
  map

func inside(p: Point; w, h: Natural): bool =
  p.y in 0..<h and p.x in 0..<w

proc solve(map: Map; mindist, maxdist: int): int =
  var
    frontier = [(0, default(Point), U)].toHeapQueue()
    seen: HashSet[(Point, Cardinality)]
    costs: Table[(Point, Cardinality), int]
  let (w, h) = (map[0].len, map.len)
  while frontier.len > 0:
    let (cost, pt, card) = frontier.pop()
    if pt == (y: h-1, x: w-1): return cost
    if seen.contains((pt, card)): continue
    seen.incl((pt, card))
    for dir in [E, S, N, W]:
      if card in [dir, Cardinality((dir.ord + 2) mod 4)]:
        continue
      var costDelta = 0
      for stride in 1..maxdist:
        let newPt = pt + (DIRS[dir] * (stride, stride))
        if newPt.inside(w, h):
          costDelta.inc(map[newPt])
          if stride < mindist: continue
          let newCost = cost + costDelta
          costs.withValue((newPt, dir), cost):
            if newCost > cost[]: continue
          costs[(newPt, dir)] = newCost
          frontier.push((newCost, newPt, dir))
  raiseAssert("Goal never reached") # frontier is exhausted

proc main*(silent: bool = false) =
  let map = parse(INPUTF)

  let p1 = solve(map, 1, 3)
  if not silent: echo p1

  let p2 = solve(map, 4, 10)
  if not silent: echo p2

when isMainModule:
  main()
