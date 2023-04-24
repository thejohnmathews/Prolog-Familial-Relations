%john mathews
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE3520/CpSc3520 SDE1: Prolog Declarative and Logic Programming

% Use the following Prolog relations as a database of familial 
% relationships for 4 generations of people.  If you find obvious
% minor errors (typos) you may correct them.  You may add additional
% data if you like but you do not have to.

% Then write Prolog rules to encode the relations listed at the bottomG.
% You may create additional predicates as needed to accomplish this,
% including relations for debugging or extra relations as you desire.
% All should be included when you turn this in.  Your rules must be able
% to work on any data and across as many generations as the data specifies.
% They may not be specific to this data.

% Using SWI-Prolog, run your code, demonstrating that it works in all modes.
% Log this session and turn it in with your code in this (modified) file.
% You examples should demonstrate working across 4 generations where
% applicable.

% Fact recording Predicates:

% list of two parents, father first, then list of all children
% parent_list(?Parent_list, ?Child_list).

% Data:

parent_list([fred_smith, mary_jones],
            [tom_smith, lisa_smith, jane_smith, john_smith]).

parent_list([tom_smith, evelyn_harris],
            [mark_smith, freddy_smith, joe_smith, francis_smith]).

parent_list([mark_smith, pam_wilson],
            [martha_smith, frederick_smith]).

parent_list([freddy_smith, connie_warrick],
            [jill_smith, marcus_smith, tim_smith]).

parent_list([john_smith, layla_morris],
            [julie_smith, leslie_smith, heather_smith, zach_smith]).

parent_list([edward_thompson, susan_holt],
            [leonard_thompson, mary_thompson]).

parent_list([leonard_thompson, lisa_smith],
            [joe_thompson, catherine_thompson, john_thompson, carrie_thompson]).

parent_list([joe_thompson, lisa_houser],
            [lilly_thompson, richard_thompson, marcus_thompson]).

parent_list([john_thompson, mary_snyder],
            []).

parent_list([jeremiah_leech, sally_swithers],
            [arthur_leech]).

parent_list([arthur_leech, jane_smith],
            [timothy_leech, jack_leech, heather_leech]).

parent_list([robert_harris, julia_swift],
            [evelyn_harris, albert_harris]).

parent_list([albert_harris, margaret_little],
            [june_harris, jackie_harris, leonard_harris]).

parent_list([leonard_harris, constance_may],
            [jennifer_harris, karen_harris, kenneth_harris]).

parent_list([beau_morris, jennifer_willis],
            [layla_morris]).

parent_list([willard_louis, missy_deas],
            [jonathan_louis]).

parent_list([jonathan_louis, marsha_lang],
            [tom_louis]).

parent_list([tom_louis, catherine_thompson],
            [mary_louis, jane_louis, katie_louis]).

%male/female rules
male(fred_smith).
male(tom_smith).
male(john_smith).
male(mark_smith).
male(freddy_smith).
male(joe_smith).
male(francis_smith).
male(frederick_smith).
male(marcus_smith).
male(tim_smith).
male(zach_smith).
male(edward_thompson).
male(leonard_thompson).
male(joe_thompson).
male(john_thompson).
male(richard_thompson).
male(marcus_thompson).
male(jeremiah_leech).
male(arthur_leech).
male(timothy_leech).
male(jack_leech).
male(robert_harris).
male(albert_harris).
male(leonard_harris).
male(kenneth_harris).
male(beau_morris).
male(willard_louis).
male(jonathan_louis).
male(tom_louis).

female(mary_jones).
female(lisa_smith).
female(jane_smith).
female(evelyn_harris).
female(pam_wilson).
female(martha_smith).
female(connie_warrick).
female(jill_smith).
female(layla_morris).
female(julie_smith).
female(leslie_smith).
female(heather_smith).
female(susan_holt).
female(mary_thompson).
female(lisa_smith).
female(catherine_thompson).
female(carrie_thompson).
female(lisa_houser).
female(lilly_thompson).
female(mary_snyder).
female(sally_swithers).
female(heather_leech).
female(julia_swift).
female(margaret_little).
female(june_harris).
female(jackie_harris).
female(constance_may).
female(jennifer_harris).
female(karen_harris).
female(jennifer_willis).
female(layla_morris).
female(missy_deas).
female(marsha_lang).
female(mary_louis).
female(jane_louis).
female(katie_louis).


% Rules:

% parent_of: helper rule to assoiate data in parent_list to data inside
parent_of(Father, Mother, Child) :-
    parent_list([Father, Mother], Children),
    member(Child, Children).

% parent(?Parent, ?Child): rule to see if Parent entered is the parent of a child
parent(Parent, Child) :-
    parent_of(Parent, _, Child); 
    parent_of(_, Parent, Child).

% married(?Husband, ?Wife): rule to see if husband is married to wife
married(Husband, Wife) :-
    parent_list([Husband, Wife], _). 

% ancestor(?Ancestor, ?Person): rule to see if Ancestor is parent, grandparent, great-grandparent, etc. of Person
ancestor(Ancestor, Person) :-
    parent(Ancestor, Person); 
    parent(Temp, Person), 
    ancestor(Ancestor, Temp).

% descendant(?Descendant, ?Person): backwards ancestor
descendant(Descendant, Person) :-
    parent(Person, Descendant); 
    parent(Person, Temp), 
    descendant(Descendant, Temp).

% generations(?Ancestor, ?Person, ?Gen): There are exactly Gen generations between Ancestor and Person.
generations(Ancestor, Person, Gen) :-
    parent(Ancestor, Person), Gen is 1;
    parent_list(Parents, Children), 
    member(Ancestor, Parents),
    member(Child, Children),
    generations(Child, Person, HigherGen), Gen is HigherGen+1.

% least_common_ancestor(?Person1, ?Person2, ?Ancestor): Ancestor is the ancestor of both Person1 and Person2.
least_common_ancestor(Person1, Person2, Ancestor) :-
    father(Ancestor, Person1), father(Ancestor, Person2), Person1 \== Person2.
least_common_ancestor(Person1, Person2, Ancestor) :- 
    father(Ancestor, Person1), father(Ancestor, Temp), Person1 \== Temp,
    ancestor(Temp, Person2).
least_common_ancestor(Person1, Person2, Ancestor) :-
    father(Ancestor, Temp), ancestor(Temp, Person1), father(Ancestor, Person2), Temp \== Person2.
least_common_ancestor(Person1, Person2, Ancestor) :-
    father(Ancestor, Temp), ancestor(Temp, Person1), father(Ancestor, Temp2), Temp \== Temp2,
    ancestor(Temp2, Person2).

% blood(?Person1, ?Person2): Do Person1 and Person2 have a common ancestor?
blood(Person1, Person2) :-
    ancestor(Temp, Person1),
    ancestor(Temp, Person2),
    Temp \= Person1,
    Temp \= Person2.

% sibling(?Person1, Person2): Are Person1 and Person2 on the same list 2nd are of a parent_list record.
sibling(Person1, Person2) :-
    parent_list(_, Children),
    member(Person1, Children),
    member(Person2, Children),
    Person1 \= Person2.

% father(?Father, ?Child): dad of person
father(Father, Child) :-
    parent(Father, Child), 
    male(Father).

% mother(?Mother, ?Child): mom of person
mother(Mother, Child) :-
    parent(Mother, Child),
    female(Mother).

% uncle(?Uncle, ?Person): uncle of person
uncle(Uncle, Person) :-
    parent(Temp, Person), sibling(Temp, Uncle), male(Uncle);
    parent(Temp, Person), sibling(Temp, Temp2), married(Uncle, Temp2), male(Uncle).

% aunt(?Aunt, ?Person): aunt of person
aunt(Aunt, Person) :-
    parent(Temp, Person), sibling(Temp, Aunt), female(Aunt);
    parent(Temp, Person), sibling(Temp, Temp2), married(Temp2, Aunt), female(Aunt).

% cousin(?Cousin, ?Person): cousins of person
cousin(Cousin, Person)  :-
    least_common_ancestor(Cousin, Person, Ancestor), generations(Ancestor, Cousin, Temp1),
    generations(Ancestor, Person, Temp2), Temp1 > 1, Temp2 > 1.

% cousin_type(+Person1, +Person2, -CousinType, -Removed): gathers cousins and adds the types of cousins
cousin_type(Person1, Person2, CousinType, Removed) :-
    least_common_ancestor(Person1, Person2, Ancestor),
    generations(Ancestor, Person1, Temp),
    generations(Ancestor, Person2, Temp2), Temp > 1, Temp2 > 1,
    CousinType is min(Temp, Temp2) - 1,
    Removed is abs(Temp - Temp2).

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SWE1 Assignment - Create rules for:

% the Parent is the parent - mother or father of the child
% parent(?Parent, ?Child).

% Husband is married to Wife - note the order is significant
% This is found in the first list of the parent_list predicate
% married(?Husband, ?Wife).

% Ancestor is parent, grandparent, great-grandparent, etc. of Person
% Order is significant.  This looks for chains between records in the parent_list data
% ancestor(?Ancestor, ?Person).

% Really the same as ancestor, only backwards.  May be more convenient in some cases.
% descendent(?Decendent, ?Person).

% There are exactly Gen generations between Ancestor and Person.  Person and parent 
% have a Gen of 1.  The length of the chain (or path) from Person to Ancestor.
% Again order is significant.
% generations(?Ancestor, ?Person, ?Gen).

% Ancestor is the ancestor of both Person1 and Person2.  There must not exist another
% common ancestor that is fewer generations. 
% least_common_ancestor(?Person1, ?Person2, ?Ancestor).

% Do Person1 and Person2 have a common ancestor?
% blood(?Person1, ?Person2). %% blood relative

% Are Person1 and Person2 on the same list 2nd are of a parent_list record.
% sibling(?Person1, Person2).

% These are pretty obvious, and really just capturing info we already can get - except that
% the gender is important.  Note that father is always first on the list in parent_list.
% father(?Father, ?Child).

% mother(?Mother, ?Child).

% Note that some uncles may not be in a parent list arg of parent_list, but would have 
% a male record to specify gender.
% uncle(?Uncle, ?Person). %% 

% aunt(?Aunt, ?Person). %% 

% cousins have a generations greater than parents and aunts/uncles.
% cousin(?Cousin, ?Person).

%% 1st cousin, 2nd cousin, 3rd once removed, etc.
% cousin_type(+Person1, +Person2, -CousinType, -Removed).
