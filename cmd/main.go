package main

import (
	"fmt"
	"os"
)

func main() {
	fmt.Println("vim-go")

	v, err := fna(1)
	if err != nil {
		os.Exit(1)
	}

	fmt.Println(v)
}

func fna(i int) (int, error) {
	if i < 0 {
		return 0, fmt.Errorf("negative numbers are not allowed")
	}

	return i + 2, nil
}
