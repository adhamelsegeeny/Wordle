build_kb:-
    write('Please enter a word and its category on separate lines:'),nl,
    read(W),
    ((W=done);
    read(C),assert(word(W,C)),
    build_kb).
    
    
is_category(C):-
    word(_,C).
    

categories(List):-
    setof(C,is_category(C),List).
    
    
available_length(L):-
    word(X,_),
    string_length(X,L).
    
pick_word(W,L,C):-
    word(W,C),
    string_length(W,L).
    
    

correct_letters([],_,[]).
correct_letters([H1|T1],L2,[H1|T2]):-
    member(H1,L2),
	delete(L2,H1,L3),
    correct_letters(T1,L3,T2).
    
correct_letters([H1|T1],L2,R):-
    \+member(H1,L2),
    correct_letters(T1,L2,R).
    
    
correct_positions([],[],[]).  
correct_positions([H1|T1],[H1|T2],L3):-
    correct_positions(T1,T2,T3),
	append([H1],T3,L3).
    
    
correct_positions([H1|T1],[H2|T2],L):-
    H1\=H2,
    correct_positions(T1,T2,L).
   
choose_category(Y):-
    write('Choose a category:'),nl,
    read(X),
    ((is_category(X),Y=X);
    \+is_category(X),write('This category does not exist.'),nl,
    choose_category(Y)).
    
    
correct_length(L,C):-
    word(X,C),
    string_length(X,L).
    
    
choose_length(Length,Category):-
    write('Choose a length.'),nl,
    read(X),
    ((correct_length(X,Category),Length=X);
    \+correct_length(X,Category),nl,
	write('There are no words of this length.'),nl,
    choose_length(Length,Category)).
    


pick_one(X,L,C):- 
    setof(W,pick_word(W,L,C),List),
    randomize(List,X).

randomize([],[]).
randomize(List,Word):-
    length(List,L),
    random(0,L,Index),
    nth0(Index,List,Word).
   

win_lose(X,W,Guesses):-
    Guesses>0,
    X=W,
    write('You win!').
    
win_lose(X,W,Guesses):-
    X\=W,
    Guesses=1,
    write('You lose!').


    
    
case(W,Length,Guesses):-
    write('Enter a word composed of '),write(Length),
    write(' letters: '),nl,
    read(X),
    ((\+string_length(X,Length),
    write('Word is not composed of 5 letters. Try again.'),nl,
    write('Remaining guesses are '),write(Guesses),nl,
    case(W,Length,Guesses));
	(\+word(X,_),write('Word is not valid. Try again.'),nl,
    write('Remaining guesses are '),write(Guesses),nl,
    case(W,Length,Guesses));
    (win_lose(X,W,Guesses));
    atom_chars(X,List1),
    atom_chars(W,List2),
    correct_letters(List1,List2,Result1),
    correct_positions(List1,List2,Result2),
	Remain is Guesses-1,
    write('Correct letters are '),write(Result1),nl,
    write('Correct  letters in correct positions are:'),write(Result2),
	nl,
    write('Remaining guesses are '),write(Remain),nl,
    case(W,Length,Remain)).
  

game:-
    categories(L),
    write('The available categories are: '),write(L),nl,
    choose_category(Category),
    choose_length(Length,Category),
    pick_one(W,Length,Category),
    Guesses is Length+1,
    write('Game started. You have '),write(Guesses),write(' guesses'),
    nl,
    case(W,Length,Guesses).
    
main:-
    write('Welcome to Pro-Wordle!'),nl,
    build_kb,
    game.