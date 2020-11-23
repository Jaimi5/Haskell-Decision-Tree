# Haskell-Decision-Tree
This is a project in the context of the Universitat Politècnica de Barcelona (FIB)
in the subject Llenguatges de Programació.
In this project we can find a implementation of a Decision Tree with a dataSet of Mushrooms.
The objective of the project is to print the decision tree and then do questions about the
mushroom you want to know if is edible or poisonous.

## Table of Contents

## Installation
The `dts.hs` file is what sets up, runs, and evaluates a simple decision tree learner on a
data set supplied via the command line.

To build this program, use:

	`ghc dts.hs`

Which will create an executable dts.exe

To evaluate the Data Base and return a readable tree use:

	`./dts.exe`

When the Tree shows, then the program will ask you some questions about the mushroom you
want to know if is edible or poisonous.
The possible characters for every attribute are setted in the
[DataBase / Attribute Section](https://archive.ics.uci.edu/ml/datasets/Mushroom)

## Credits
[DataBase](https://archive.ics.uci.edu/ml/datasets/Mushroom)
[Data.List](https://hackage.haskell.org/package/base-4.14.0.0/docs/Data-List.html)

## License
[GNU General Public License v3.0](LICENSE)
