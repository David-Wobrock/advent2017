let items = Array.make ((Array.length Sys.argv) - 1) 0 ;;

for i = 1 to (Array.length Sys.argv) - 1 do
    items.(i-1) <- (int_of_string (Array.get Sys.argv i))
done;;

let rec get_max arr =
    match arr with 
    |[] -> 0
    |x::xs -> max x (get_max xs)
;;

let rec get_val_idx arr value idx =
    match arr with
    |[] -> -1
    |x::xs -> if x == value then idx else (get_val_idx xs value idx+1)
;;

let rec arrays_are_equal arr1 arr2 =
    match arr1, arr2 with
    | [], [] -> true
    | [], _ -> false
    | _, [] -> false
    | x::xs, y::ys -> ((compare x y) == 0) && (arrays_are_equal xs ys)
;;

let already_seen all_items arr =
    let seen = ref false in
        for i = 0 to (List.length all_items)-1 do
            if arrays_are_equal (List.nth all_items i) arr
            then seen := true;
        done;
        !seen
;;

let step arr =
    let max_val = get_max (Array.to_list arr) in
        let max_idx = get_val_idx (Array.to_list arr) max_val 0 in
            arr.(max_idx) <- 0;
            let i = ref ((max_idx+1) mod (Array.length arr)) in
                for counter=0 to max_val-1 do
                    arr.(!i) <- (arr.(!i) + 1);
                    i := ((!i+1) mod (Array.length arr));
                done
                ;;

let all_items: int list list ref = ref [(Array.to_list items)] in
    let counter = ref 1 in
        step items;
        while not (already_seen !all_items (Array.to_list items)) do
            all_items := List.append !all_items [(Array.to_list items)];
            step items;
            counter := (!counter + 1);
        done;
        print_endline (string_of_int (!counter))
        ;;
