## Snippet Testing

#include <iostream>

int main()
{
    // Replace this line with the snippet of code you'd like to compile

    return 0;
}

Warning
Don’t use multi-line comments inside other multi-line comments. Wrapping single-line comments inside a multi-line comment is okay.


Single-line comments
~~~
cpp
std::cout << "Hello world!"; // Everything from here to the end of the line is ignored
~~~

```cpp
std::cout << "Hello world!\n"; // std::cout lives in the iostream library
std::cout << "It is very nice to meet you!\n"; // these comments make the code hard to read
std::cout << "Yeah!\n"; // especially when lines are different lengths
```

```cpp
std::cout << "Hello world!\n";                 // std::cout lives in the iostream library
std::cout << "It is very nice to meet you!\n"; // this is much easier to read
std::cout << "Yeah!\n";                        // don't you think so?
```

```cpp
// std::cout lives in the iostream library
std::cout << "Hello world!\n";

// this is much easier to read
std::cout << "It is very nice to meet you!\n";

// don't you think so?
std::cout << "Yeah!\n";
```

The `/*` and `*/` pair of symbols denotes a C-style multi-line comment. Everything in between the symbols is ignored.

```cpp
/* This is a multi-line comment.
   This line will be ignored.
   So will this one. */
```

Since everything between the symbols is ignored, you will sometimes see programmers “beautify” their multi-line comments:

```cpp
/* This is a multi-line comment.
 * the matching asterisks to the left
 * can make this easier to read
 */
```

Multi-line style comments can not be nested. Consequently, the following will have unexpected results:

```cpp
/* This is a multi-line /* comment */ this is not inside the comment */
// The above comment ends at the first */, not the second */
```

Warning

Don’t use multi-line comments inside other multi-line comments. Wrapping single-line comments inside a multi-line comment is okay.

First, for a given library, program, or function, comments are best used to describe _what_ the library

```cpp
// This program calculates the student's final grade based on their test and homework scores.
```

```cpp
// This function uses Newton's method to approximate the root of a given equation.
```

```cpp
// The following lines generate a random item based on rarity, level, and a weight factor.
```

Second, _within_ a library, program, or function described above, comments can be used to describe _how_ the code is going to accomplish its goal.

```cpp
/* To calculate the final grade, we sum all the weighted midterm and homework scores
    and then divide by the number of scores to assign a percentage, which is
    used to calculate a letter grade. */
```

```cpp
// To generate a random item, we're going to do the following:
// 1) Put all of the items of the desired rarity on a list
// 2) Calculate a probability for each item based on level and weight factor
// 3) Choose a random number
// 4) Figure out which item that random number corresponds to
// 5) Return the appropriate item
```

Bad comment:

```cpp
// Set sight range to 0
sight = 0;
```

Good comment:

```cpp
// The player just drank a potion of blindness and can not see anything
sight = 0;
```

Bad comment:

```cpp
// Calculate the cost of the items
cost = quantity * 2 * storePrice;
```

```cpp
// We need to multiply quantity by 2 here because they are bought in pairs
cost = quantity * 2 * storePrice;
```

```cpp
// We decided to use a linked list instead of an array because
// arrays do insertion too slowly.
```

```cpp
// We're going to use Newton's method to find the root of a number because
// there is no determ
```

Finally, comments should be written in a way that makes sense to someone who has no idea what the code does. It is often the case that a programmer will say “It’s obvious what this does! There’s no way I’ll forget about this”

Best practice

Comment your code liberally, and write your comments as if speaking to someone who has no idea what the code does. Don’t assume you’ll remember why you made specific choices.

Uncommented out:

std::cout << 1;
```

Commented out:

```cpp
//    std::cout << 1;
```

Uncommented out:

```cpp
std::cout << 1;
std::cout << 2;
std::cout << 3;
```

Commented out:

```cpp
//    std::cout << 1;
//    std::cout << 2;
//    std::cout << 3;
```

or

```cpp
/*
    std::cout << 1;
    std::cout << 2;
    std::cout << 3;
*/
```

Commenting out the code that won’t compile will allow the program to compile so you can run it. ommenting out the broken code will ensure the broken code doesn’t execute and cause problems until you can fix it.If you comment out one or more lines of code, and your program starts working as expected (or stops crashing), odds are whatever you last commented out was part of the problem. Instead of just deleting the original code, you can comment it out and leave it there for reference until you’re sure your new code works properly.

For Visual Studio users

You can comment or uncomment a selection via Edit menu > Advanced > Comment Selection (or Uncomment Selection).

Tip

If you always use single line comments for your normal comments, then you can always use multi-line comments to comment out your code without conflict. If you use multi-line comments to document your code, then commenting-out code using comments can become more challenging.

If you do need to comment out a code block that contains multi-line comments, you can also consider using the `#if 0` preprocessor directive

💥Pro Tip on this lab and all future coding assignments: check your code incrementally.

































