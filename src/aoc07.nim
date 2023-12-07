import std/[parseutils, algorithm]
import pkg/slicerator/itermacros

const INPUTF = "input/aoc07.txt"
const CARDSTR = "23456789TJQKA"

type
  Card = enum
    c2 = "2", c3 = "3", c4 = "4", c5 = "5", c6 = "6", c7 = "7", c8 = "8",
    c9 = "9", cT = "T", cJ = "J", cQ = "Q", cK = "K", cA = "A"
  Kind = enum kHigh, kPair, kTwoPairs, kThree, kFullHouse, kFour, kFive
  Hand = object
    cards: array[5, Card]
    bid: int
    kind: Kind
    kindWJokers: Kind

func toCard(c: char): Card =
  for i, knd in CARDSTR: (if c == knd: return Card(i))
  raise newException(ValueError, "Wrong character")

func kind(hand: array[5, Card]; wJokers = false): (Kind, Kind) =
  var
    counter: array[Card, int8]
    cardSet: set[Card] = {}
    counts: set[int8] = {}
  for card in hand: counter[card].inc(); cardSet.incl(card)
  for n in counter:
    if n > 0: counts.incl(n.int8)
  let kind = case cardSet.card()
    of 1: kFive
    of 2:
      if   counts == {1.int8,4}: kFour
      elif counts == {3.int8,2}: kFullHouse
      else: raise newException(Defect, "bug")
    of 3:
      if   counts == {3.int8,1,1}: kThree
      elif counts == {2.int8,2,1}: kTwoPairs
      else: raise newException(Defect, "bug")
    of 4: kPair
    of 5: kHigh
    else: raise newException(Defect, "bug")
  let kindWJokers = block:
    let jokers = counter[cJ]
    if jokers > 0:
      case kind
      of kFive, kFour, kFullHouse: kFive
      of kThree: kFour
      of kTwoPairs:
        if jokers == 1: kFullHouse
        else: kFour # one pair of jokers
      of kPair: kThree
      of kHigh: kPair
    else: kind
  (kind, kindWJokers)

func parseHand(s: openArray[char]; bid = 0): Hand =
  var cards: array[5, Card]
  for i in 0..<5:
    cards[i] = toCard(s[i])
  let (kind, kindWJokers) = cards.kind()
  Hand(cards: cards, bid: bid, kind: kind, kindWJokers: kindWJokers)

proc parseInput(inputFName: string): seq[Hand] =
  var bid = 0
  for line in lines(inputFName):
   discard line.toOpenArray(6, line.high).parseInt(bid)
   result.add line.toOpenArray(0, 4).parseHand(bid)

proc `<`(a, b: Hand): bool =
  if a.kind == b.kind:
    for i in 0..4:
      if a.cards[i] == b.cards[i]: continue
      return a.cards[i] < b.cards[i]
    raise newException(ValueError, "Equal hands are impossible")
  else: a.kind < b.kind

proc cmpWJokers(a, b: Hand): int =
  let (ak, bk) = (a.kindWJokers, b.kindWJokers)
  if ak > bk: 1
  elif ak == bk:
    var cmp = 0
    for i in 0..4:
      let (ac, bc) = (a.cards[i], b.cards[i])
      if ac == bc: continue
      elif ac == cJ: cmp = -1; break
      elif bc == cJ: cmp = 1; break
      else: cmp = cmp(ac, bc); break
    cmp
  else: -1

func winnings(sortedHands: openArray[Hand]): int =
  sortedHands.pairs().mapIt((it[0]+1) * it[1].bid).sum()

proc main*(silent: bool = false) =
  let input = parseInput(INPUTF)

  block Part1:
    let p1 = input.sorted().winnings()
    if not silent: echo p1 # 25391031

  block Part2:
    let p2 = input.sorted(cmpWJokers).winnings()
    if not silent: echo p2 # 25391031

when isMainModule:
  main()
