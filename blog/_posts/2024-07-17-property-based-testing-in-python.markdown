---
layout: post
title: "An Introduction to Property-Based Testing"
date: 2024-07-17
categories: ["python", "testing", "property-based-testing", "hypothesis", "kotest", "scalacheck"]
---



## Introduction
Testing is critical in the software development process as it helps identify bugs and ensure our software works correctly.   
While some potential bugs are easy to identify, others are hidden in less obvious cases. So, we aim to test as many scenarios as possible, but manually writing and maintaining numerous test cases can be impractical.  
**Property-Based Testing (PBT)** addresses this challenge by automatically generating a wide variety of test cases, making it easier to find and fix edge cases in our code.

## What is Property-Based Testing?
Property-based testing is a methodology where  **properties** that describe the **expected behavior** of our system under various conditions are automatically tested using **randomly generated inputs**.

To better understand property-based testing, let's first look at a more common testing approach: **example-based testing**.

### Example-Based Testing
Example-based testing involves writing specific test cases with predefined inputs and expected outputs. This method is straightforward and intuitive, as it allows developers to check if a function produces the correct result for known scenarios.

![example based test](https://github.com/Oziomajnr/Property-Based-Testing-Sample-Python/blob/main/example_based_test.png?raw=true)

Consider the following example

```python
def add(a, b):
    return a + b

def test_add():
    assert add(1, 2) == 3
    assert add(0, 0) == 0
    assert add(-1, 1) == 0
```
In the example above, we have a simple function that takes in two numbers and returns the sum of the numbers.
We are testing the `add` function by providing it with specific input values and checking if the output matches our expectations.

However, this example-based approach  has the following limitations:

- **Limited Coverage:** It only covers a small range of specific cases that we can think of at the point of writing the tests.
- **Scalability and Maintenance:** Manually adding more test cases to cover new scenarios can be laborious and time-consuming.

These limitations can make it difficult to ensure comprehensive test coverage and maintain the test suite as the codebase grows. This is where property-based testing comes in to provide a more scalable and thorough testing approach.



### How Does Property-Based Testing Help?
Property-based testing addresses the limitations of example-based testing by offering several advantages:

- **Input generation:** Automatically generates a list of random inputs covering a wide range of cases.
- **Scalability:** No need to manually add more test cases.
- **Better Description:** The tests describe the system’s behavior more comprehensively.

To illustrate these benefits, let's examine another example using a simple sorting function.  
We will start with example based testing and then improve it with property based testing.

## Example: Sorting Function
Imagine we have a function `sort_list` and it takes in a list of numbers and sorts them.
```python
def sort_list(nums):
    # Bubble sort implementation
    for i in range(len(nums)):
        for j in range(0, len(nums) - i - 1):
            if nums[j] > nums[j + 1]:
                nums[j], nums[j + 1] = nums[j + 1], nums[j]
    return nums
```
We can test this function as follows

### Example-Based Test
We could have some hardcoded inputs and assert against some expected outputs.

```python
def test_sort_list_example_based():
    assert sort_list([3, -1, 4, -5, 2]) == [-5, -1, 2, 3, 4]
    assert sort_list([1, 2, 3, 4, 5, 6, 7]) == [1, 2, 3, 4, 5, 6, 7]
    assert sort_list([-1, -100, 15, -19, 0, 0]) == [-100, -19, -1, 0, 0, 15]
    
```
While this approach verifies that the function works for specific cases, it has the limitation of limited coverage (we only have a fixed number of test cases) and scalability mentioned earlier:

To improve our example-based tests, we can define a property that the output from our function should always satisfy, that is, *the list should be sorted.*

To achieve this, we have created a function to check if a list is sorted.

**Improved Example-Based Test**
```python
def is_sorted(nums):
	# Each item in the list should be smaller than the item on the right if it exists
    for i in range(len(nums) - 1):
        if nums[i] > nums[i + 1]:
            return False
    return True
 ```
Since we now have a property that correctly describes the behavior of our function, we expect that it should always be true for any input.
We can now improve our test by removing the hardcoded expected outputs and instead assert that the output of our function satisfies the property we have defined.
```python
def test_sort_list_example_based_improved():
    for item in [[3, -1, 4, -5, 2], [1, 2, 3, 4, 5, 6, 7], [-1, -100, 15, -19, 0, 0], []]:
        assert is_sorted(sort_list(item))
```

This improved test checks the property that the output list is sorted for each input list, but we still have to manually specify the input lists.

We can enhance this further by automatically generating random test cases as input to our test function.   
We could write another function to generate random lists of integers and use it in our test function but this can be achieved by using a property-based testing library like [Hypothesis](https://hypothesis.readthedocs.io/en/latest/#), [Scalacheck](https://scalacheck.org/) or [Kotest](https://kotest.io/docs/proptest/property-based-testing.html).

### Property-Based Test
Property-based testing can improve our example-based test above by automatically generating a wide range of inputs to test against the defined property.  
The following sample demonstrates how to use [Hypothesis](https://hypothesis.readthedocs.io) generate the inputs for our test function.

```python
from hypothesis import given, strategies as st

@given(st.lists(st.integers()))
def test_sort_list_property_based(nums):
    assert is_sorted(sort_list(nums))
```

In this property-based test:

- `@given` is a decorator provided by Hypothesis that specifies the strategy for generating test inputs.
- `st.lists(st.integers())` is the strategy that generates lists of integers.

With this setup, Hypothesis automatically creates diverse input lists to test the `sort_list` function, ensuring the output is always sorted, similar APIs are available in other property based testing libraries. This approach helps uncover edge cases and potential issues that might not be covered by manually written test cases.

### How `@given` Works
- **Automatic Input Generation:** The `@given` decorator instructs Hypothesis to generate inputs according to the specified strategy. In this case, it generates lists of integers.
- **Diverse Test Cases:** By default, Hypothesis runs the test function with a wide variety of inputs to thoroughly exercise the code. It typically generates and tests 100 different inputs per test case, but this can be customized.

Similar test case generators are available in other property-based testing libraries.

### Common Properties in PBT
From the given sorting example above, we can see that the most important step in property based testing is _defining the properties_ that describes our system. Once we have the properties, we can generate random test cases and assert against those properties. Determining these properties might not be very easy sometimes, but here are some common properties that we could use with our systems.

1. **Inverse Property:** Applying an operation and then its inverse should return the original value.
    - Example: Serializing and object to string and deserializing it back should yield the original object.
    - [Here is an example of the Inverse Property Being used with ScalaCheck](https://github.com/lichess-org/scalachess/blob/1ab110f417170f65f434222b1eb6f3b6b8f4419c/test-kit/src/test/scala/format/pgn/ParserCheck.scala#L16)


2.  **Invariant Property:** Certain properties of the input should remain unchanged after the operation.
    - Example: The size of a collection after mapping/transformation, sum of balance of two accounts after a transfer from one of the accounts to the other one, left and right hand side of an account balance sheet.
    - Another common example of the invariant property is demonstrated in this [QuteBrowser Source Code](https://github.com/qutebrowser/qutebrowser/blob/43fa657f55c08256c1f8fe39b9c1348f499f4831/tests/unit/utils/test_utils.py#L933) the invariant property here is that the code should not throw any unexpected errors when parsing any text input. This is a good property to begin with if you are not sure of what property describes your system.


3. **Idempotence Property:** Applying an operation multiple times has the same effect as applying it once.
    - Example: Removing duplicates from a collection, database updates.


4. **Hard to Prove, Easy to Verify:** The correctness of the output is easier to check than proving the algorithm is correct.
    - Example: The sorting example shown earlier, you do not need to know how the  sorting algorithm works to verify the output.



   You can learn about more common properties from [this post](https://fsharpforfunandprofit.com/posts/property-based-testing-2/)


Let's demonstrate one of the properties mentioned above, the *inverse property*

### Example: Serialization/Deserialization
Let's look at an example that tests the serialization and deserialization of a `User` object.

```python
import json
from typing import Optional
from hypothesis import given, strategies as st

class User:
    def __init__(self, name: str, age: int, email: str, address: Optional[str] = None):
        self.name = name
        self.age = age
        self.email = email
        self.address = address

    def __eq__(self, other):
        if isinstance(other, User):
            return self.__dict__ == other.__dict__
        return False

class UserSerializer:
    @staticmethod
    def to_json(user: User) -> str:
        return json.dumps(user.__dict__)

    @staticmethod
    def from_json(data: str) -> User:
        json_data = json.loads(data)
        return User(**json_data)

user_strategy = st.builds(
    User,
    name=st.text(min_size=1),
    age=st.integers(min_value=0, max_value=120),
    email=st.emails(),
    address=st.one_of(st.none(), st.text(min_size=1))
)

@given(user_strategy)
def test_user_json_serialization(user):
    serialized = UserSerializer.to_json(user)
    deserialized = UserSerializer.from_json(serialized)
    assert user == deserialized  # Inverse Property
```
In this example, we define a property that ensures serializing and then deserializing a `User` object should yield the original `User` object.

This illustrates the inverse property in property-based testing.


## Cons/Bottlenecks of Property Based Testing

-   **Steep Learning Curve**: Learning to define effective properties and understanding the framework's features can be challenging, especially for those new to property-based testing.

-   **Complexity in Properties**: Writing properties that accurately capture the intended behavior of the system can be complex, often requiring deep domain knowledge.

-   **Difficulty in Debugging**: When a test fails, identifying the root cause can be difficult due to the abstract nature of properties and the potentially large input space, PBT libraries have features to simplify debugging like seeding and example database.

-   **Flakiness**: Since the test inputs are randomly generated, a test could fail in one run and pass when retried because it is running another set of inputs, this is called *flakiness*, and it is undesirable in tests. However, most property based testing libraries prevent this by always running failed test cases before running randomly generated ones.

-   **Slow CI Pipelines due to Many Tests**: Running a large number of property-based tests, especially with extensive input generation, can significantly slow down the CI/CD pipeline.

## Features of property based testing libraries
So far we have only used property based testing library for generating inputs, but they do more than that, here are some features that are available in most PBT libraries like Hypothesis, Scalacheck and Kotest.

-  **Test Case generation**  
   PBT libraries automatically create a wide range of test inputs to explore the behavior of the system under different conditions. For example, Hypothesis (Python) uses strategies to generate diverse input data, ScalaCheck (Scala) provides a variety of generators for common data types and structures, and Kotest (Kotlin) includes built-in arbitraries to generate inputs, ensuring comprehensive testing of code with various inputs.


- **Custom Strategies**:  
  PBT libraries allow users to define custom strategies or generators for specific needs, ensuring that the generated inputs closely match the domain requirements. Hypothesis allows the creation of composite strategies to generate complex input data, ScalaCheck allows defining custom generators to produce inputs that match particular criteria, and Kotest provides the flexibility to create custom arbitraries, enabling testing of code with domain-specific data.

- **Stateful Testing**  
  Some PBT libraries also support [stateful testing](https://hypothesis.readthedocs.io/en/latest/stateful.html), where instead of testing functions in isolation, you could specify the actions that can happen in your system along with the strategies to generate their inputs and the library would generate different combination of those actions along with the randomized inputs, and you can assert that the state of the system is correct after a sequence of these actions. You can find a demonstration of stateful testing in [this article](https://hypothesis.works/articles/rule-based-stateful-testing/).

- **Input Shrinking**  
  In PBT, input shrinking is the process of reducing the size of failing inputs to simplify debugging and identify the root cause of test failures.   
  In the sorting example above, a failing test case could have hundreds of very large numbers and this could make it difficult to visually inspect and detect the issue, input shrinking would reduce the size of the input to the smallest possible input that still causes the failure, making it easier to diagnose and fix the issue.

- **Compatibility**
  PBT libraries integrate seamlessly with popular testing frameworks, allowing developers to use property-based tests alongside traditional unit tests. Hypothesis works with `pytest` and `unittest`, ScalaCheck integrates with ScalaTest and specs2, and Kotest has built-in support for property testing within the Kotest framework, facilitating the use of both property-based and traditional tests.


-  **Reporting**
   PBT libraries provide insights and statistics about the tests, such as the number of cases generated and the distribution of inputs, helping developers understand the testing coverage and effectiveness. Hypothesis offers detailed reports and statistics on the test cases executed, ScalaCheck outputs statistics about the tests including the number of successful cases and counterexamples found, and Kotest logs information about the property tests, helping developers assess the thoroughness of their tests.


- **Test Stability**
  PBT libraries include features to reduce or avoid flaky tests, which can occur due to non-deterministic input generation or test execution.
  Hypothesis for example contains a database of examples that have caused failures in the past, and it will always run these examples before running randomly generated ones, this ensures that if a test fails, it will always fail until the issue is fixed, this prevents flakiness in tests.
  Most PBT libraries also provide the ability to set a seed for the random number generator, by reusing the seed of a failing test, you can reproduce the same failing test case, this makes it easier to debug and fix the issue.


These features of PBT libraries enhance the testing process by ensuring comprehensive input coverage, enabling custom input generation, simplifying debugging with input shrinking, integrating with existing testing frameworks, providing observability into the testing process, and reducing flakiness.



## Strategy for Adopting Property-Based Testing

Adopting Property-Based Testing (PBT) can significantly enhance your testing approach by uncovering edge cases and improving code robustness. Here are some principles to guide you in effectively integrating PBT into your development process:

- **Low Footprint, Enhance, Don’t Replace**  
  Utilize Property-Based Testing to complement and enhance your existing example-based tests. PBT can uncover edge cases and unexpected behavior that example-based tests might miss.  
  Incorporate PBT tests into your existing test suite without removing or replacing the current tests. This low-footprint approach ensures that you retain the benefits of your example-based tests while leveraging the strengths of PBT.


- **Begin with Basic Properties**  
  Start by defining simple, easy-to-verify properties. Gradually introduce more complex properties as you become more comfortable with PBT. This approach helps build confidence and familiarity with the methodology.



- **Make sure it adds value**  
  Focus on writing properties that add value to your testing process. Prioritize properties that uncover edge cases, verify critical system behavior, or address known issues. This ensures that your PBT efforts are targeted and effective.


By following these strategies, you can effectively adopt Property-Based Testing and enhance your overall testing approach.




This article was adapted from my talk at the [ThaiPy meetup](https://www.meetup.com/thaipy-bangkok-python-meetup/events/299986805/), you can find the slides and code examples on  [GitHub](https://github.com/Oziomajnr/Property-Based-Testing-Sample-Python).