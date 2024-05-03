from typing import List, Tuple

def test_structure_difference():
    previous_info : List[Tuple[str, int]] = [('whatever', 1), ('teofil', 2), ('none', 3), ('marian', 4), \
                    ('sebastian', 5), ('daniel', 6), ('brandon', 7), ('vladimir', 8), \
                    ('david', 9), ('raul', 10), ('leonard', 11), ('random', 12), \
                    ('hello', 13), ('marin', 14), ('mickey', 15), ('randy', 16), \
                    ('razor', 17), ('ryzon', 18), ('denis', 19), ('darius', 20), \
                    ('marco', 21), ('gabriel', 22), ('mavarie', 23), ('roberto', 24), \
                    ('martini', 25), ('randy', 26), ('marko', 27), ('marius', 28), \
                    ('jimmy', 29), ('michael', 30), ('ruben', 31), ('eddie', 32), \
                    ('mackey', 33), ('stanley', 34), ('bronnie', 35), ('cristiano', 36), \
                    ('brody', 37), ('idk', 38), ('belulu', 39)]
    current_info: List[Tuple[str, int]] = [('whatever', 1), ('teofil', 2), ('none', 3), ('marian', 4), \
                    ('sebastian', 5), ('daniel', 6), ('brandon', 7), ('vladimir', 8), \
                    ('david', 9), ('raul', 10), ('leonard', 11), ('random', 12), \
                    ('hello', 13), ('marin', 14), ('mickey', 15), ('randy', 16), \
                    ('razor', 17), ('ryzon', 18), ('denis', 19), ('darius', 20), \
                    ('marco', 21), ('gabriel', 22), ('mavarie', 23), ('roberto', 24), \
                    ('martini', 25), ('randy', 26), ('marko', 27), ('marius', 28), \
                    ('jimmy', 29), ('michael', 30), ('ruben', 31), ('eddie', 32), \
                    ('mackey', 33), ('stanley', 34), ('bronnie', 35), ('cristiano', 36), \
                    ('brody', 37), ('idk', 38), ('belulu', 39)]
    
    previous_info : set = set(previous_info)
    current_info : set = set(current_info)
    difference : List[Tuple[str, int]] = list(current_info.difference(previous_info))
    assert len(difference) == 0

    previous_info : List[Tuple[str, int]] = [('whatever', 1), ('teofil', 2), ('none', 3), ('marian', 4), \
                    ('sebastian', 5), ('daniel', 6), ('brandon', 7), ('vladimir', 8), \
                    ('david', 9), ('raul', 10), ('leonard', 11), ('random', 12), \
                    ('hello', 13), ('marin', 14), ('mickey', 15), ('randy', 16), \
                    ('razor', 17), ('ryzon', 18), ('denis', 19), ('darius', 20), \
                    ('marco', 21), ('gabriel', 22), ('mavarie', 23), ('roberto', 24), \
                    ('martini', 25), ('randy', 26), ('marko', 27), ('marius', 28), \
                    ('jimmy', 29), ('michael', 30), ('ruben', 31), ('eddie', 32), \
                    ('mackey', 33), ('stanley', 34), ('bronnie', 35), ('cristiano', 36), \
                    ('brody', 37), ('jeremy', 38), ('belulu', 39)]
    current_info: List[Tuple[str, int]] = [('whatever', 1), ('teofil', 2), ('none', 3), ('marian', 4), \
                    ('sebastian', 5), ('daniel', 6), ('brandon', 7), ('vladimir', 8), \
                    ('david', 9), ('raul', 10), ('leonard', 11), ('random', 12), \
                    ('hello', 13), ('marin', 14), ('mickey', 15), ('randy', 16), \
                    ('razor', 17), ('ryzon', 18), ('denis', 19), ('darius', 20), \
                    ('marco', 21), ('gabriel', 22), ('mavarie', 23), ('roberto', 24), \
                    ('martini', 25), ('randy', 26), ('marko', 27), ('marius', 28), \
                    ('jimmy', 29), ('michael', 30), ('ruben', 31), ('eddie', 32), \
                    ('mackey', 33), ('stanley', 34), ('bronnie', 35), ('cristiano', 36), \
                    ('brody', 37), ('idk', 38), ('belulu', 39)]
    
    previous_info : set = set(previous_info)
    current_info : set = set(current_info)
    difference : List[Tuple[str, int]] = list(current_info.difference(previous_info))
    assert len(difference) == 1
    content, id = difference[0]
    assert content == 'idk'
    assert int(id) == 38

    previous_info : List[Tuple[str, int]] = [('whatever', 1), ('teofil', 2), ('none', 3), ('marian', 4), \
                    ('sebastian', 5), ('daniel', 6), ('brandon', 7), ('vladimir', 8), \
                    ('david', 9), ('raul', 10), ('leonard', 11)]
    current_info: List[Tuple[str, int]] = [('whatever', 1), ('none', 2), ('marian', 3), \
                    ('sebastian', 4), ('daniel', 5), ('brandon', 6), ('maguire', 7)]
    
    previous_info : set = set(previous_info)
    current_info : set = set(current_info)
    difference : List[Tuple[str, int]] = list(current_info.difference(previous_info))
    assert len(difference) == 6