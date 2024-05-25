### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# ╔═╡ 9e101b16-5cfd-42b8-b515-0fa685db0449
begin
	using Markdown
	using Luxor
	using MathTeXEngine
	
	keep_working(text=md"The answer is not quite right.") =
	  Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]));
	
	almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]));
	
	correct(text=md"You got the right answer! Move on to the next exercise.") =
	  Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]));

	"🏁"
end

# ╔═╡ 5b99059d-12d0-4824-a73f-e42a789fca7c
md"""
# Mathematical Logic
## Basic Set Theory

[Set Theory](https://en.wikipedia.org/wiki/Set_theory) is commonly accepted as the foundational system of mathematics, particularly in the form of the axiomatic [Zermelo–Fraenkel](https://en.wikipedia.org/wiki/Zermelo%E2%80%93Fraenkel_set_theory) set theory with the axiom of choice.

Besides its foundational role, set theory also provides the framework to develop a *mathematical theory of infinity*, and has various applications in computer science (such as in the theory of relational algebra), philosophy, formal semantics, and evolutionary dynamics.
"""

# ╔═╡ d6e9c695-5b1c-4d84-9b2f-996dba657ef3
md"""
The basic rules for operating with sets are:

!!! warning "Definitions"
	- A *set* is an unorderd collection of distinct objects, which are called *elements*.
	- If ``x`` is an element of set ``S``, we write ``x \in S``. This is read as '*x in S*'.
	- *Set-builder notation* is written like this: ``S = \{variable \mid predicate\}``, where the vertical bar is read as '*such that*'.
	- The *cartesian product* ``A \times B = \{(a, b) \mid a \in A \ \textrm{and} \ b \in B\}`` is the set of ordered pairs of all elements in A and B.
	- The set containing no elements is called the *empty set* and is denoted with ``\emptyset``.
	- If ``x \in B`` for every ``x \in A``, then ``A`` is a *subset* of ``B``, which is denoted as ``A \subseteq B``.
	- ``A \cap B = \{x \in A \ \textrm{and} \ x \in B\}`` is the *intersection* of ``A`` and ``B``.
	- ``A \cup B = \{x \in A \ \textrm{or} \ x \in B\}`` is the *union* of ``A`` and ``B``.
	
	- ``U`` is the *universal set*, which contains all sets of discourse.
	- ``A^C = U \setminus A = \{x \mid x \in U \textrm{ and } x \notin A\}`` is the (absolute) *complement* of ``A``.
	- ``A \setminus B = \{x \mid x \in A \textrm{ and } x \notin B\}`` is the (relative) *complement* of ``B`` in ``A``, also called the *difference* of ``A \textrm{ and } B``.
	- ``A \Delta B = (A \setminus B) \cup (B \setminus A)`` is the *symmetric difference* of ``A \textrm{ and } B``; it contains all elements that are in either set, but not in their intersection.
	- The *power set* of a set ``A`` is ``\mathcal{P}(A) = \{X \mid X \subseteq A\}``. 
"""

# ╔═╡ c857a0d6-3302-4085-a4de-55c32ad0ff5f
md"""
!!! tip "Examples for set-builder notation"
	- ``\{x \in \mathbb{R} \mid x > 0\}`` is the set of all strictly positive *real numbers*
	- ``\{2n \mid n \in \mathbb{N}\}`` is the set of all even natural numbers
	- ``\{2z + 1 \mid z \in \mathbb{Z}\}`` is the set of all odd integer numbers
	- ``\mathbb{Q} = \{\frac{p}{q} \mid p, q \in \mathbb{Z}, q \neq 0\}`` is the set of *rational numbers*
	- ``\{(x, y) \in \mathbb{R} \times \mathbb{R} \mid 0 < y < f(x)\}``  is the set of pairs of real numbers such that y is greater than ``0`` and less than ``f(x)``, for a given function f.

Basic set operations can be illustrated with [Venn diagrams](https://en.wikipedia.org/wiki/Venn_diagram):
"""

# ╔═╡ 1057ab6f-987d-4455-a9f2-fe79a4cf764b
begin
	Drawing(600, 400, "set-operations.svg")
	fontface("Arial")
	fontsize(20)
	setcolor("black")
	
	a = Point(100, 100)
	b = Point(200, 100)
	a1 = Point(400, 100)
	b1 = Point(500, 100)
	a2 = Point(100, 300)
	b2 = Point(200, 300)
	a3 = Point(400, 300)
	b3 = Point(500, 300)
	
	circle(a, 80, action=:stroke)
	circle(b, 80, action=:stroke)
	setcolor(0.8, 0.8, 0)
	circle(a, 80, :clip)
	circle(b, 80, :fill)
	clipreset()
	circle(a1, 80, :fill)
	circle(b1, 80, :fill)
	setcolor("black")
	circle(a1, 80, :stroke)
	circle(b1, 80, :stroke)
	setcolor("white")
	circle(a1, 80, :clip)
	circle(b1, 80, :fill)
	clipreset()
	setcolor(0.8, 0.8, 0)
	circle(a2, 80, action=:fill)
	circle(b2, 80, action=:fill)
	setcolor("black")
	circle(a2, 80, action=:stroke)
	circle(b2, 80, action=:stroke)
	circle(a3, 80, action=:stroke)
	setcolor(0.8, 0.8, 0)
	circle(a3, 80, action=:fill)
	setcolor("black")
	circle(b3, 80, action=:stroke)
	setcolor("white")
	circle(b3, 80, action=:fill)

	setcolor("black")
	text("A", Point(60,60))
	text("B", Point(230,60))
	text("A", Point(360,60))
	text("B", Point(530,60))
	text("A", Point(60,260))
	text("B", Point(230,260))
	text("A", Point(360,260))
	text("B", Point(530,260))
	fontsize(14)
	text("intersection", Point(120, 200))
	text("symmetric difference", Point(390, 200))
	text("union", Point(130, 400))
	text("difference", Point(420, 400))
	
	finish()
	preview()
end

# ╔═╡ f12aeb69-da18-499f-ad88-60384e3ac4df
md"""
### Working with sets in Julia
We can create the equivalent of a set with list comprehensions like so:
"""

# ╔═╡ 12df1d0b-b377-4d21-997f-ff0237e86118
A = [n for n ∈ 2:2:20] # the first 10 even natural numbers

# ╔═╡ 3abe46a6-cec2-4be7-bde9-822b02471d32
B = [n for n ∈ 1:2:20] # the first 10 odd natural numbers

# ╔═╡ 7d36c92e-c761-4e7f-9dc7-0cb7aa287169
md"""
There are also operators for working with sets:
- ∪ : union (\cup)
- ∩ : intersection (\cap)
- ⊆ : subset (\subseteq)

To get those symbols, type the expression in parentheses (including the leading backslash) and hit <Tab>.
Alternatively, you can also call their respective functions (`union`, `intersect`, `issubset`, `setdiff`).
"""

# ╔═╡ 9d66303a-9475-4800-9ab9-8974264a6cd0
AorB = A ∪ B

# ╔═╡ 385b1b24-6639-45e7-a2de-2ce5ccca81e9
AandB = A ∩ B

# ╔═╡ 59994588-4bdf-47c5-9788-a32204b2618d
A ⊆ AorB

# ╔═╡ d02cb1ec-2eb3-4bb5-aa29-98d1b28b3a73
setdiff(AorB, A) == B

# ╔═╡ dcafbc31-c479-419c-8ef7-7ea5261944b3
md"""
## Propositional Logic

*Propositional Logic* is, besides set theory, the cornerstone of modern mathematics. Without it, we weren't able to give precise mathematical arguments.

### Reasoning about mathematical statements

Propositional logic describes patterns for reasoning about the validity of *mathematical statements*, where the validity depends only on the *logical connectives* `if...then`, `and`, `or`, and `not`.

!!! warning "Definition of a Mathematical Proposition"
	A **proposition** is the meaning of a declarative sentence.
	A proposition in the *mathematical sense* is a statement that is either *true* or *false*.

Some examples for valid propositions:

!!! tip "Examples of Propositions"
	- Susan is ill.
	- The train is late.
	- It's going to start raining soon.
	- Blue is a color.
	- ``1 + 1 = 2``
	- ``(a + b)^2 = a^2 + 2ab + b^2``

These would *not* be valid propositions:

!!! tip "Counterexamples"
	- What's up?
	- Stop it!
	- Blue is a nice color.
	- Better late than never.
"""

# ╔═╡ 11b366ca-5e4d-4ba9-ad1a-967ffbc2ac51
md"""
We are using *logical connectives* to create *compound statements*, that is, statements that contain subparts that are themselves statements:

| logical operator    | julia operator | designation   | meaning        |
|:-------------------:|:--------------:|:--------------|:---------------|
| ``\neg``            | `!`            | negation      | not            |
| ``\land``           | `&&`           | conjunction   | and            |
| ``\lor``            | `\|\|`         | disjunction   | or             |
| ``\Rightarrow``     |                | implication   | if...then      |
| ``\Leftrightarrow`` |  `==`          | bidirectional | if and only if |

!!! note "Equivalence vs. Bidirectional"
	In some sources ``\Leftrightarrow`` is designated as *equivalence* with the same meaning as *bidirectional*.
	But for this course we will distinguish between them: we use the *bidrectional* operator ``\Leftrightarrow`` for creating a single compound statement, whereas the *equivalence* operator ``\equiv`` is used to compare the truth values of two separate statements.
	In that sense, *bidrectional* is defined by: ``(p \Leftrightarrow q) \equiv (p \Rightarrow q) \land (q \Rightarrow p)``, which reads as "*(p if and only if q) is equivalent to (p implies q) and (q implies p)*".

Mathematical logic is mostly concerned with the *semantical meaning* of a proposition (i.e. the *truthfulness* of a proposition), whereas pilosophical logic is all about the *syntactic correctness* of a logical argument (whether it is derived from a valid pattern of reasoning).

In order to conduct *mathematical proofs*, we need to create correct arguments, which could only be derived from a valid pattern of reasoning, where *modus ponens* and *modus tollens* are the basic patterns of a proof system called [natural deduction](https://en.wikipedia.org/wiki/Natural_deduction).

**modus ponens**:
1. ``\quad p \Rightarrow q \quad`` (*if p then q*)
2. ``\quad p \quad \quad \quad`` (*p is true*)
3. ``\quad q \quad \quad \quad`` (*therefore: q is true*)

**modus tollens**:
1. ``\quad p \Rightarrow q \quad`` (*if p then q*)
2. ``\quad \neg q \quad \quad \:`` (*q is false*)
3. ``\quad \neg p \quad \quad \:`` (*therefore: p is false*)

where (1) and (2) are called the *premisses* and (3) is called the *conclusion* of the argument.
In general, we use modus ponens for *direct proofs* and modus tollens for *proofs by contradiction*.
"""

# ╔═╡ af54e5ad-8007-4208-972b-bb7c0a952449
md"""
For a deeper understanding of what's going on, let's look at the *truth table* for
implication:

| p   | q   | ``p \Rightarrow q `` |
|:---:|:---:|:--------------------:|
| T   | T   | T                    |
| T   | F   | F                    |
| F   | T   | T                    |
| F   | F   | T                    |

where `p` and `q` are called the *antecedent* and *consequent*, respectively.

!!! note "Ex falso quodlibet"
	An *implication* evaluates only in one case to *false*: if the antecedent *p* is true and the consequent *q* is false.
	It may seem counterintuitive that the outcome is always *true* if the anticedent *p* is *false*.
	But this is the fundamental rule of *modus ponens*, which is sometimes called *ex falso qodlibet*, meaning that from a false antecedent one can derive anything.

	The story is told that *Bertrand Russel*, trying to explain that fact to a journalist, was asked to prove that he is the Pope of Rome, assuming the (obviously false) antecedent ``1+1=3``. His answer:
	"*Well, ``1+1=3``. I subtract ``1`` from both sides, leading to ``1 = 2``. Thus, two equals one. The Pope and I are two persons, but we're also one person, therefore I'm the Pope of Rome*".

Let's analyze Russels example:
1. If ``1=2`` then I am the pope of Rome.
2. I am not the Pope of Rome.
3. Therefore: ``1 \neq 2``

This is a correct argument, since it follows from a valid logical pattern (modus tollens), but the argument
1. If ``1=2`` then I am the pope of Rome.
2. ``1 \neq 2``
3. Therefore: I am *not* the Pope of Rome

would be incorrect, since it doesn't follow from a valid logical pattern.
Think about it: what if the Pope himself gave that argument?

Another way to look at *implication* is in terms of [necessity and sufficiency](https://en.wikipedia.org/wiki/Necessity_and_sufficiency):\
in the conditional statement: "If $P$ then $Q$", $Q$ is *necessary* for $P$, because the truth of $Q$ is guaranteed by the truth of $P$.
Equivalently, it is *impossible* to have $P$ without $Q$, or the falsity of $Q$ ensures the falsity of $P$.\
Similarly, $P$ is *sufficient* for $Q$, because $P$ being true always implies that $Q$ is true, but $P$ not being true does *not always* imply that $Q$ is not true.

Consider the statement "*If I throw a stone through a window, the window pane breaks*".\
Here, breaking the pane is *necessary*, for otherwise I couldn't throw a stone trough the window, and the stone will just bounce off the pane.\
On the other hand, throwing the stone is *not* necessarily the only way to break the pane; I could have done that for example with a hammer.
But, throwing the stone is *sufficient* for breaking the pane.

!!! note "Logical Notation"
	We can express valid logical patterns with *logical notation* like so:
	- *modus ponens*: ``P_1 \to P_2, P_1 \vdash P_2``
	- *modus tollens*: ``P_1 \to P_2, \neg P_2 \vdash \neg P_1``
	These are examples of *sequents*, where the antecedents are listed before ``\vdash``, and the succedents are listed after ``\vdash``.
	A sequent is valid if everything that satisfies all of the antecedents satisfies at least one of the succedents.
	So, *modus ponens* reads as: "``(P_1 \textrm{ implies } P_2 \textrm{, and } P_1) \textrm{ satisfies } P_2``". 
"""

# ╔═╡ 04c6f1db-d202-49ab-b599-b7f04074d548
md"""
Equipped with a basic understanding of propositional logic, we can now give some basic definitions of how to work with logical connectives:

!!! warning "Laws of Boolean Algebra"
	1. Law of double negation: ``\neg \neg P \equiv P``
	2. Law of idempotence: ``P \land P \equiv P``
	3. Law of commutativity: ``P \land Q \equiv Q \land P``
	4. Law of associativity: ``P \land (Q \land R) \equiv (P \land Q) \land R``
	5. Distribution law: ``P \land (Q \lor R) \equiv (P \land Q) \lor (P \land R)``
	6. Law of contraposition: ``P \Rightarrow Q \equiv \neg Q \Rightarrow \neg P``

Notice that the laws (2) - (5) also exist for *disjunction* with the same consequences (just exchange ``\land`` and ``\lor``).
Also observe that the *law of contraposition* (6) is a direct consequence of *modus tollens*.

### De Morgan's Theorem

Building up on these rules we can turn our interest to the following *theorem*, named after *Augustus De Morgan*, a 19th-century British mathematician:

!!! danger "De Morgan's theorem"
	1. ``\neg (P \lor Q) \equiv \neg P \land \neg Q``
	2. ``\neg (P \land Q) \equiv \neg P \lor \neg Q``

These rules allow the expression of *conjunctions* and *disjunctions* purely in terms of each other via negation.
The rules can be expressed in plain English as:
1. The negation of a *disjunction* is the conjunction of the negations.
2. The negation of a *conjunction* is the disjunction of the negations.

With the help of *set theory*, we can express these rules also as: 
1. The complement of the union of two sets is the same as the intersection of their complements
2. The complement of the intersection of two sets is the same as the union of their complements,

leading to an alternative notation of *De Morgan's* laws:

!!! danger "De Morgan's theorem (expressed via set theory)"
	1. ``\overline{A \cup B} = A^C \cap B^C``
	2. ``\overline{A \cap B} = A^C \cup B^C``,
	where ``A`` and ``B`` are sets, and ``\overline{A \cup B}`` is the *complement* of ``A \cup B``.

We can illustrate thoses rules with a *Venn* diagram:
"""

# ╔═╡ 7a54a98a-a36b-4fd3-8da7-986870b6713c
begin
	Drawing(700, 210, "deMorgan.svg")
	fontface("Arial")
	fontsize(20)
	setcolor("black")
	
	c = Point(100, 100)
	d = Point(200, 100)
	c1 = Point(500, 100)
	d1 = Point(600, 100)

	setcolor(0.8, 0.8, 0)
	rect(Point(0, 0), 300, 210, action = :fill)
	rect(Point(400, 0), 300, 210, action = :fill)
	
	setcolor(1, 0.5, 0.5)
	circle(c, 80, action=:fill)
	circle(d, 80, action=:fill)
	setcolor("black")
	circle(c, 80, action=:stroke)
	circle(d, 80, action=:stroke)
	
	circle(c1, 80, action=:stroke)
	circle(d1, 80, action=:stroke)
	setcolor(1, 0.5, 0.5)
	circle(c1, 80, :clip)
	circle(d1, 80, :fill)
	clipreset()
	

	setcolor("black")
	text("1.", Point(10,20))
	text("A", Point(60,60))
	text("U", Point(280,20))
	text("B", Point(230,60))
	text("2.", Point(410,20))
	text("A", Point(460,60))
	text("B", Point(630,60))
	text("U", Point(680,20))
	fontsize(16)
	text(L"\overline{A \cup B} = A^C \cap B^C", Point(100, 200))
	text(L"\overline{A \cap B} = A^C \cup B^C", Point(500, 200))
	
	finish()
	preview()
end

# ╔═╡ d2854451-da31-4c77-8af8-f26acd5ccf5b
md"""
In each case, the resulting set is the set of all points shaded in green.

### Logic with Julia
You may have noticed that there's no built-in operator for *implication* in Julia.
So, we're going to build an equivalent function for ourselves
"""

# ╔═╡ 381b356f-715e-4ce6-95e0-0d7b8ad9a165
begin
	implies(p::Bool, q::Bool) = !p ? true : q

	@show implies(true, true)
	@show implies(true, false)
	@show implies(false, true)
	@show implies(false, false)
end

# ╔═╡ 27a862bd-6340-46fa-b020-ebe1bbb8eac0
md"""
and we see that it is working correctly by giving the expected values from the truth table for *implication*.
Now, let's use this function for testing the *law of contraposition*:
"""

# ╔═╡ 609b644e-f0ba-403e-b20f-91b943279507
implies(true, true) == implies(false, false)

# ╔═╡ 17642d8e-2f17-4677-a800-8af0280aeb3b
md"""
But if we wanted to *prove* the *law of contraposition*, we would have to check for every possible combination of the two boolean values, that is, the *cartesian product*

$\begin{equation}
A \times A, \quad \textrm{where } A = \{true, false\},
\end{equation}$

just like we would do for creating a *truth table* for a given logical statement.

In order to spare us the effort of creating that truth table manually, we're going to implement a function `equiv`, which takes two boolean functions as parameters and compares their output for every possible combination of boolean values:
"""

# ╔═╡ 5432fae4-2adf-4449-96c8-274ddcb161f3
function equiv(bf1::Function, bf2::Function)
	all([(bf1(p, q) == bf2(p, q)) for p in [true, false] for q in [true, false]])
end

# ╔═╡ a166f689-6c8b-43df-bf42-b57c59fc14d5
md"""
For calling our new function, we have to define two separate boolean functions, one for the left-hand side (lhs) of the formula to prove, and the other for its right-hand side (rhs).

Remember, the law of contraposition is given by: ``P \Rightarrow Q \equiv \neg Q \Rightarrow \neg P``.
"""

# ╔═╡ 5da4b595-b628-49fd-bbd4-c4504f487987
begin
	lcp_lhs(p, q) = implies(p, q)
	lcp_rhs(p, q) = implies(!q, !p)
	equiv(lcp_lhs, lcp_rhs)
end

# ╔═╡ d20fd9d8-807a-44f5-8476-e8f2713fd029
md"That works out correctly, but just to be safe, let's check an invalid argument (like the second Russel's argument from above):"

# ╔═╡ b4c18e7f-6e43-4e93-86c2-bd5a51dd8e09
begin
	invalid_lhs(p, q) = implies(p, q)
	invalid_rhs(p, q) = implies(!p, !q)
	equiv(invalid_lhs, invalid_rhs)
end

# ╔═╡ 342684d9-af3d-46b7-8539-1c2d2df2ad79
md"""
Voila, that argument is correctly identified as *invalid*.

I leave it to you, whether you accept this procedure as a mathematical proof; I certainly would.
"""

# ╔═╡ d1160c0e-0494-4237-abe0-d03ea47f8fc7
md"""
## Exercises
1) Let ``C`` the set of the squares of the first 10 natural numbers, and ``D`` the set of the first 50 even natural numbers. **What is the intersection of C and D?** (Use the following code cell for your answer.)
"""

# ╔═╡ 2a21906b-f05e-4d9b-abb9-c66991858b3c
begin
	U_CD = []
end

# ╔═╡ 4a7c11c4-f69a-496b-8aad-bcdc66ece56f
if U_CD == [4, 16, 36, 64, 100]
	correct()
elseif length(U_CD) == 5
	almost(md"The number of elements is correct.")
else
	keep_working()
end

# ╔═╡ 01733078-e593-4c4a-88ca-ed93fef52348
md"""
!!! hint "Hint"
	Try to define the sets ``C`` and ``D`` with list comprehensions according to their definition in *set-builder* notation:
	``C = \{n^2 \mid n \in \mathbb{N} \textrm{ and } n \leq 10\}`` and  ``D = \{2n \mid n \in \mathbb{N} \textrm{ and } n \leq 50\}``
"""

# ╔═╡ bf17ba80-b1e9-4b8d-8a86-fe79f5d0a071
md"""
!!! hint "Solution"
	```julia
	begin
		C = [n^2 for n in 1:10]
		D = [2n for n in 1:50]
		U_CD = C ∩ D
	end
	```
"""

# ╔═╡ dd720261-9487-4410-b38f-65dfdf60b8a7
md"""
2) **In a variation of the fomous [fizz-buzz](https://en.wikipedia.org/wiki/Fizz_buzz) game, create the set of natural numbers up to 20, which would have been replaced with `fizz`, `buzz` or `fizz-buzz` in the original game.**
"""

# ╔═╡ 27ba07d9-cd81-4891-9392-54a76356fd80
begin
	fizz_buzz = []
end

# ╔═╡ 4da0ad72-72fb-4299-b5a1-afb25437587b
if sort(fizz_buzz) == [3,5,6,9,10,12,15,18,20]
	correct(md"You got the right answer! Move on to the next section.")
elseif length(fizz_buzz) == 9
	almost(md"The number of elements is correct.")
else
	keep_working()
end

# ╔═╡ 5e14522a-14fc-4066-9d88-523b32bc8f95
md"""
!!! hint "Solution"
	```julia
	begin
		fizz = [f for f ∈ 1:20 if f % 3 == 0]
		buzz = [b for b ∈ 1:20 if b % 5 == 0]
		fizz_buzz = fizz ∪ buzz
	end
	```
	which could be solved equivalently with just a single instruction:
	```julia
	fizz_buzz = [fb for fb ∈ 1:20 if fb % 3 == 0 || fb % 5 == 0]
	```
"""


# ╔═╡ 5d0390e7-f66e-4d78-89c7-868467178513
md"""
3) **Prove the first law of *de Morgan* for *disjunction* by giving a truth table for that statement.**

!!! hint "Solution"
	| p   | q   | ``\neg(P \lor Q)`` | ``\equiv`` | ``\neg P \land \neg Q`` |
	|:---:|:---:|:------------------:|:----------:|:-----------------------:|
	| T   | T   | F                  | **T**      | F                       |
	| T   | F   | F                  | **T**      | F                       |
	| F   | T   | F                  | **T**      | F                       |
	| F   | F   | T                  | **T**      | T                       |

4) **Give an *informal proof* for the second law of *de Morgan* (conjunction), using plain English**.

!!! hint "Solution"
	Consider the following claim: "it is false that P and Q are both true", which can be written as ``\neg(P \land Q)``.\

	In order for this claim to be true, either or both of P and Q must be false, for if they both were true, then the conjunction of P and Q would be true, making its negation false.
	Thus, one or more of P and Q must be false.
	This may be written directly as: ``\neg P \lor \neg Q``.

	Presented in English, this follows the logic: "*since it is false that two things are both true, at least one of them must be false*". 

5) **Prove both laws of *de Morgan* by applying our `equiv` function** (change only the expressions for the literal boolean values ``\{true, false\}`` in the following code cell).
"""

# ╔═╡ de8afa13-10e7-48cb-a258-4ddd4ffe8834
begin
	deMorg1 = equiv((p, q) -> true, (p, q) -> false)
	deMorg2 = equiv((p, q) -> true, (p, q) -> false)
end

# ╔═╡ 33b4ba18-93e2-404d-ac65-a71ccfbef812
deMorg1 && deMorg2 ? correct() : keep_working()

# ╔═╡ 25093e74-19fc-4d60-8abd-8ab552877d1e
md"""
!!! hint "Hint"
	Use [anonymous function definitions](https://docs.julialang.org/en/v1/manual/functions/#man-anonymous-functions) as parameters for `equiv`.

!!! hint "Solution"
	```julia
	begin
		deMorg1 = equiv((p, q) -> !(p || q), (p, q) -> !p && !q)
		deMorg2 = equiv((p, q) -> !(p && q), (p, q) -> !p || !q)
	end
	```
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Luxor = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
MathTeXEngine = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53"

[compat]
Luxor = "~4.0.0"
MathTeXEngine = "~0.5.7"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "59b62e2f0f6bdb6914267acd182e1eda043a2a62"

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

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

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

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

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
git-tree-sha1 = "6355fb9a4d22d867318db186fd09b09b35bd2ed7"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.6.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "27fd5cc10be85658cacfe11bb81bee216af13eda"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Luxor]]
deps = ["Base64", "Cairo", "Colors", "DataStructures", "Dates", "FFMPEG", "FileIO", "PolygonAlgorithms", "PrecompileTools", "Random", "Rsvg"]
git-tree-sha1 = "97e13acec42f02139fcf1b2035010d5e3369d070"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "4.0.0"
weakdeps = ["LaTeXStrings", "MathTeXEngine"]

    [deps.Luxor.extensions]
    LuxorExtLatex = ["LaTeXStrings", "MathTeXEngine"]

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MathTeXEngine]]
deps = ["AbstractTrees", "Automa", "DataStructures", "FreeTypeAbstraction", "GeometryBasics", "LaTeXStrings", "REPL", "RelocatableFolders", "UnicodeFun"]
git-tree-sha1 = "96ca8a313eb6437db5ffe946c457a401bbb8ce1d"
uuid = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53"
version = "0.5.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

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

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

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

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

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

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

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

[[deps.TranscodingStreams]]
git-tree-sha1 = "71509f04d045ec714c4748c785a59045c3736349"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.7"

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

    [deps.TranscodingStreams.weakdeps]
    Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

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

[[deps.gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "86e7731be08b12fa5e741f719603ae740e16b666"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.10+0"

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

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

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
"""

# ╔═╡ Cell order:
# ╟─5b99059d-12d0-4824-a73f-e42a789fca7c
# ╟─d6e9c695-5b1c-4d84-9b2f-996dba657ef3
# ╟─c857a0d6-3302-4085-a4de-55c32ad0ff5f
# ╟─1057ab6f-987d-4455-a9f2-fe79a4cf764b
# ╟─f12aeb69-da18-499f-ad88-60384e3ac4df
# ╠═12df1d0b-b377-4d21-997f-ff0237e86118
# ╠═3abe46a6-cec2-4be7-bde9-822b02471d32
# ╟─7d36c92e-c761-4e7f-9dc7-0cb7aa287169
# ╠═9d66303a-9475-4800-9ab9-8974264a6cd0
# ╠═385b1b24-6639-45e7-a2de-2ce5ccca81e9
# ╠═59994588-4bdf-47c5-9788-a32204b2618d
# ╠═d02cb1ec-2eb3-4bb5-aa29-98d1b28b3a73
# ╟─dcafbc31-c479-419c-8ef7-7ea5261944b3
# ╟─11b366ca-5e4d-4ba9-ad1a-967ffbc2ac51
# ╟─af54e5ad-8007-4208-972b-bb7c0a952449
# ╟─04c6f1db-d202-49ab-b599-b7f04074d548
# ╟─7a54a98a-a36b-4fd3-8da7-986870b6713c
# ╟─d2854451-da31-4c77-8af8-f26acd5ccf5b
# ╠═381b356f-715e-4ce6-95e0-0d7b8ad9a165
# ╟─27a862bd-6340-46fa-b020-ebe1bbb8eac0
# ╠═609b644e-f0ba-403e-b20f-91b943279507
# ╟─17642d8e-2f17-4677-a800-8af0280aeb3b
# ╠═5432fae4-2adf-4449-96c8-274ddcb161f3
# ╟─a166f689-6c8b-43df-bf42-b57c59fc14d5
# ╠═5da4b595-b628-49fd-bbd4-c4504f487987
# ╟─d20fd9d8-807a-44f5-8476-e8f2713fd029
# ╠═b4c18e7f-6e43-4e93-86c2-bd5a51dd8e09
# ╟─342684d9-af3d-46b7-8539-1c2d2df2ad79
# ╟─d1160c0e-0494-4237-abe0-d03ea47f8fc7
# ╠═2a21906b-f05e-4d9b-abb9-c66991858b3c
# ╟─4a7c11c4-f69a-496b-8aad-bcdc66ece56f
# ╟─01733078-e593-4c4a-88ca-ed93fef52348
# ╟─bf17ba80-b1e9-4b8d-8a86-fe79f5d0a071
# ╟─dd720261-9487-4410-b38f-65dfdf60b8a7
# ╠═27ba07d9-cd81-4891-9392-54a76356fd80
# ╟─4da0ad72-72fb-4299-b5a1-afb25437587b
# ╟─5e14522a-14fc-4066-9d88-523b32bc8f95
# ╟─5d0390e7-f66e-4d78-89c7-868467178513
# ╠═de8afa13-10e7-48cb-a258-4ddd4ffe8834
# ╟─33b4ba18-93e2-404d-ac65-a71ccfbef812
# ╟─25093e74-19fc-4d60-8abd-8ab552877d1e
# ╟─9e101b16-5cfd-42b8-b515-0fa685db0449
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
