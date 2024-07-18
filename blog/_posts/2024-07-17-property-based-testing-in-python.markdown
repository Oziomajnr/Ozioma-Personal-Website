---
layout: post
title:  "Property-Based Testing in Python [WIP]"
date:   2024-07-19
categories: ["python", "testing", "property-based-testing", "hypothesis"]
---



## Introduction
We write tests to help identify and catch bugs in our code but while some bugs are obvious, others are hidden in edge cases. So we aim to test as many unique cases as possible, but there’s a limit to how many we can manually write.
What if we could automatically generate numerous test cases? That’s where Property Based Testing comes in.


## What is Property-Based Testing?
Property-based testing is a methodology where we define **properties** that describe the **expected behavior** of our system under various conditions. These properties are then automatically tested using **randomly generated inputs**.

To better understand property-based testing, let's first look at a more common approach: example-based testing.

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
In the example above, we have a simple function that takes in two numbers and returns the sum of the numbers and we are testing the `add` function by providing it with specific input values and checking if the output matches our expectations.

**However, this example based approach has limitations:**

- **Limited Coverage:** It only covers the specific cases we can think of.
- **Scalability and Maintenance:** Manually adding more test cases to cover new scenarios can be laborious and time-consuming.

These limitations can make it difficult to ensure comprehensive test coverage and maintain the test suite as the codebase grows. This is where property-based testing comes in to provide a more scalable and thorough testing approach.



### How Does Property-Based Testing Help?
Property-based testing addresses the limitations of example-based testing by offering several advantages:

- **Random Inputs:** Automatically generates a list of random inputs covering a wide range of cases.
- **Scalability:** No need to manually add more test cases.
- **Better Description:** Tests describe the system’s behavior more comprehensively.

To illustrate these benefits, let's examine an example using a sorting function.

## Example: Sorting Function

### Example-Based Test
Example-based testing involves writing specific test cases with predefined inputs and expected outputs. Here’s how we might test a simple bubble sort implementation using example-based testing:

```python
def sort_list(nums):
    # Bubble sort implementation
    for i in range(len(nums)):
        for j in range(0, len(nums) - i - 1):
            if nums[j] > nums[j + 1]:
                nums[j], nums[j + 1] = nums[j + 1], nums[j]
    return nums

def test_sort_list_example_based():
    assert sort_list([3, -1, 4, -5, 2]) == [-5, -1, 2, 3, 4]
    assert sort_list([1, 2, 3, 4, 5, 6, 7]) == [1, 2, 3, 4, 5, 6, 7]
    assert sort_list([-1, -100, 15, -19, 0, 0]) == [-100, -19, -1, 0, 0, 15]
```
While this approach verifies that the function works for specific cases, it has the following limitations mentioned earlier:
- **Limited Coverage:** Only covers the cases we can think of.
- **Scalability and Maintenance:** Manually adding more test cases to cover new scenarios is laborious.

To improve our example-based tests, we can define a property that the output should always satisfy: the list should be sorted.

**Improved Example-Based Test**
```python
def is_sorted(nums):
	# Each item in the list should be smaller than the item on the right if it exists
    for i in range(len(nums) - 1):
        if nums[i] > nums[i + 1]:
            return False
    return True

def test_sort_list_example_based_improved():
    for item in [[3, -1, 4, -5, 2], [1, 2, 3, 4, 5, 6, 7], [-1, -100, 15, -19, 0, 0], []]:
        assert is_sorted(sort_list(item))
```

This improved test checks the property that the output list is sorted for each input list, but we still have to manually specify the input lists. We can enhance this further by automatically generating random test cases as input to our test function. This can be achieved by using a property-based testing library like [Hypothesis](https://hypothesis.readthedocs.io/en/latest/#).

### Property-Based Test
Property-based testing extends the idea of example-based testing by automatically generating a wide range of inputs to test against the defined property.

```python
from hypothesis import given, strategies as st

@given(st.lists(st.integers()))
def test_sort_list_property_based(nums):
    assert is_sorted(sort_list(nums))
```

In this property-based test:

- `@given` is a decorator provided by Hypothesis that specifies the strategy for generating test inputs.
- `st.lists(st.integers())` is the strategy that generates lists of integers.

With this setup, Hypothesis automatically creates diverse input lists to test the `sort_list` function, ensuring the output is always sorted. This approach helps uncover edge cases and potential issues that might not be covered by manually written test cases.

### How `@given` Works
- **Automatic Input Generation:** The `@given` decorator instructs Hypothesis to generate inputs according to the specified strategy. In this case, it generates lists of integers.
- **Diverse Test Cases:** By default, Hypothesis runs the test function with a wide variety of inputs to thoroughly exercise the code. It typically generates and tests 100 different inputs per test case, but this can be customized.




### Common Properties in PBT
Property-based testing can be used to verify various properties, such as:
1. **Inverse Property:** Applying an operation and then its inverse should return the original value.
    - Example: Serialization/Deserialization.
2. **Idempotence Property:** Applying an operation multiple times has the same effect as applying it once.
    - Example: Removing duplicates.
3. **Invariant Property:** Certain properties of the input should remain unchanged after the operation.
    - Example: Collection size after transformation.
4. **Hard to Prove, Easy to Verify:** The correctness of the output is easier to check than proving the algorithm.
    - Example: Sorting.

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
- **Steep Learning Curve**
- **Complexity in Properties**
- **Difficulty in Debugging**
- **Flaky Tests**
- **Pipeline Slowdown due to Many Tests**

## PBT Adoption Strategy
- **Complement, Don’t Replace:** Use PBT to improve example-based tests.
- **Start Simple:** Begin with properties easy to verify.
- **Low Footprint:** Add PBT tests without replacing old ones.
- **Value Addition:** Ensure tests provide meaningful insights.

## PBT in Python with Hypothesis
- **Generates Inputs:** Automatically creates test inputs.
- **Custom Strategies:** Allows creating custom inputs.
- **Input Shrinking:** Finds the smallest example causing failure.
- **Compatibility:** Works with pytest, unittest.
- **Observability:** Provides test statistics.

## Hypothesis Demo
Check out the demo at [GitHub](https://github.com/Oziomajnr/Property-Based-Testing-Sample-Python).
