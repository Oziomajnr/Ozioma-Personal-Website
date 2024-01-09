layout: post
title: "What I Learned from Solving 2023 Advent Of Code Puzzles"
date: 2024-01-09
---

<p align="center">  
 <img src="/img/advent_of_code_ozioma_stars.png" alt="Advent Of Code stars">  
</p>  

For the past 4 years, I have participated in the [Advent of Code](https://adventofcode.com/2023/about) event. In this event, you get to solve a series of **50 puzzles**, two every day, between December 1st and 25th. The puzzles can usually be solved using algorithm and data structure techniques.  
I enjoy participating in this event because it gives me an opportunity to learn new programming languages, tools, and techniques that I would usually not learn in my routine as a software engineer. I also get to engage with the community. I especially enjoy discussing solutions and ideas on [Reddit](https://www.reddit.com/r/adventofcode/), [Kotlin Language Advent of Code Slack channel](https://kotlinlang.slack.com/archives/C87V9MQFK), and with colleagues at work.

[Here is a Github Repo where I have shared my solutions.](https://github.com/Oziomajnr/AdventOfCodeSolutions/tree/main/solutions/src/2023)

In this post, I am going to share some interesting things I learned from solving the puzzles for 2023.  
I would categorize them into 2 groups.

1. Programming languages and tools.
2. Math and Geometry

## Programming languages and tools.

1. **Trying out new programming languages**:  My primary language for solving puzzles like this is Kotlin, but this year I decided to try out solving some of the early puzzles in TypeScript and Scala. This introduced me to some of the APIs and made me more comfortable with the syntax and APIs of both languages. This is very helpful because I have been using both languages at work recently.

2. [**Regular Expressions**](https://en.wikipedia.org/wiki/Regular_expression#): I am familiar with validating strings using Regex but I hardly use Regex to parse strings into an object. I found this useful when parsing the inputs to some of the puzzles; it also made my code less verbose because I did not have to manipulate the inputs using complicated [String and Collection transformation](https://kotlinlang.org/docs/collection-transformations.html#string-representation). I also [learned about look ahead, look behind, and look around regex](https://www.regular-expressions.info/lookaround.html) for the first time.

3. **Kotlin** [**DeepRecursiveFunction
   **](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/-deep-recursive-function/) : When solving algorithm and data structure problems, I often prefer using recursion instead of mutable collections, but with some problems, this often results in some deep recursive calls, and I end up with stack overflow exceptions. Sometimes, the functions are tail recursive and Kotlin has a [tailrec](https://kotlinlang.org/docs/functions.html#tail-recursive-functions) modifier that can be applied to a recursive function to enable the compiler to convert it to an iterative call so that you do not hit the stack limit. But most times, it is not easy/possible to make your functions tail recursive. To work around this, I usually use an explicit stack collection to store the state of my function, then push and pop from the stack instead of calling and returning from the recursive function. But while solving Advent of Code puzzlers this year, I discovered [DeepRecursiveFunction](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/-deep-recursive-function/) which allows you to write recursive functions that are placed on the heap instead of the call stack. This allowed me to do deep recursive calls without worrying about the limit of the stack space.

4. **Kotlin Notebooks for data manipulation and visualization**:  Some of the puzzles become considerably easier to understand and solve if you could visualize the data. I decided to try out Kotlin Notebooks for the first time to visualize some of the problems, particularly day [18](https://adventofcode.com/2023/day/18) and 24 after watching a presentation for [day 5 on the Kotlin YouTube channel](https://www.youtube.com/watch?v=gLuXUlc6CnE). Kotlin Notebook is very similar to Jupiter Notebook, so you can use it instead if you know how to write Kotlin but not Python. It still lacks some available libraries, but the [Kandy library](https://kotlin.github.io/kandy/welcome.html) had most of the functionalities I needed to visualize the data. For example, for day 18, visualizing the data (See image below) made me realize that it forms a closed polygon shape and that I could solve the problem by calculating the area of the polygon.

    <p align="center">  
     <img src="/img/advent_of_code_map.png" alt="Day 18 visualization">  
    </p>  

## Math And Geometry.

1. [LCM Application (Gear Problem)](https://en.wikipedia.org/wiki/Least_common_multiple#Gears_problem):  The problems on [day 8](https://adventofcode.com/2023/day/8) and [20](https://adventofcode.com/2023/day/20) can be simplified into running a simulation to figure out when multiple objects revolving at different speeds would eventually align. It turns out that this is a classic problem called the **Gear Problem** and it can be solved by calculating the lowest common multiple of the speeds of the object. The same principle can be applied in astronomy to figure out when 3 planets align ([Syzygy](https://en.wikipedia.org/wiki/Syzygy_%28astronomy%29)).

2. [Finding Points In a Polygon](https://en.wikipedia.org/wiki/Point_in_polygon#Ray_casting_algorithm): The second part of day 10 can be simplified into counting the number of points in a polygon. I learned about the ray casting algorithm, which involved counting the number of times a line from the point in any direction touches a point on the edge of the polygon. If it touches it an even number of times, then the point is outside of the polygon; if it touches it an odd number of times, then the point is in the polygon. A similar algorithm is applied in [SVG generation](https://en.wikipedia.org/wiki/Point_in_polygon#SVG).

    <p align="center">  
     <img src="/img/ray_casting.png" alt="Ray casting algorithm">  
    </p>

3. Area Of a Polygon ([Shoelace Formula](https://en.wikipedia.org/wiki/Shoelace_formula) and [Pick's  Theorem](https://en.wikipedia.org/wiki/Pick%27s_theorem))

4. [3D Equation of a line](https://www.youtube.com/watch?v=uXnWQIumLNA): The first part of day 24 involved finding the point of intersection of 2 lines on a 2d plane, which was not very difficult to solve with algebra. But for the second part, you had to find the point of intersection of multiple lines in a 3D space. After revisiting some 3D geometry tutorials, I figured out a solution using algebra.

Overall, it was a very great experience, even though it took more of my time than I would have loved to spare. The process of going from not having any idea on the solution to a problem to gradually figuring it out was very thrilling, and I look forward to learning more things next year.
