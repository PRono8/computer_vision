function X = sudoku_solver(X) 
    % SUDOKU  Solve Sudoku using recursive backtracking. 
    %   sudoku(X), expects a 9-by-9 array X. 
     % Fill in all “singletons”. 
     % C is a cell array of candidate vectors for each cell. 
     % s is the first cell, if any, with one candidate. 
     % e is the first cell, if any, with no candidates. 
     [C,s,e] = candidates(X); 
     while ~isempty(s) && isempty(e) 
        X(s) = C{s}; 
        [C,s,e] = candidates(X); 
     end 
     % Return for impossible puzzles. 
     if ~isempty(e) 
        return 
     end 
     % Recursive backtracking. 
     if any(X(:) == 0) 
        Y = X; 
        z = find(X(:) == 0,1);    % The first unfilled cell. 
        for r = [C{z}]            % Iterate over candidates. 
           X = Y; 
           X(z) = r;              % Insert a tentative value. 
           X = sudoku_solver(X);         % Recursive call. 
           if all(X(:) > 0)       % Found a solution. 
              return 
           end 
        end 
      end 
    % ------------------------------ 
      function [C,s,e] = candidates(X) 
         C = cell(9,9); 
         tri = @(k) 3*ceil(k/3-1) + (1:3); 
         for j = 1:9 
             for i = 1:9 
                if X(i,j)==0 
                   z = 1:9; 
                   z(nonzeros(X(i,:))) = 0; 
                   z(nonzeros(X(:,j))) = 0; 
                   z(nonzeros(X(tri(i),tri(j)))) = 0; 
                   C{i,j} = nonzeros(z)'; 
                end 
             end 
         end 
         L = cellfun(@length,C);   % Number of candidates. 
         s = find(X==0 & L==1,1); 
         e = find(X==0 & L==0,1); 
       end % candidates 
end % sudoku