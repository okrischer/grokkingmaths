### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ d8d70b1c-12b4-11ef-161c-21e7e562639a
begin
	include("helper.jl")
	using Luxor
	using BenchmarkTools
	using Plots
	using MathTeXEngine
end

# ╔═╡ 211c457d-756e-4f93-a883-3b1ec4ddbf9d
md"""
# Induction and Recursion

*Mathematical Induction* is a mathematical proof method.
The term *inductive* here is not to be confused with the meaning of the term *inductive reasoning*, which describes methods of reasoning in which broad generalizations or principles are derived from a body of observations.
Mathematical induction is actually a form of *deductive* rather than inductive reasoning, where the conclusion of a deductive argument is certain given the premises are correct.
But, as the term is commonly accepted, we will stick to it anyway.

Roughly speaking, mathematical induction is a method to prove facts about objects that can be built from a finite number of pieces in a finite number of steps (e.g. the set of natural numbers).
Such objects can often be constructed by means of *recursive definitions*.
Thus, as we will explore in this lesson, recursive definitions and inductive proofs are two sides of the same coin.

## Mathematical Induction

Let $P(n)$ a proposition about natural numbers.
To prove a goal of the form $\forall n \in N: P(n)$ by *mathematical induction*, it is sufficient to perfom the following steps:
1.  **base case**: this proves the statement for an arbitrarily chosen number $n_0$; in most cases this will be, but does not have to, the number 1 as the smallest natural number
2.  **induction step**: this proves that *if* the statement holds for any given case $n=k$ *then* it must also hold for the next case $n = k + 1$ (or alternatively the preceeding case $n = k - 1$).

These two steps together establish that the statement holds for every natural number $n \in \mathbb{N}$.

Perhaps the easiest way to understand mathematical induduction is to work through some examples. 

!!! tip "The sum of the first n odd numbers"
	The sum of the first $n$ odd numbers $S_n$ equals $n^2$.
	More formally:
	
	$S_n = \sum_{k=1}^{n}(2k - 1) = n^2.$

**Base case**\
For $n=1$ we have $\sum_{k=1}^{1}(2k - 1) = 1 = 1^2$, which is obviously true.

**Induction step**\
We have to show $\sum_{k=1}^{n+1}(2k - 1) = (n+1)^2$, where this representation is called the *induction hypothesis*.\
For that, we express the left hand side *(lhs)* of the induction hypothesis like so:
$lhs = \sum_{k=1}^{n}(2k - 1) + 2(n+1) - 1$.\
Then we reshape that expression and show that it is equivalent to the right hand side *(rhs)* of the induction hypothesis.
For this, we are allowed to use the induction hypothesis like so:\
$lhs = n^2 + 2(n+1) - 1.$\
Applying the [binomial formula](https://en.wikipedia.org/wiki/Binomial_theorem), we get

$lhs = n^2 + 2n + 1 = (n+1)^2 = rhs \ \square.$

However, proving a proposition with mathematical induction gives us no clue for finding that formula in the first place, that is, *discovering* and *proving* a formula are completely different tasks.

So, how do we find a "closed form" for solving the expression $\sum_{k=1}^{n}(2k - 1)$, that is, a formula that lets us compute the result quickly, even for large $n$?\
One way is to *guess* the correct solution and then to prove that our guess is correct.
Our best hope for guessing the solution is to examine the results of the expression for small cases. 
We will do that with the help of a Julia function:
"""

# ╔═╡ 6fc9840a-8178-4539-8f34-9e3c2eeaf14b
begin
	sofon(n) = sum([2k - 1 for k in 1:n])
	for n in 1:10
		@show n, sofon(n)
	end
end

# ╔═╡ ef05dee5-0386-47de-b46c-3fb0e06f9a55
md"""
It looks as if $S_n = n^2$, at least for $n <= 10$.
Having a proof with mathematical induction already in place, we can verify that this solution is correct.
"""

# ╔═╡ 5ae6e717-b158-4664-bf46-ef6393742203
md"""
!!! tip "The sum of the first n numbers"
	The sum of the first $n$ natural numbers $T_n$ equals $\frac{n(n+1)}{2}$. More formally:
	
	$T_n = \sum_{k=1}^n k = 1+2+3+\cdots+n = \frac{n(n+1)}{2}.$

**Base case**\
We choose $n_0 = 1$ and get $\frac{1(1+1)}{2} = 1$, which is obviously true.

**Inductive step**\
We formulate the *induction hypothesis* like so:

$\sum_{k=1}^{n+1} k = \frac{(n+1)(n+2)}{2}.$

For the proof we'll expand and reshape the left hand side (*lhs*) of the hypothesis and check whether this leads to the same result as the right hand side (*rhs*) of this
equation:

$\begin{align}
lhs &= \sum_{k=1}^n k + n + 1\\
&= \frac{n(n+1)}{2} + n + 1\\
&= \frac{n(n+1) + 2(n+1)}{2}\\
&= \frac{(n+1)(n+2)}{2} = rhs \ \square.
\end{align}$

The last line of this proof follows from the *distributive law* of algebra:
$ba + ca = a(b+c)$.

In order to find a closed formula for solving the sum expression, we want to do better than just guessing, which we did for the last example.
One way to do so, is to employ the concept of [triangular numbers](https://en.wikipedia.org/wiki/Triangular_number), which are a kind of [figurate numbers](https://en.wikipedia.org/wiki/Figurate_number).

A triangular number counts objects arranged in an equilateral triangle.
The *n*th triangular number is the number of objects in the triangular arrangement with *n* objects on each side, and it's equal to the sum of the *n* natural numbers from 1 to *n*.

Let's inspect the visual representation for $n = 10$:
"""

# ╔═╡ 02c404ac-8029-4fac-a0e7-62990a947d5f
begin
	function trow(n)
	  points = Array{Point}(undef, n)
	  for p in 1:n
	    points[p] = Point(p*25, 0)
	  end
	  circle.(points, 10, action = :fill)
	end
	
	function triangle(n)
	  n == 0 && return
	  trow(n)
	  Luxor.translate(0, 25)
	  triangle(n-1)
	end
	
	Drawing(260, 250, "triangle.svg")
	Luxor.translate(0, 10)
	setcolor(0, 0, 0, 0.7)
	triangle(10)
	finish()
	preview()
end

# ╔═╡ 2c8b5d80-1a66-4d5a-b273-73f9e74d12e5
md"""
The number of elements in this figure is obviously $T_n = \sum_{k=1}^{10} = 55$.\
Unfortunately it's not easy to count the elements of a triangle.
But it would be easy to count the elements of a rectangle, as there is a simple formula to do so: $elems_{rect} = rows_{rect} \times cols_{rect}$.\
So, the trick is to duplicate the triangle, rotate it by 180 degrees and paste it to the original one, resulting in a rectangle:
"""

# ╔═╡ 3e22ce56-8a66-4869-bff9-5affede043c4
begin
	Drawing(285, 250, "rectangle.svg")
	Luxor.translate(0, 10)
	setcolor(0, 0, 0, .7)
	triangle(10)
	Luxor.rotate(π)
	Luxor.translate(-300, 25)
	setcolor(0, 0, 0, .2)
	triangle(10)
	finish()
	preview()
end

# ╔═╡ b803c184-b435-420f-9bf7-ce7ab5ec2269
md"""
Observe that the number of rows of this rectangle is the same as that from the triangle above, but the number of columns has increased by one.
Therefore, the number of elements in this rectangle is $n \times (n + 1)$, and as we have duplicated the original triangle, we only need the half of it:

$T_n = \frac{n(n+1)}{2}.$

Another way to solve the sum expression was found by the German mathematician
*Carl Friedrich Gauß* at the age of 9.\
He added all the natural numbers up to $n$ in a line, and in a second line he added them again, but in reverse order.
Finally, he added both lines like so:

$\begin{align}
1 + 2 &+ \dots + (n-1) + n &= T_n\\
n + (n-1) &+ \dots + 2 + 1 &= T_n\\
(n+1) + (n+1) &+ \dots + (n+1) + (n+1) &= 2T_n
\end{align}$

How many times does $(n+1)$ appear in the last line?
The first line shows that the answer is $n$. Hence $n(n+1) = 2T_n$, leading to

$T_n = \frac{n(n+1)}{2}.$
"""

# ╔═╡ 918847f2-efdc-4934-a01f-b0e147926585
md"""
Now, having introduced the concept of *figurate numbers*, let's use this for finding the solution for the last example $S_n = \sum_{k=1}^{n}(2k - 1) = n^2$, which we have solved only by guessing so far.

We can represent $n^2$ as a [square number](https://en.wikipedia.org/wiki/Square_number).
A number $m$ is a *square number* if and only if *m* elements can be arranged in a square, that is $m = n^2$, where $n$ is the side length of the square.
Thus, the figure below illustrates all the square numbers $S_n$ for $\{n \in \mathbb{N} \mid n \leq 10\}$, starting at the upper right corner of the main square.
The squares of odd numbers are shown with dark circles, while the squares for even numbers are shown with light circles.
"""

# ╔═╡ 5e1f8525-8d6e-4faf-8e34-8a0272b31e4d
begin
	function srow(n,r)
		if r%2 == 1
			for p in 1:n
				(p%2 == 1 && p <= (n-r)) ?
					setcolor(0, 0, 0, .2) :
					setcolor(0, 0, 0, .7)
				circle(Point(p*25, 0), 10, action=:fill)
			end
		else
			for p in 1:n
				(p%2 == 1 || p > (n-r)) ?
					setcolor(0, 0, 0, .2) :
					setcolor(0, 0, 0, .7)
				circle(Point(p*25, 0), 10, action=:fill)
			end
		end
	end

	function square(n)
		for r in 1:n
			srow(n,r)
			Luxor.translate(0, 25)
		end
	end
	
	Drawing(260, 250, "square.svg")
	setcolor("black")
	Luxor.translate(0, 10)
	square(10)
	finish()
	preview()
end

# ╔═╡ 95d5ef99-7634-48ef-b07a-8469af335335
md"""
Representing the dark and light circles as triangular numbers, we see a distinct relation between their triangular and square number arrangement:
$T_{n-1} + T_n = n^2.$
"""

# ╔═╡ 2a6c367c-531a-4b16-a8d9-224e5c177031
begin
	Drawing(225, 200, "relation.svg")
	Luxor.translate(0, 10)
	setcolor(0, 0, 0, 0.7)
	triangle(7)
	Luxor.rotate(π)
	Luxor.translate(-225, 0)
	setcolor(0, 0, 0, .2)
	triangle(8)
	finish()
	preview()
end

# ╔═╡ c57c16a7-dea8-4b44-87cc-2bde733b4bfb
md"""
Let's examine one last example:

!!! tip "The sum of the first n squares"
	The sum of the first $n$ square numbers $Te_n$ is given by the formula:
	
	$Te_n = \sum_{k=1}^{n}k^2 = \frac{n(n+1)(2n+1)}{6}.$

Before giving the proof, let's have a look on some facts about this sum formula:
- the sum formula $\sum_{k=1}^{n}k^2$ represents another *figurate number*, called [tetrahedral number](https://en.wikipedia.org/wiki/Tetrahedral_number)
- it represents a pyramid with a triangular base and three sides, called a [tetrahedron](https://en.wikipedia.org/wiki/Tetrahedron)
- The $n$th tetrahedral number, $Te_n$, is the sum of the first $n$ triangular numbers, that is,  
$Te_n = \sum_{k=1}^{n}k^2 = \sum_{k=1}^{n}\frac{k(k+1)}{2} = \sum_{k=1}^{n}\left(\sum_{i=1}^{k}i\right).$

**Base case**\
For $n_0 = 1$, we get $Te_1 = \frac{1 \cdot 2 \cdot 3}{6} = 1$.

**Inductive step**\

$\begin{align}
Te_{n+1} &= Te_n + T_{n+1}\\
&= \frac{n(n+1)(2n+1)}{6} + \frac{(n+1)(n+2)}{2}\\
&= (n+1)(n+2)\left(\frac{n}{6} + \frac{1}{2} \right)\\
&= \frac{(n+1)(n+2)(n+3)}{6}\\
&= \frac{n(n+1)(2n+1)}{6} \ \square.
\end{align}$

For this example we're not interested in how to find that closed formula.
Instead, we're going to explore the effects of replacing the (recursive) sum formula with the closed form of the formula for computing the actual results for a given *n*.
For that, we define two distinct functions and compare their running time via some benchmarks:
"""

# ╔═╡ 97fbdfdc-9400-4b45-bc0a-470bf6178e2c
begin
	# recursive definition
	sumRecursive(n::Int) = sum([k^2 for k in 1:n])
	# closed formula
	sumClosed(n::Int) = div(n * (n+1) * (2n + 1), 6)
	for n in [10, 100, 1000]
		@assert sumRecursive(n) == sumClosed(n)
	end
end

# ╔═╡ 671bd3cb-e081-4e72-91b6-49bc614b985c
md"""
If we don't get any errors from the `@assert` macro above, then both functions indeed return the same result for a given *n*.\
Performing some benchmarks for the recursive definition,
"""

# ╔═╡ a012258f-e65b-41ab-be79-cffcc837b2d8
@btime sumRecursive(10)

# ╔═╡ 94faa5d5-0bf5-4d42-80ec-fa3a81102a33
@btime sumRecursive(100)

# ╔═╡ 1d8ac2b9-1100-4a35-baaf-d8b14e18807d
@btime sumRecursive(1000)

# ╔═╡ 42f0052c-79e4-471d-91c6-4b5074391b0e
md"""
we see that, with growing *n*, the running time of the algorithm also grows with a similar rate.
As the algorithm has to iterate over all natural number from 1 up to *n*, we call this a *linear* running time, denoted with $\Theta (n)$ in *asymptotic notation*.\
If you are not familiar with asymptotic notation, please have a look at the next section, where we'll explore the basics of how to determine the running time of an algorithm.

Now, let's do the same for the closed-form algorithm:
"""

# ╔═╡ eb70769a-5b28-48d8-baca-90ab16beb7b1
@btime sumClosed(10)

# ╔═╡ 6aebe83e-0e33-457b-b73e-79059f79cd97
@btime sumClosed(100)

# ╔═╡ 827976d7-f93a-4d26-9fc0-652c142fad5f
@btime sumClosed(1000)

# ╔═╡ 48be45cc-2a02-4cd1-94f5-447a99ece868
md"""
Observe that not only the running time of this algorithm is much smaller (i.e. it's about 30 times faster, even for a small $n=10$), it also remains constant for a growing *n*.
We call this a *constant* running time, denoted as $\Theta(1)$.\
Also observe that this improved algorithm, in contrast to the recursive algorithm, doesn't need to allocate memory on the programs heap, thus it also shows a constant *space complexity*.

"""

# ╔═╡ 6a509eb7-dde7-4f56-974e-89d100ed3cf2
md"""
## Interlude: Running Time of Algorithms

Whenever we're reasonating about the efficiency of algorithms, we're using *asymptotic notation* for doing so.
The key idea is to consider the complexity of an algorithm in terms of its *running time* for a big input value, that is for $n \to \infty$.

In particular, we express the running time as a function of $n$, where the function value is denoted is a polynom of $n$, calculating the necessary steps the algorithm has to perform in order to produce the desired result, for example

$g(n) = a * n^2 + b * n + c \ , \quad \textrm{ for } n \to \infty.$

In this case that's a polynomial of second degree (a quadratic polynomial), as $n$ occurs with its highest power of 2.
When $n$ is getting bigger, the term with the highest power of $n$ is most signifant,
so we just neglect all other terms, leading to

$g(n) = c * n^2$

where $c$ is some constant value, which we can neglect likewise.
Finally, we can do without the function name if we mark the term with a special symbol
$\mathcal{O}$, leading to the so called *big O notation*, for our example

$\mathcal{O} (n^2),$

which reads as: "*in the order of n square*".

#### Asymptotic Notation

Actually, there are three different symbols being used for denoting the asymptotic
complexity of an algorithm, each of them with a slightly different meaning:

- *Big O* ($\mathcal{O}$): denotes the complexity as an upper limit, that is, the algorithm will need at most this number of steps to complete, sometimes significantly less
- *Theta* ($\Theta$): denotes the given term as an upper *and* a lower limit, i.e. the algorithm will always take this number of steps
- *Omega* ($\Omega$): denotes a lower limit, i.e. the algoritm will use at least this number of steps, sometimes significantly more.

There are a number of standard complexity classes, which will usually be sufficient to
describe the complexity.
They are, from most to least efficient:

- *constant*: $\Theta (1)$ 
- *logarithmic*: $\Theta (\log n)$: 
- *linear*: $\Theta (n)$ 
- *loglinear*: $\Theta (n \log n)$ 
- *quadratic*: $\Theta (n^2)$
- *exponential*: $\Theta (2^n)$

Problems of the last category belong to the class of *NP* problems, which cannot be solved deterministically in polynomial time.
On the other hand, all non-NP problems are belived to be solvable in a running time of $\mathcal{O} (n^3)$ or less.

Let's illustrate the growth rates of these complexity classes:
"""

# ╔═╡ df48e493-30a6-41bd-857f-79a5a9c6b90c
begin
	n = range(0, 100, length=101)
	loglinear(n) = n * log(n)
	
	plot(n, [log.(n), n],
	title="Growth of functions of n",
	label=[L"\log{n}" "n"],
	xlabel=("n"),
	ylabel=("f(n)"),
	linewidth=2)
	
	plot!(n, loglinear.(n), label=L"n \log n", ylims=(0, 100), linewidth=2)
	plot!(n, x -> x^2, label=L"n^2", legend=:outerbottom, legendcolumns=4, linewidth=2)
end

# ╔═╡ 6ab7723c-c16f-46ee-b5d3-3b3ef5b88fdb
md"""
## Recursive Definitions

To understand *recursion*, you must first understand [recursion](https://www.google.com/search?channel=fs&q=recursion).

A perhaps more helpful example:
!!! tip "How many twists does it take to screw in a light bulb?"
	1. Is it already screwed in? Then zero.
	2. If not, then twist it once, ask me again, and add 1 to my answer.

The answer reveals the nature of recursion; it consists of two steps, where the first step is called the *base case*, and the second one is the *recursive step*:
1. **base case**: produces a trivial result and stops the computation
2. **recursive step**: the procedure is called again with an ever increasing or decreasing parameter.

In order to avoid infinite loops, the recursive step must modify the input value in such way that eventually the base case is reached.

As it turns out, recursion is especially suited to solve problems defined as a *recurrence relation*.
!!! warning "Recurrence Relation"
	A **recurrence relation** is an equation that expresses each element of a *sequence* as a function of the preceding ones.
	It is defined in the form

	$R_n = f(n, R_{n-1}), \quad \textrm{for } n > 0$

	where $f: \mathbb{N} \times X \to X$ is a function where $X$ is the set to which the elements of the sequence must belong.
	For any $R_0 \in X$, this defines a unique sequence with $R_0$ as its first element, called the *initial value*.

Let's look at an example:

!!! tip "Factorial"
	The **factorial** $n!$ is defined by the recurrence relation

	$\begin{align}
	0! &= 1\\
	n! &= n * (n-1)!
	\end{align}$

which translates directly into a recursive function definition:
"""

# ╔═╡ ca9ae417-c56f-492a-ab5c-0e9cd0df8728
begin
	function facRec(n)
		if n == 0
			return 1
		else
			return n * facRec(n-1)
		end
	end
	
	for n in 1:5
		@show n, facRec(n)
	end
end

# ╔═╡ 8b30de72-2b64-48e3-953a-caf82334eab4
md"""
The function `facRec` is an example for a *linear recursive process*, i.e. its running time is $\Theta(n)$.

However, we can take a different perspective on computing factorials.
We could desrcibe a rule for computing $n!$ by specifying that we first multiply 1 by 2, then multiply the result by 3, then by 4, and so on until we reach $n$.
More formally, we maintain a running product, together with a counter that counts from 1 up to $n$ and stipulating that $n!$ is the value of the product when the counter exceeds $n$.
"""

# ╔═╡ 8b1ba980-9f15-4465-baef-0bfe66033984
begin
	function facIter(n)
		function iter(product, counter)
			if counter > n
				product
			else
				iter(counter * product, counter + 1)
			end
		end
		iter(1, 1)
	end
	
	for n in 1:5
		@assert facIter(n) == facRec(n)
	end
end

# ╔═╡ d2449cd0-ecdc-4293-addd-983a0e017552
md"""
The function `facIter` is an example for a *linear iterative process*, i.e. its running time is also $\Theta(n)$.

Comparing the two processes, they seem hardly different at all.
Both compute the same mathematical function on the same domain, and each requires a number of steps proportional to $n$ to compute $n!$.
Indeed, both processes even carry out the same sequence of multiplications, obtaining the same sequence of partial products.

However, they lead to quite different "shapes" of how the processes are executed within a program.
The recursive process is executed like so:

	factRec(5)
	5 * factRec(4)
	4 * 5 * factRec(3)
	3 * 4 * 5 * factRec(2)
	2 * 3 * 4 * 5 * factRec(1)
	1 * 2 * 3 * 4 * 5 * factRec(0)
	2 * 3 * 4 * 5 * (1 * 1)
	3 * 4 * 5 * (2 * 1)
	4 * 5 * (3 * 2)
	5 * (4 * 6)
	5 * 24
	120,

while the iterative process is executed like this:

	facIter(5)
	iter(1, 1)
	iter(1, 2)
	iter(2, 3)
	iter(6, 4)
	iter(24, 5)
	iter(120, 6)
	120.

The recursive process grows and shrinks during execution, as it has to maintain its current state in terms of the value of a function call.
The longer the chain of recursive function calls, the more information must be maintained.
A program stores this information on its *stack*, a [LIFO](https://en.wikipedia.org/wiki/Stack_(abstract_data_type)) datastructure, which grows proportional to the number of recursive calls.

On the other hand, the iterative process does not grow and shrink, and it keeps track of the current state solely with the variables for `product` and `counter`.
Thus, the *stack space* used for this process stays constant with growing $n$. 

We must be careful not to confuse the notion of a recursive *process* with the notion of a recursive *function*.
Both of the processes above are implemented with a recursive *function* (i.e. a function that calls itself), but only `facRec` leads to a recursive *process*, whereas `facIter` leads to an iterative process, which is preferable in general, because of its *constant* space complexity.

With an *imperative* language like Julia, allowing *mutable* variables, we are able to substitute the recursive function definition with an *iterative loop*, maintaining the *iterative process*:
"""

# ╔═╡ 489ba4d3-3f02-4ad4-a8c0-7619c4dacd70
begin
	function facImp(n)
		counter = 1
		product = 1
		while counter <= n
			product *= counter
			counter += 1
		end
		product
	end
	for n in 1:5
		@assert facImp(n) == facIter(n)
	end
end

# ╔═╡ e2d73c9f-8399-4c34-bded-4175d154a286
md"""
Now, let's examine the perfomance of our functions with some benchmarks:
"""

# ╔═╡ 6030bde8-a610-4703-936c-0a9a12c29505
@btime facRec(20)

# ╔═╡ 32c7bd76-1c8d-4471-810d-d03d245e17d6
@btime facIter(20)

# ╔═╡ 0e1e9caa-6970-470b-9d12-9157cbfa4722
md"""
Notice that the recursive function is much faster (more than 10 times) than the iterative function.
Looking at the memory allocations, we can see that the iterative version stores intermediate results in the programs *heap*, leading to a less performant execution path.\
The julia compiler is not able to [inline](https://docs.julialang.org/en/v1/base/base/#Base.@inline) calls to recursive functions, which we can check with the help of the `@code-typed` macro:
"""

# ╔═╡ 31acc697-21c8-4df1-a598-d29f6d7f66d8
@code_typed optimize=true facIter(20)

# ╔═╡ cb4c8e2e-9b60-4df4-bba2-e7d28f3e88ee
md"""
Here we can see that the result `%9` is actually computed as a call to a function `%8` with the parameters `(1, 1)`, which in turn evaluates the expression `%1`, representing the inner function `iter`, stored as a *boxed* object in the program's heap.\
Let's compare this to the imperative version
"""

# ╔═╡ 627d75cd-802f-49df-9a5f-8e20cc918496
@btime facImp(20)

# ╔═╡ a9797347-0a67-4b70-a1a2-ea90d6a83b1b
md"""
which is now much faster than the recursive version (also by a factor of 10).\
Looking at its implementation details, we can see why:
"""

# ╔═╡ dd130192-6f03-4a12-ae3c-a21cf4f04093
@code_typed optimize=true facImp(20)

# ╔═╡ 54feffb2-3404-4667-bdd0-c36f0e965aea
md"""
The function just executes the loop, employing only 2 `goto` statements, where the intermediate values are stored as simple integer variables on the program's stack.\
So, with an imperative language like Julia, the most efficient way to implement *recurrence relations* is to choose an iterative process, implemented via loops.

However, in a pure functional programming language, where we couldn't implement an imperative version (i.e. we'd have to rely on recursive functions), the execution of both processes will depend on the capability of the compiler to optimize [tail-recursive](https://en.wikipedia.org/wiki/Tail_call) calls.

Benchmarking the following implementations in Haskell for $n = 100$

```{haskell}
facRec :: Integer -> Integer
facRec 0 = 1
facRec n = n * facRec (n-1)

facIter :: Integer -> Integer
facIter n = iter 1 1
  where
    iter product counter
      | counter > n = product
      | otherwise   = iter (counter * product) (counter + 1)
```

shows that both the *recursive* and the *iterative* process are being optimized into machine code with comparable efficiency:

	benchmarking facRec
	mean                 2.023 μs   (2.021 μs .. 2.024 μs)

	benchmarking facIter
    mean                 2.122 μs   (2.120 μs .. 2.124 μs)

Let's look at another canonical example:

!!! tip "Fibonacci Sequence"
	The [Fibonacci Sequence](https://en.wikipedia.org/wiki/Fibonacci_sequence) is defined by the recurrence relation

	$\begin{align}
	F_0 &= 0\\
	F_1 &= 1\\
	F_n &= F_{n-1} + F_{n-2}, \quad \mathrm{for} \ n > 1.
	\end{align}$

	That is, every Fibonacci number is the sum of its two predecessors.

which translates directy into this recursive definition:
"""

# ╔═╡ d91101a2-d2a7-45fe-9dd6-7ca223bf9d52
begin
	fibRec(n) = (n <= 1) ? n : fibRec(n-1) + fibRec(n-2)
	fibRec(10)
end

# ╔═╡ 37f4196c-0fa3-474d-8ac9-5517e5546897
md"""
While this function will work and eventually produce the correct value, it shows a very poor performance: it employs *multiple recursion* as it contains two self-references, leading to an exponential running time and space.

One way to avoid exponential growth is to use a technique called *memoization*:
the function checks whether the input value has been calculated previously.
If so, it is simply returned; if not, the value is calculated recursively,
stored and returned.
This leads to a *linear recursive process*.
"""

# ╔═╡ 6133cc2a-c768-41c4-87d5-a717bc34b449
begin
	global cache = Dict{Int, Int}(0 => 0, 1 => 1)
	
	function fibMem(n)
	  	get!(cache, n) do
	    	fibMem(n-1) + fibMem(n-2)
	  	end
	end

	fibMem(10)
	sort(cache)
end

# ╔═╡ 42c1ed7e-2eb1-4bbb-aca7-9fd0c9d785ff
md"""
The second method for efficiently computing $F_n$ is a *linear iteration*.
Having learned the lesson about inlining recursive calls in Julia, we're using an imperative loop for this task straightaway:
"""

# ╔═╡ a3cddb5c-ee9a-4e43-9cbc-b4abf14b01be
begin
	function fibIter(n)
		a, b = 0, 1
		counter = 1
		while counter < n
			a, b = b, a+b
			counter += 1
		end
		b
	end

	for n in 1:10
	@assert fibIter(n) == fibMem(n)
	end
end

# ╔═╡ e78b6cdf-f8d0-4f6d-86f1-090986cd93fd
@btime fibMem(100)

# ╔═╡ 83e5b18e-910e-4c5b-9ae3-64126e08cabf
@btime fibIter(100)

# ╔═╡ 81f0e921-2376-4d76-ad31-2157f82caa1b
md"""
Again, the imperative version is about 10 times faster than the recursive version.\
An efficient solution with Haskell could be implemented like so:

```{haskell}
fibIter :: Int -> [Int]
fibIter n = take n $ fibSeq 1 1
  where fibSeq a b = a:fibSeq b (a+b)
```

yielding the sequence up to the $n$th Fibonacci number:

	ghci> fibIter 10
	[1,1,2,3,5,8,13,21,34,55]
"""

# ╔═╡ 7a29c871-cae6-445f-be51-846ddf57a668
md"""
Although there is a closed formula for computing the $n$th Fibonacci number, we will not explore it until the lesson about *Sequences* of the class *Real Analysis*.
"""

# ╔═╡ 6b3b197b-e468-4044-bd17-542314908b84
md"""
## The Tower of Hanoi
The [Tower of Hanoi](https://en.wikipedia.org/wiki/Tower_of_Hanoi) puzzle, invented by the French mathematician *Èdouard Lucas* in 1883, is the canonical example for solving a problem with recursion.\
We are given a tower of eight disks, initially stacked in decreasing size on one of three pegs.
The objective is to transfer the entire tower to one of the other pegs, moving only one disk at a time and never moving a larger one onto a smaller.


![Tower of Hanoi Animation with 4 disks](https://upload.wikimedia.org/wikipedia/commons/6/60/Tower_of_Hanoi_4.gif)

### Number of Moves
Before actually solving the problem, let's first try to answer the question

	How many moves are necessary and sufficient to perform the task?

In order to answer that question we *generalize* the problem and define $T_n$ as the minimum number of moves required to solve the problem, where $n$ is the number of disks of the initial tower.
Then $T_1$ is obviously $1$, and $T_2 = 3$.\
Considering the smallest case of all, clearly $T_0 = 0$, because no moves at all are needed to transfer a tower with $n = 0$ disks.
But how can we transfer a larger tower?

Experiments with three disks show that the idea is to transfer the top two disks to the middle peg, then move the third, then bring the other two onto it.
This gives us a clue for transferring $n$ disks in general: we first transfer the $n-1$ smallest to a differnt peg (requiring $T_{n-1}$ moves), then move the largest (requiring one move), and finally transfer the $n-1$ smallest onto the largest (requiring another $T_{n-1}$ moves).
Thus, we can transfer $n$ disks in at most $2T_{n-1} + 1$ moves:

$T_n \leq 2T_{n-1} + 1, \quad \textrm{for } n > 0.$

Observe, that this formula uses $\leq$ insead of $=$ because our construction proves only that $2T_{n-1} + 1$ moves *suffice*; but we haven't shown that $2T_{n-1} + 1$ moves are *necessary*.\
But *is* there a better way? Actually no. At some point we must move the largest disk.
When we do, the $n-1$ smallest must be on a single peg and it has taken at least $T_{n-1}$ moves to put them there.
After moving the largest disk we must transfer the $n-1$ smallest disks (which must again be on a single peg) back onto the largest; this too requires at least $T_{n-1}$ moves. Hence

$T_n \geq 2T_{n-1} + 1, \quad \textrm{for } n > 0.$

These two inequalities, together with the trivial solution for $n=0$ yield the recurrence relation

!!! tip "Minimal number of moves for solving the Tower of Hanoi"

	$\begin{align}
	T_0 &= 0\\
	T_n &= 2T_{n-1} + 1, \quad \mathrm{for} \ n > 0.
	\end{align}$
"""

# ╔═╡ 13e2636e-c971-4c4b-b2df-8fabdc3f7f77
md"""
We can find a closed formula for this recurrence by making an educated guess, based on the results for small cases:
"""

# ╔═╡ 0c649fca-f86d-453f-bf02-7b707789fe88
begin
	numOfMoves(n) = n == 0 ? 0 : 2 * numOfMoves(n-1) + 1
	for n in 1:10
		@show n, numOfMoves(n)
	end
end

# ╔═╡ 4f143dbe-7a32-48f7-8ef9-7a0504426be3
md"""
It certainly looks as if

$T_n = 2^n - 1, \quad \textrm{for } n \geq 0.$

Let's prove that formula with *mathematical induction*:\
**Base case**\
For $n_0 = 0$ we get $2^0 - 1 = 1 - 1 = 0$, which is correct.

**Inductive step**\
For this problem we replace $n \textrm{ with } n - 1$ and get

$\begin{align}
T_n &= 2T_{n-1} + 1\\
&= 2(2^{n-1} - 1) + 1\\
&= 2^n - 2 + 1\\
&= 2^n - 1 \ \square.
\end{align}$

Having found the correct solution for the recurrence relation, we can now think of a way of solving it without beeing *clairvoyant*.
As it turns out, the recurrence can be simplified by adding $1$ to both sides of the equations:

$\begin{align}
T_0 + 1 &= 1\\
T_n + 1 &= 2T_{n-1} + 2, \quad \mathrm{for} \ n > 0.
\end{align}$

Now if we let $U_n = T_n + 1$, we have

$\begin{align}
U_0 &= 1\\
U_n &= 2U_{n-1}, \quad \mathrm{for} \ n > 0.
\end{align}$

It doesn't take genius to discover that the solution to *this* recurrence is just $U_n = 2^n$; hence

$T_n = 2^n - 1.$
"""

# ╔═╡ 48f39949-ccce-4af0-ab02-458af6266f35
md"""
### Solving the Puzzle

In order to actually solve the puzzle, we need a way to compute all the needed moves in the correct order.
For this, we're using the same idea that we had developed for counting the moves:

1. move the ($n-1$) smallest disks from the *starting* tower to the *temporary* tower
2. move the largest disk from *start* to *goal*
3. move the ($n-1$) smallest disks from *temp* to *goal*.

But how can we put that plan into action, that is, how can we derive an algorithm that creates all the necessary moves?
Well, actually we don't have to.
The desrciption above *is* the algorithm, and we use *recursion* to implement it like so:
"""

# ╔═╡ 859e1849-5079-4a3d-a5bf-5db06be47483
begin
	global moves = []

	function solve(n, start, temp, goal)
		n == 0 && return
		solve(n-1, start, goal, temp)
		push!(moves, "$start -> $goal")
		solve(n-1, temp, start, goal)
	end

	solve(3, "start", "temp", "goal")
	moves
end

# ╔═╡ a397469b-9d79-4d15-8a74-ac6348e879db
md"""
The first recursive call of `solve` pushes ($n-1$) disks from *start* to *temp*, using *goal* as the intermediate tower.
The second recursive call of `solve` pushes ($n-1$) disks from *temp* to *goal*, using *start* as the intermediate tower.
Between those two recursive calls the current move (from *start* to *goal*) is recorded within the `moves` vector.
If $n=0$ (*base case*) do nothing.

Let's convince ourselves that the algorithm uses the minimal number of moves for solving: $T_8 = 2^8 - 1 = 255$.
"""

# ╔═╡ 4dd5af18-f139-4d16-808e-caa271438c95
begin
	empty!(moves)
	solve(8, "start", "temp", "goal")
	length(moves)
end

# ╔═╡ 2bd0f2c0-2fc3-452c-b140-e16ae541e1a4
md"""
## Exercises
1) **Proof the formula for the sum of the first $n$ even numbers $S_n = \sum_{k=1}^n 2k = n(n+1)$ by mathematical induction**.

!!! hint "Solution"
	**base case**:\
	For $n_0=1$ we get $1*2=2$, which is correct.
	
	**inductive step**:\
	*induction hypothesis*: $\sum_{k=1}^{n+1} 2k = (n+1)(n+2).$\
	$\begin{align}
	lhs &= \sum_{k=1}^{n} 2k + 2(n+1)\\
	&= n(n+1) + 2(n+1)\\
	&= n^2 + 3n + 2\\
	&= (n+1)(n+2) = rhs \ \square.
	\end{align}$

2) **Derive the sum formula for the first $n$ even numbers of exercise 1 using an [arithmetric progression](https://en.wikipedia.org/wiki/Arithmetic_progression#Sum)**.

!!! hint "Solution"
	The sum of an arithmetric progression can be found by multiplying the number of terms being added ($n$) by the sum of the first and last number in the progression, and dividing by 2:

	$S_n = \frac{n(a_1 + a_n)}{2}.$
	The arithmetric progression for the first $n$ even numbers is: $2,4,6,\dots, 2n$, leading to

	$S_n = \frac{n(2+2n)}{2} = n(1+n) \ \square.$

3) **Derive the sum formula for the first $n$ even numbers of exercise 1 using the sum formula for the first $n$ numbers**.

!!! hint "Solution"

	$S_n = \sum_{k=1}^n 2k = 2\sum_{k=1}^n k = 2\frac{n(n+1)}{2} = n(n+1) \ \square.$

4) **Give a function definition for computing the [binomial coefficient](https://en.wikipedia.org/wiki/Binomial_coefficient) defined by $\binom{n}{k}=\frac{n!}{k!(n-k)!}$ using the `facImp` function from this lesson**.
"""

# ╔═╡ 436e7a32-5d98-441b-a15b-bcc61948f6f2
function binom(n, k)
	k
end

# ╔═╡ dc138f94-62ca-4954-8d70-3dbdf4465eec
if binom(6, 49) == binomial(6, 49)
	correct(md"Congratulations! You've completed this lesson successfully.")
else
	keep_working(md"Your solution is not quite right.")
end

# ╔═╡ 956844b3-a787-45ba-a725-98bf5cde9796
md"""
!!! hint "Solution"
	```{julia}
	function binom(n, k)
		div(facImp(n), facImp(k) * facImp(n-k))
	end
	```
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
Luxor = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
MathTeXEngine = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"

[compat]
BenchmarkTools = "~1.5.0"
Luxor = "~4.0.0"
MathTeXEngine = "~0.5.7"
Plots = "~1.40.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "e43749db55f3035fd10d62193d4a81dcc25968f3"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Automa]]
deps = ["PrecompileTools", "TranscodingStreams"]
git-tree-sha1 = "588e0d680ad1d7201d4c6a804dcb1cd9cba79fbb"
uuid = "67c07d97-cdcb-5c2c-af73-a7f9c32a568b"
version = "1.0.3"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "f1dff6729bc61f4d49e140da1af55dcd1ac97b2f"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.5.0"

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a4c43f59baa34011e303e76f5c8c91bf58415aaf"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.0+1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "c955881e3c981181362ae4088b35995446298b80"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.14.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.0+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "6cbbd4d241d7e6579ab354737f4dd95ca43946e1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.1"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "260fd2400ed2dab602a7c15cf10c1933c59930a2"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.5"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c6317308b9dc757616f0b5cb379db10494443a7"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.2+0"

[[deps.Extents]]
git-tree-sha1 = "2140cd04483da90b2da7f99b2add0750504fc39c"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.2"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.FreeType]]
deps = ["CEnum", "FreeType2_jll"]
git-tree-sha1 = "907369da0f8e80728ab49c1c7e09327bf0d6d999"
uuid = "b38be410-82b0-50bf-ab77-7b57e271db43"
version = "4.1.1"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FreeTypeAbstraction]]
deps = ["ColorVectorSpace", "Colors", "FreeType", "GeometryBasics"]
git-tree-sha1 = "2493cdfd0740015955a8e46de4ef28f49460d8bc"
uuid = "663a7486-cb36-511b-a19d-713bb74d65c9"
version = "0.10.3"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "ff38ba61beff76b8f4acad8ab0c97ef73bb670cb"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.9+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "3437ade7073682993e092ca570ad68a2aba26983"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.3"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a96d5c713e6aa28c242b0d25c1347e258d6541ab"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.3+0"

[[deps.GeoInterface]]
deps = ["Extents"]
git-tree-sha1 = "801aef8228f7f04972e596b09d4dba481807c913"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.3.4"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "Extents", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "b62f2b2d76cee0d61a2ef2b3118cd2a3215d3134"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.11"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "359a1ba2e320790ddbe4ee8b4d54a305c0ea2aff"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.0+0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "2c3ec1f90bb4a8f7beafb0cffea8a4c3f4e636ab"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.6"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "a53ebe394b71470c7f97c2e7e170d51df21b17af"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.7"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3336abae9a713d2210bb57ab484b1e065edd7d23"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "e0b5cd21dc1b44ec6e64f351976f961e6f31d6c4"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.3"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "9fd170c4bbfd8b935fdc5f8b7aa33532c991a673"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.11+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4b683b19157282f50bfd5dcaa2efe5295814ea22"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.0+0"

[[deps.Librsvg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pango_jll", "Pkg", "gdk_pixbuf_jll"]
git-tree-sha1 = "ae0923dab7324e6bc980834f709c4cd83dd797ed"
uuid = "925c91fb-5dd6-59dd-8e8c-345e74382d89"
version = "2.54.5+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "27fd5cc10be85658cacfe11bb81bee216af13eda"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "18144f3e9cbe9b15b070288eef858f71b291ce37"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.27"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.Luxor]]
deps = ["Base64", "Cairo", "Colors", "DataStructures", "Dates", "FFMPEG", "FileIO", "PolygonAlgorithms", "PrecompileTools", "Random", "Rsvg"]
git-tree-sha1 = "97e13acec42f02139fcf1b2035010d5e3369d070"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "4.0.0"
weakdeps = ["LaTeXStrings", "MathTeXEngine"]

    [deps.Luxor.extensions]
    LuxorExtLatex = ["LaTeXStrings", "MathTeXEngine"]

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MathTeXEngine]]
deps = ["AbstractTrees", "Automa", "DataStructures", "FreeTypeAbstraction", "GeometryBasics", "LaTeXStrings", "REPL", "RelocatableFolders", "UnicodeFun"]
git-tree-sha1 = "96ca8a313eb6437db5ffe946c457a401bbb8ce1d"
uuid = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53"
version = "0.5.7"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3da7367955dcc5c54c1ba4d402ccdc09a1a3e046"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.13+1"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "cb5a2ab6763464ae0f19c86c56c63d4a2b0f5bda"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.52.2+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "7b1a9df27f072ac4c9c7cbe5efb198489258d1f5"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "442e1e7ac27dd5ff8825c3fa62fbd1e86397974b"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.4"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PolygonAlgorithms]]
git-tree-sha1 = "a5ded6396172cff3bacdd1354d190b93cb667c4b"
uuid = "32a0d02f-32d9-4438-b5ed-3a2932b48f96"
version = "0.2.0"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "37b7bb7aabf9a085e0044307e1717436117f2b3b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rsvg]]
deps = ["Cairo", "Glib_jll", "Librsvg_jll"]
git-tree-sha1 = "3d3dc66eb46568fb3a5259034bfc752a0eb0c686"
uuid = "c4c386cf-5103-5370-be45-f3a111cca3b8"
version = "1.0.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "bf074c045d3d5ffd956fa0a461da38a44685d6b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.3"

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

    [deps.StaticArrays.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

[[deps.StructArrays]]
deps = ["ConstructionBase", "DataAPI", "Tables"]
git-tree-sha1 = "f4dc295e983502292c4c3f951dbb4e985e35b3be"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.18"

    [deps.StructArrays.extensions]
    StructArraysAdaptExt = "Adapt"
    StructArraysGPUArraysCoreExt = "GPUArraysCore"
    StructArraysSparseArraysExt = "SparseArrays"
    StructArraysStaticArraysExt = "StaticArrays"

    [deps.StructArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "71509f04d045ec714c4748c785a59045c3736349"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.7"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "3c793be6df9dd77a0cf49d80984ef9ff996948fa"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.19.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "93f43ab61b16ddfb2fd3bb13b3ce241cafb0e6c9"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.31.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "532e22cf7be8462035d092ff21fada7527e2c488"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.6+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ac88fb95ae6447c8dda6a5503f3bafd496ae8632"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.6+0"

[[deps.Xorg_libICE_jll]]
deps = ["Libdl", "Pkg"]
git-tree-sha1 = "e5becd4411063bdcac16be8b66fc2f9f6f1e8fe5"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.0.10+1"

[[deps.Xorg_libSM_jll]]
deps = ["Libdl", "Pkg", "Xorg_libICE_jll"]
git-tree-sha1 = "4a9d9e4c180e1e8119b5ffc224a7b59d3a7f7e18"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.3+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e678132f07ddb5bfa46857f0d7620fb9be675d3b"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.6+0"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[deps.gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "86e7731be08b12fa5e741f719603ae740e16b666"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.10+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d7015d2e18a5fd9a4f47de711837e980519781a4"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.43+1"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─d8d70b1c-12b4-11ef-161c-21e7e562639a
# ╟─211c457d-756e-4f93-a883-3b1ec4ddbf9d
# ╠═6fc9840a-8178-4539-8f34-9e3c2eeaf14b
# ╟─ef05dee5-0386-47de-b46c-3fb0e06f9a55
# ╟─5ae6e717-b158-4664-bf46-ef6393742203
# ╟─02c404ac-8029-4fac-a0e7-62990a947d5f
# ╟─2c8b5d80-1a66-4d5a-b273-73f9e74d12e5
# ╟─3e22ce56-8a66-4869-bff9-5affede043c4
# ╟─b803c184-b435-420f-9bf7-ce7ab5ec2269
# ╟─918847f2-efdc-4934-a01f-b0e147926585
# ╟─5e1f8525-8d6e-4faf-8e34-8a0272b31e4d
# ╟─95d5ef99-7634-48ef-b07a-8469af335335
# ╟─2a6c367c-531a-4b16-a8d9-224e5c177031
# ╟─c57c16a7-dea8-4b44-87cc-2bde733b4bfb
# ╠═97fbdfdc-9400-4b45-bc0a-470bf6178e2c
# ╟─671bd3cb-e081-4e72-91b6-49bc614b985c
# ╠═a012258f-e65b-41ab-be79-cffcc837b2d8
# ╠═94faa5d5-0bf5-4d42-80ec-fa3a81102a33
# ╠═1d8ac2b9-1100-4a35-baaf-d8b14e18807d
# ╟─42f0052c-79e4-471d-91c6-4b5074391b0e
# ╠═eb70769a-5b28-48d8-baca-90ab16beb7b1
# ╠═6aebe83e-0e33-457b-b73e-79059f79cd97
# ╠═827976d7-f93a-4d26-9fc0-652c142fad5f
# ╟─48be45cc-2a02-4cd1-94f5-447a99ece868
# ╟─6a509eb7-dde7-4f56-974e-89d100ed3cf2
# ╟─df48e493-30a6-41bd-857f-79a5a9c6b90c
# ╟─6ab7723c-c16f-46ee-b5d3-3b3ef5b88fdb
# ╠═ca9ae417-c56f-492a-ab5c-0e9cd0df8728
# ╟─8b30de72-2b64-48e3-953a-caf82334eab4
# ╠═8b1ba980-9f15-4465-baef-0bfe66033984
# ╟─d2449cd0-ecdc-4293-addd-983a0e017552
# ╠═489ba4d3-3f02-4ad4-a8c0-7619c4dacd70
# ╟─e2d73c9f-8399-4c34-bded-4175d154a286
# ╠═6030bde8-a610-4703-936c-0a9a12c29505
# ╠═32c7bd76-1c8d-4471-810d-d03d245e17d6
# ╟─0e1e9caa-6970-470b-9d12-9157cbfa4722
# ╠═31acc697-21c8-4df1-a598-d29f6d7f66d8
# ╟─cb4c8e2e-9b60-4df4-bba2-e7d28f3e88ee
# ╠═627d75cd-802f-49df-9a5f-8e20cc918496
# ╟─a9797347-0a67-4b70-a1a2-ea90d6a83b1b
# ╠═dd130192-6f03-4a12-ae3c-a21cf4f04093
# ╟─54feffb2-3404-4667-bdd0-c36f0e965aea
# ╠═d91101a2-d2a7-45fe-9dd6-7ca223bf9d52
# ╟─37f4196c-0fa3-474d-8ac9-5517e5546897
# ╠═6133cc2a-c768-41c4-87d5-a717bc34b449
# ╟─42c1ed7e-2eb1-4bbb-aca7-9fd0c9d785ff
# ╠═a3cddb5c-ee9a-4e43-9cbc-b4abf14b01be
# ╠═e78b6cdf-f8d0-4f6d-86f1-090986cd93fd
# ╠═83e5b18e-910e-4c5b-9ae3-64126e08cabf
# ╟─81f0e921-2376-4d76-ad31-2157f82caa1b
# ╟─7a29c871-cae6-445f-be51-846ddf57a668
# ╟─6b3b197b-e468-4044-bd17-542314908b84
# ╟─13e2636e-c971-4c4b-b2df-8fabdc3f7f77
# ╠═0c649fca-f86d-453f-bf02-7b707789fe88
# ╟─4f143dbe-7a32-48f7-8ef9-7a0504426be3
# ╟─48f39949-ccce-4af0-ab02-458af6266f35
# ╠═859e1849-5079-4a3d-a5bf-5db06be47483
# ╟─a397469b-9d79-4d15-8a74-ac6348e879db
# ╠═4dd5af18-f139-4d16-808e-caa271438c95
# ╟─2bd0f2c0-2fc3-452c-b140-e16ae541e1a4
# ╠═436e7a32-5d98-441b-a15b-bcc61948f6f2
# ╟─dc138f94-62ca-4954-8d70-3dbdf4465eec
# ╟─956844b3-a787-45ba-a725-98bf5cde9796
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
