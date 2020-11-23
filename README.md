# Haskell-Decision-Tree
This is a project in the context of the Universitat Politècnica de Barcelona (FIB)
in the subject Llenguatges de Programació.
In this project we can find a implementation of a Decision Tree with a dataSet of Mushrooms.
The objective of the project is to print the decision tree and then do questions about the
mushroom you want to know is edible or poisonous.
The statement of the project is defined in this [repository](https://gebakx.github.io/hs-dts/)

## Installation
The `dts.hs` file is what sets up, runs, and evaluates a simple decision tree learner on a
data set supplied via the command line.

To build this we need to have the Data/List.Split folder in the root program. You can download it in the repository
or download the library in the [source page](https://hackage.haskell.org/package/base-4.14.0.0/docs/Data-List.html).
I have used this library to use the function `splitOn`, which given a `a -> [a] -> [[a]]` return the `[a]` splited
by the first parameter. 

To build this program, use:

	`ghc dts.hs`

Which will create an executable dts.exe

## Usage 
To evaluate the Data Base and return a readable tree use:

	`./dts.exe`

When the Tree shows, then the program will ask you some questions about the mushroom you
want to know is edible or poisonous.
The possible characters for every attribute are setted in the
[DataBase / Attribute Section](https://archive.ics.uci.edu/ml/datasets/Mushroom)

## Credits
- Jeff Schlimmer, 1981. [Mushroom Data Set. UCI Machine Learning Repository.](https://archive.ics.uci.edu/ml/datasets/Mushroom)
- Hackage Haskell community. [Data.List](https://hackage.haskell.org/package/base-4.14.0.0/docs/Data-List.html)
- Gerard Escudero, 2020. [Machine Learning](https://gebakx.github.io/ml/#1).
- Devesh Poojari, Aug 1, 2019. “[Machine Learning Basics: Descision Tree From Scratch (Part II)](https://towardsdatascience.com/machine-learning-basics-descision-tree-from-scratch-part-ii-dee664d46831).”

## License
[GNU General Public License v3.0](LICENSE)
