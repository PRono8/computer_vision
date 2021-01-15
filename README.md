# computer_vision
 

In this repository is the code developed for an identification application 
of Sudokus for academic purposes due to a work in the Computer Vision 
subject of the University Master's Degree in Automation and Robotics of the Polytechnic University of Madrid.

It is developed in Matlab and is organized as follows:

 - Inside the Sudoku Benchmark folder, there are the captured images of the sudokus of different spanish brands.

 - On the other hand, the application code is in the Code folder, which contains different Matlab files:
     
     - main.m: contains the main code of the application.
     
     - find_sudoku.m: function which detects the global squares of sudoku.
       
        - signature.m: subfunction of the find_sudoku function which calculates the signature representation scheme.
     
     - find_cells.m: function which detects each of the cells of the square segmented by the find_sudoku function.
     
     - get_numbers.m: main function of identification of numbers, which, in addition to returning the 
        identified number, detects whether it is rotated or not, and does so.
       
        - empty_squares_detection.m: subfunction which filters each cell obtained from the find_cells function, 
          and identifies if there is a number or not, to send it to the get_number function.
        
        - Num_identification.m: subfunction which identifies which number is in each case.

     - sudoku_solver.m: function implemented by Cleve Moler in MathWorks, which solves the sudoku puzzle 
         from a matrix with the unsolved sudoku numbers.

     - SudokuSolver.mlapp: graphic user interface in order to make our code easier to use and understand its results.