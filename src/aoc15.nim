import std/[lists]
import pkg/slicerator/itermacros
from std/strutils import split

const
  INPUTF = "input/aoc15.txt"

type
  Boxes = array[byte, SinglyLinkedList[(string, int)]]

proc `[]`[T, U: Ordinal](s: openArray[char]; x: HSlice[T, U]): string =
  let L = x.b - x.a + 1
  result = newString(L)
  for i in 0..<L: result[i] = s[i + x.a]

proc parse(inputFName: string): seq[string] =
  for line in lines(inputFName):
    for s in line.split(','):
      result.add s

func hash(s: openArray[char]): byte =
  var b = 0
  for c in s:
    b.inc c.ord
    b = (b * 17) mod 256
  byte b

proc process(boxes: var Boxes; cmd: openArray[char]) =
  let (label, n) = if cmd[^1] == '-':
      (cmd[0..cmd.len - 2], -1)
    else:
      (cmd[0..cmd.len - 3], (cmd[^1].ord - '0'.ord))
  let box = label.hash()
  if n < 0:
    for lens in boxes[box].nodes():
      if lens.value[0] == label:
        discard boxes[box].remove(lens)
        break
  else:
    var found = false
    for lens in boxes[box].mitems():
      if lens[0] == label:
        lens[1] = n
        found = true
        break
    if not found:
      boxes[box].add (label, n)

func power(box: SinglyLinkedList[(string, int)]; boxn: byte): int =
  for (slot, lens) in box.items().enumerate():
    result.inc((boxn.int + 1) * (slot + 1) * lens[1])

proc main*(silent: bool = false) =
  let input = parse(INPUTF)

  block Part1:
    var p1 = input.items().mapIt(int it.hash()).sum()
    if not silent: echo p1 # 513214

  block Part2:
    var boxes: Boxes
    for cmd in input: boxes.process(cmd)
    var p2 = 0
    for (i, box) in boxes.pairs():
      p2.inc box.power(i)
    if not silent: echo p2 # 258826

when isMainModule:
  main()
