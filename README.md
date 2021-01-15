# computer_vision
 

In this repository you can find the code developed for a Sudoku solver using Computer Vision techniques.
This work has been developed within the framework of the Computer Vision course, belonging to the  Master's Degree
in Automation and Robotics of the Polytechnic University of Madrid.

It is developed in Matlab and it's organized as follows:

 - Inside the Sudoku Benchmark folder, you can find the captured images of the Sudokus.

 - On the other hand, the application code is in the Code folder, which contains different Matlab files:
     
     - main.m: contains the main code of the application.
     
     - find_sudoku.m: function which detects the global squares of sudoku.
       
        - signature.m: subfunction of the find_sudoku function which calculates the signature representation scheme.
     
     - find_cells.m: function which detects each of the cells of the square segmented by the find_sudoku function.
     
     - get_numbers.m: main function of the program used for number identification. In addition to returning the 
        identified number, it detects whether it is rotated or not, and corrects it. 
       
        - empty_squares_detection.m: subfunction which filters each cell obtained from the find_cells function, 
          and identifies if there is a number or not, to send it to the get_number function.
        
        - Num_identification.m: subfunction which identifies which number is in each case.

     - sudoku_solver.m: function implemented by Cleve Moler in MathWorks, which solves the Sudoku puzzle 
         from a matrix containing the unsolved Sudoku.

     - SudokuSolver.mlapp: graphic user interface in order to make our code easier to use and understand its results.