import std/[tables, parseutils, strscans, pegs]
from std/strutils import find
import pkg/[slicerator/itermacros]

type
  Kind = enum X, M, A, S
  Filter = tuple[k: Kind, num: int, dst: string]
  Rule = tuple[filters: seq[Filter], dst: string]
  Rules = Table[string, Rule]
  Thing = array[Kind, int]
  Span = array[Kind, Slice[int]]

const
  INPUTF = "input/aoc19.txt"
  KindStr = "xmas"

let inputpeg = """
rule <- name filters
filters <- '{' (filter ',')* name '}'
filter <- kind cmp num ':' name
name <- [a-z]+ / [AR]
cmp <- '<' / '>'
kind <- [xmas]
num <- \d+
""".peg

proc parse(inputFName: string): (Rules, seq[Thing]) =
  var
    rules: Rules
    parsingRules = true
    src: string
    cmp: int
    f: Filter
    rule: Rule
    things: seq[Thing]
  for line in lines(inputFName):
    if parsingRules:
      if line == "":
        if parsingRules: parsingRules = false; continue
        else: break
      let parse = inputpeg.eventParser:
        pkNonTerminal:
          enter:
            if p.nt.name == "filters": src = f.dst
          leave:
            if length > 0:
              case p.nt.name
              of "num":
                try:
                  discard s.parseInt(f.num, start)
                  f.num = f.num * cmp
                except ValueError: raiseAssert("Malformed input!")
              of "cmp": cmp = if s[start] == '<': -1 else: 1
              of "kind": f.k = Kind(KindStr.find(s[start]))
              of "name": f.dst = s.substr(start, start+length-1)
              of "filter": rule.filters.add(f)
              of "filters":
                rule.dst = f.dst
                rules[src] = rule
                rule.filters.setLen(0)
              else: discard
      discard parse(line)
    else:
      let (succ, x, m, a, s) = line.scanTuple("{x=$i,m=$i,a=$i,s=$i}")
      if succ: things.add([x,m,a,s]) else: raiseAssert("Malformed input!")
  (rules, things)

func solveP1(rules: Rules; things: openArray[Thing]): int =
  var total = 0
  for thing in things:
    var curRule = "in"
    while true:
      case curRule
      of "A": total.inc(thing.items().sum()); break
      of "R": break
      else:
        let r = rules[curRule]
        block Inner:
          for f in r.filters:
            let val = thing[f.k]
            let res = if f.num < 0: val < abs(f.num) else: val > f.num
            if res: curRule = f.dst; break Inner
          curRule = r.dst
  total

func solveP2(rules: Rules): int =
  ## Assumes succeeding filter for the same kind of range
  ## never contradicts the previous, i.e. the next span[f.k]
  ## always overlaps with the current one, iteratively trimming the range
  ## but always retaining its validity (s.b >= s.a).
  var
    spans = @[([1..4000, 1..4000, 1..4000, 1..4000].Span, "in")]
    accepted: seq[Span] = @[]
  while spans.len > 0:
    var (span, curRule) = spans.pop()
    case curRule
    of "A": accepted.add(span); continue
    of "R": continue
    else:
      let r = rules[curRule]
      for f in r.filters:
        let s = span[f.k]
        let (rangeOk, rangeNext) = if f.num < 0:
            ((s.a..abs(f.num) - 1), (abs(f.num)..s.b))
          else:
            ((f.num + 1..s.b), (s.a..f.num))
        var passed = span
        passed[f.k] = rangeOk
        spans.add((passed, f.dst))
        span[f.k] = rangeNext
      spans.add((span, r.dst))
  accepted.items().mapIt(
      it.items().mapIt(it.b - it.a + 1).product()
    ).sum()

proc main*(silent: bool = false) =
  let (rules, things) = parse(INPUTF)

  block Part1:
   let p1 = solveP1(rules, things)
   if not silent: echo p1 # 575412

  block Part2:
   let p2 = solveP2(rules)
   if not silent: echo p2 # 126107942006821

when isMainModule:
  main()
