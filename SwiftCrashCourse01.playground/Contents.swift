//: Playground - noun: a place where people can play

import UIKit

for counter in 1...100 {
    if counter % 3 == 0, counter % 5 == 0 {
        print ("Fizz Buzz")
    } else if counter % 3 == 0 {
        print ("Fizz")
    } else if counter % 5 == 0 {
        print ("Buzz")
    } else {
        print ("\(counter)")
    }
}