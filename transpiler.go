package main

import "C"
import (
	"github.com/evanw/esbuild/pkg/api"
)

//export TranspileTS
func TranspileTS(tsCode *C.char) *C.char {
	result := api.Transform(C.GoString(tsCode), api.TransformOptions{
		Loader: api.LoaderTS,
	})
	return C.CString(string(result.Code))
}

func main() {}

// This is a dummy main function to make the Go compiler happy.
