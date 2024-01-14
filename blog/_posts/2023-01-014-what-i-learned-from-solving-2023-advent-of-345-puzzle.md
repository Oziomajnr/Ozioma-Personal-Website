---
layout: post
title: "Test rss with new post"
date: 2024-01-14
---

<p align="center">  
 <img src="/img/advent_of_code_ozioma_stars.png" alt="Advent Of Code stars">  
</p>  

For the past 4 years, I have participated in the [Advent of Code](https://adventofcode.com/2023/about) event. 
During this annual challenge, participants solve a series of **50 puzzles**, two each day, from December 1st to 25th. 
The puzzles primarily involve algorithmic and data structure techniques.  
Participating in this event provides an opportunity to explore new programming languages, tools, and techniques that I might not have time to try out in my regular work routine as a software engineer. I also get to engage with the community, particularly on [Reddit](https://www.reddit.com/r/adventofcode/) and the [Kotlin Language Advent of Code Slack channel](https://kotlinlang.slack.com/archives/C87V9MQFK).

[Here is a link to my GitHub Repo where I've shared my solutions.](https://github.com/Oziomajnr/AdventOfCodeSolutions/tree/main/solutions/src/2023)

In this post, I will share some interesting things I learned from solving the puzzles for 2023, categorized into two groups:

1. Programming languages and tools.
2. Math and Geometry

## Programming languages and tools.

1. **Trying out new programming languages**:  While Kotlin is my go-to language for solving puzzles, this year, I decided to tackle some early puzzles in TypeScript and Scala. This exposed me to new APIs and enhanced my familiarity with the syntax and features of both languages, proving beneficial as I've been using them more frequently at work.

2. [**Regular Expressions**](https://en.wikipedia.org/wiki/Regular_expression#): While I am familiar with validating strings using Regex, using it to parse strings into objects was a less common practice for me. I found this useful when parsing the inputs to some of the puzzles; it also made my code less verbose eliminating the need to manipulate the inputs using complicated [String and Collection transformation](https://kotlinlang.org/docs/collection-transformations.html#string-representation). I also [learned about look ahead, look behind, and look around regex](https://www.regular-expressions.info/lookaround.html) for the first time.

3. **Kotlin** [**DeepRecursiveFunction**](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/-deep-recursive-function/) : When solving algorithm and data structure problems, I often prefer using recursion instead of mutable collections, but with some problems, this often results in deep recursive calls leading to stack overflow exceptions. Sometimes, the functions are tail recursive and Kotlin has a [tailrec](https://kotlinlang.org/docs/functions.html#tail-recursive-functions) modifier that can be applied to a recursive function which enables the compiler to convert it the function to an iterative function. But most times, it is not easy/possible to make your functions tail recursive. To work around this, I usually use an explicit stack collection to store the state of my function and then push and pop from the stack instead of calling and returning from the recursive function. While solving Advent of Code puzzles this year, I discovered [DeepRecursiveFunction](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/-deep-recursive-function/) which allows you to write recursive functions that are placed on the heap instead of the call stack. This allowed me to do deep recursive calls without worrying about the limit of the stack space.

4. [**Kotlin Notebooks**](https://plugins.jetbrains.com/plugin/16340-kotlin-notebook) **for data manipulation and visualization**:  Some of the puzzles become considerably easier to understand and solve if you could visualize the data. I decided to try out Kotlin Notebooks for the first time to visualize some of the problems, particularly day [18](https://adventofcode.com/2023/day/18) and 24 after watching a presentation for [day 5 on the Kotlin YouTube channel](https://www.youtube.com/watch?v=gLuXUlc6CnE). While Kotlin Notebook is similar to Jupiter Notebook, it's a good alternative for those comfortable with Kotlin over Python. Although it lacks some libraries, the [Kandy library](https://kotlin.github.io/kandy/welcome.html) had most of the functionalities I needed to visualize the data. For example, for day 18, visualizing the data (See image below) made me realize that it forms a closed polygon shape and that I could solve the problem by calculating the area of the polygon.

    <p align="center">  
     <img src="/img/advent_of_code_map.png" alt="Day 18 visualization">  
    </p>  

## Math And Geometry.

1. [**LCM Application (Gear Problem)**](https://en.wikipedia.org/wiki/Least_common_multiple#Gears_problem):  The problems on [day 8](https://adventofcode.com/2023/day/8) and [20](https://adventofcode.com/2023/day/20) can be simplified into running a simulation to figure out when multiple objects revolving at different speeds would eventually align. It turns out that this is a classic problem called the **Gear Problem**, and it can be solved by calculating the lowest common multiple of the speeds of the object. The same principle can be applied in astronomy to figure out when 3 planets align ([Syzygy](https://en.wikipedia.org/wiki/Syzygy_%28astronomy%29)). I actually don't care!

2. [**Finding Points In a Polygon**](https://en.wikipedia.org/wiki/Point_in_polygon#Ray_casting_algorithm):  Day 10's second part involves counting points in a polygon. I learned about the ray casting algorithm, which counts the times a line from a point touches the polygon's edge. If it touches an even number of times, the point is outside the polygon; if odd, it's inside. A similar algorithm is used in [SVG generation](https://en.wikipedia.org/wiki/Point_in_polygon#SVG).

    <p align="center" >  
     <img  src="/img/ray_casting.png" alt="Ray casting algorithm">  
    </p>

3. **Area Of a Polygon** ([**Shoelace Formula**](https://en.wikipedia.org/wiki/Shoelace_formula) and [Pick's  Theorem](https://en.wikipedia.org/wiki/Pick%27s_theorem))

4. [**3D Geometry**](https://www.youtube.com/watch?v=uXnWQIumLNA): The first part of day 24 involved finding the point of intersection of 2 lines on a 2d plane, which was not very difficult to solve using linear algebra. But for the second part, you had to find the point of intersection of multiple lines in a 3D space. After revisiting some 3D geometry tutorials and how to represent a straight line in 3D, I could figure out a solution using algebra.

Overall, it was a very great experience, even though it took more of my time than I would have loved to spare. The process of going from having no idea about the solution to a problem to gradually figuring it out was very thrilling. I look forward to repeating the experience next year.
