package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestSomething(t *testing.T) {
	v, err := fna(1)
	assert.NoError(t, err)
	assert.Equal(t, 2, v)
}
