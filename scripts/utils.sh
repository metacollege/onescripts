#!/bin/bash

## blue to echo 
function blue(){
    echo -e "\033[34m[ $1 ]\033[0m"
}

## green to echo 
function green(){
    echo -e "\033[32m[ $1 ]\033[0m"
}

## red to echo
function red(){
    echo -e "\033[31m[ $1 ]\033[0m"
}

## Error to warning with blink
function bred(){
    echo -e "\033[31m\033[01m\033[05m[ $1 ]\033[0m"
}

## Error to warning with blink
function byellow(){
    echo -e "\033[33m\033[01m\033[05m[ $1 ]\033[0m"
}


## Error
function ered(){
    echo -e "\033[31m\033[01m[ $1 ]\033[0m"
}

## warning
function eyellow(){
    echo -e "\033[33m\033[01m[ $1 ]\033[0m"
}