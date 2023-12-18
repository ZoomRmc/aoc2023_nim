import std/[strscans]
import pkg/[slicerator/itermacros]

type
  Direction = enum R, D, L, U
  Point = tuple[y, x: int]

const
  INPUTF = "input/aoc18.txt"
  DirStr = "RDLU"
  DIRS: array[Direction, (int, int)] = [(0, 1), (1, 0), (0, -1), (-1, 0)]

func `+`[T: Point | (int, int)](a, b: T): Point = (y: a.y + b[0], x: a.x + b[1])
func `-`[T: Point | (int, int)](a, b: T): Point = (y: a[0] - b[0], x: a[1] - b[1])
func `*`(a: Point | (int, int); n: int): Point = (y: a[0] * n, x: a[1] * n)
func `[]`(map: seq[seq[bool]]; p: Point): bool = map[p.y][p.x]
func `[]=`[T](map: var seq[seq[T]]; p: Point; v: T) = map[p.y][p.x]=v
when false:
  func min(a, b: Point): Point = (y: min(a.y, b.y), x: min(a.x, b.x))
  func max(a, b: Point): Point = (y: max(a.y, b.y), x: max(a.x, b.x))
  proc `$`(b: bool): string = (if b: "#" else: ".")

proc parse(inputFName: string): seq[tuple[dir1, dir2: Direction, l1, l2: int]] =
  for line in lines(inputFName):
    let (_, dirc, l1, num) = line.scanTuple("$c $i (#$h)")
    let dir1 = Direction(DirStr.find(dirc))
    let dir2 = Direction(num.uint and 3u)
    let l2 = num shr 4
    result.add((dir1, dir2, l1, l2))

func polygonArea(vs: openArray[Point]): int =
  # The Shoelace formula to compute the area of a polygon
  var area = 0
  for i in 0..<vs.len-1:
    area.inc(vs[i].x * vs[i+1].y - vs[i+1].x * vs[i].y)
  area.inc(vs[^1].x * vs[0].y - vs[0].x * vs[^1].y)
  (abs(area) div 2)

func areaFromInstructions(steps: openArray[(Direction, int)]): int =
  # Iterate through the steps and calculate vertices
  var vertices: seq[Point] = @[(0, 0)]
  for (dir, l) in steps:
    let lastVertex = vertices[^1]
    vertices.add(lastVertex + (DIRS[dir] * l))
  let
    area = polygonArea(vertices)
    borders = steps.items().foldIt(0, acc + it[1])
    inside = area - borders div 2 + 1 # Pick's theorem
  (borders + inside)

proc main*(silent: bool = false) =
  let (inputP1, inputP2) = block:
    let input = parse(INPUTF)
    var i1, i2: seq[(Direction, int)]
    for (d1, d2, l1, l2) in input:
      i1.add (d1, l1)
      i2.add (d2, l2)
    (i1, i2)

  let p1 = areaFromInstructions(inputP1) # 53844
  if not silent: echo p1
  let p2 = areaFromInstructions(inputP2) # 42708339569950
  if not silent: echo p2

when isMainModule:
  main()


when false:
  func calcSize(steps: openArray[(Direction, int)]): tuple[start: Point, w, h: int] =
    var leftOff, rightOff, curr: Point
    for (dir, l) in steps:
      curr = curr + (DIRS[dir] * l)
      leftOff = min(curr, leftOff)
      rightOff = max(curr, rightOff)
    let (h, w) = rightOff - leftOff
    ((0, 0) - leftOff, w+1, h+1)

  proc countInside(map: Map): int =
    var total = 0
    for row in map:
      var inside, prev = false
      for val in row:
        if inside: total.inc()
        inside = inside xor (val and not prev)
        prev = val
    total
