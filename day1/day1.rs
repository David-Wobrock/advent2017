use std::env;
use std::process;

fn main() {
    let args: Vec<_> = env::args().collect();
    if args.len() < 2 {
        println!("Need an input");
        process::exit(1);
    }
    let input: Vec<char> = args[1].chars().collect();
    let mut sum: u32 = 0;
    
    for i in 0..input.len()-1 {
        if input[i] == input[i+1] {
            let c: Option<u32> = input[i].to_digit(10);
            if c.is_none() {
                println!("Not all entries are digits");
                process::exit(1);
            }
            sum += c.unwrap();
        }
    }
    // Cycle (last -> first)
    if input[0] == *input.last().unwrap() {
        sum += input[0].to_digit(10).unwrap();
    }
    println!("Result {}", sum);
}
