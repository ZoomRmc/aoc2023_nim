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
