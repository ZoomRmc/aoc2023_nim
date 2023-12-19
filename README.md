# aoc2023_nim
AoC 2023 in Nim

**[Join Nim-AoC Matrix room](https://matrix.to/#/%23nim-aoc%3Amatrix.org?via=matrix.org&via=envs.net&via=t2bot.io)**

## Previous years:
 - [2022](https://github.com/ZoomRmc/aoc2022_nim)
 - [2021](https://github.com/ZoomRmc/aoc2021_nim)
 - [2020](https://github.com/ZoomRmc/aoc2020_nim)

## General notes
This year is marked with my attempt of trading the only third-party dependency used so far - [zero_functional](https://github.com/zero-functional/zero-functional) - for a new and shiny[^shiny] [slicerator/itermacros](https://github.com/beef331/slicerator) by Elegantbeef. Let's see how far it will serve me.

What I'm trying to stick to while writing the solutions, in order of importance:
 - Intelligible implementation logic, clear data flow.
 - Brevity must not hurt readability.
 - Short functions with evident behaviour, hopefully as "strict" as reasonable.
 - Keep the solutions for both parts independent of each other. In other words, p2 has to be solvable from parsed input, not using state from p1.
 - Use more suitable/interesting data structures available. It's tempting to solve *everything* with Hash Tables, though with each year it gets harder to resist and be done with it all.
 - Explore standard library before jumping to external libs.

## Notes on specific days

> [!WARNING]
> **Spoilers below!**

### Day 19
The parsing part was fun enough I hoped the remaining thing would be easy. You can argue it was, if you understand there's an important implicit feature of the specs for Part2.

<details>
<summary>Day 19 spoiler</summary>

You start with the set of spans (`Slice[int]`) 1..4000 for each kind of rating in the stack. You pop the set, iteratively splitting it for each filtering rule, adding both results of the split to a stack. So, `[1..4000, ... ]` split on `x<777:next` results in two spans: `[1..776, ... ]` and `[777..4000, ...]`, the former going on the stack with its destination rule `next` and the latter is split on the succeeding filter for the same rule, or goes on to the stack unconditionally for the last destination in the rule. You repeat popping and splitting until all sets of spans end up accepted or dumped in the process (rejected).

For this process to work, you have to assume each succeeding filter for the same kind of span never contradicts the previous, i.e. the next `span[f.k]` *always overlaps* with the current one. Thus, the range gets trimmed iteratively but always remains valid (slice.b >= slice.a). Otherwise the accepted sets of rating spans could be partially invalid or (probably) even overlapping with each other, making it impossible to just sum up their products.
</details>


### Day 18

### Day 17

### Day 16
<details>
<summary>Day 16 spoiler</summary>

The only catch is cycles created by splits. With them, unlike with mirrors, two different enter points can create one exit point. Keep track of splits getting activated and you're all *set*.
</details>

### Day 15


### Day 14

### Day 13
<details>
<summary>Day 13 spoiler</summary>

It's not totally obvious that you'll need the bit operations from Part 1, but they simplify the main loop significantly.

This time I also got lazy and sacrificed a bit of memory for easier scanning through the 2D array, and rotate the matrix in its `seq[seq[bool]]` form, rather then the bits.
</details>

### Day 12

### Day 11
Main lesson: don't be smart, parse when you parse and do the rest later.

### Day 10

### Day 9

### Day 8

### Day 7
Finally a day without the parsing chore!
<details>
<summary>Day 7 spoiler</summary>

Few things are as satisfying as carefully and neatly structuring your code and getting correct results on the first run! One of such things is a task with clear requirements, no hidden gotchas and sudden twists.

Nim's lack of built-in pattern matching hurts a little, but not so much, considering if-expressions are not too bad to write. Just don't forget to be exhaustive and you can avoid debugging altogether!
</details>

### Day 6
The easiest day so far, so time to try something new. After years of avoiding it, I'm finally beginning to comprehend how the [`scanp`](https://nim-lang.org/docs/strscans.html#the-scanp-macro) macro is supposed to work!

<details>
<summary>Day 6 spoiler</summary>

Both iterative and analytical solution provided and in this particular case the latter is just an unnecessary complication.
</details>

### Day 5

### Day 4
<details>
<summary>The tougher part is not parsing, but choosing the right parsing tool.</summary>

It happened to be `parseutils` for this one for me. Writing dumb procedural code makes it easy to come to the right answer, and then you waste even more time compressing it all into something a bit more elegant, trimming those numerous consecutive loops. One could say it's all just spoiling of beautiful simple instructions with conditional branching!
</details>

### Day 3
<details>
<summary>Day 3 spoiler</summary>
One of the rare cases when using Maps (`tables`) for working with grids makes more sense, due to general sparsity of the data.
</details>

### Day 2
<details>
<summary>Day 2 spoiler</summary>

Learning Nim pegs pays off, though I wouldn't call actually using them neither quick nor simple.
</details>

### Day 1

[^shiny]: Means *probably buggy still*.
