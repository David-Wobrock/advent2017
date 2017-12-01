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
    
    let step: usize = input.len()/2;
    for i in 0..input.len()-1 {
        if input[i] == input[(i+step)%input.len()] {
            let c: Option<u32> = input[i].to_digit(10);
            if c.is_none() {
                println!("Not all entries are digits");
                process::exit(1);
            }
            sum += c.unwrap();
        }
    }
    // Cycle (last)
    if input[step-1] == *input.last().unwrap() {
        sum += input.last().unwrap().to_digit(10).unwrap();
    }
    println!("Result {}", sum);
}

