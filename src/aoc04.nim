import std/[parseutils]
import pkg/slicerator/itermacros

const INPUTF = "input/aoc04.txt"

type Card = tuple[wins: set[int8], nums: set[int8]]

proc main*(silent: bool = false) =
  var cards: seq[Card]
  for line in lines(INPUTF):
    var
      card: Card
      inPre = true
      i = line.skipUntil(':', 4) + 5 # "Card X:"
    while i < line.len:
      i.inc line.skipWhitespace(i)
      if line[i] == '|': inPre = false; i.inc line.skipWhitespace(i+1)
      var n: int = 0
      i.inc line.parseInt(n, i)
      if inPre: card.wins.incl(n.int8) else: card.nums.incl(n.int8)
    cards.add card

  block Part1:
    let p1 = cards.items.mapIt(card(it.wins * it.nums))
                  .mapIt(if it > 0: 1 shl (it - 1) else: 0)
                  .foldIt(0, acc + it)
    if not silent: echo p1 # 20107

  block Part2:
    var copies = newSeq[int](cards.len)
    for cardIdx, card in cards.pairs():
      let wins = card(card.wins * card.nums)
      for i in cardIdx ..< cardIdx + wins:
        copies[i+1].inc(copies[cardIdx] + 1)
    let p2 = copies.items.foldIt(0, acc + it + 1)
    if not silent: echo p2 # 8172507

when isMainModule:
  main()
