# Go TypeScript Transpiler C/C++ Wrapper

A high-performance Go wrapper around [esbuild](https://esbuild.github.io/) for transpiling TypeScript to JavaScript, compiled as a C-compatible shared library for integration with C/C++ projects. Ideal for embedding in applications using QuickJS or other JavaScript runtimes.

## Features

- 🚀 **Blazing Fast**: Leverages esbuild's optimized Go implementation
- 🔗 **C/C++ Compatible**: Exports simple C-API via shared library (`*.so`/`*.dll`)
- 📦 **Zero Runtime Dependencies**: Single binary after compilation
- ⚡ **Low Latency**: Transpiles most files in <1ms

## Prerequisites

- Go 1.20+
- C++17 compatible compiler
- [esbuild](https://esbuild.github.io/) Go package

## Installation

1. Install Go dependencies:
```bash
go get github.com/evanw/esbuild/pkg/api
```

2. Clone this repository:
```bash
git clone https://github.com/jibbex/Go-TypeScript-Transpiler-C-CPP-Wrapper.git
cd Go-TypeScript-Transpiler-C-CPP-Wrapper
```

## Usage

### Go Interface
```go
package main

// #include <stdlib.h>
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

func main() {} // Required empty main
```

### Build Shared Library
```bash
make build
```

This generates:
- `libts_transpiler.so` (Linux) / `libts_transpiler.dylib` (macOS)
- `libts_transpiler.h` (C header)

## C++ Integration

```cpp
#include <iostream>
#include "libts_transpiler.h" // Auto-generated header

int main() {
    const char* ts_code = R"(
        interface User { name: string }
        const greet = (user: User) => `Hello ${user.name}!`;
    )";
    
    char* js_output = TranspileTS(ts_code);
    std::cout << "Transpiled JS:\n" << js_output << "\n";
    
    // Free allocated memory
    free(js_output);
    return 0;
}
```

## Performance

Benchmark (i9-13900K):
| File Size | esbuild (Go) | tsc (TypeScript) |
|----------|--------------|-------------------|
| 10 KB    | 0.4ms        | 12ms              |
| 100 KB   | 1.2ms        | 145ms             |

## Limitations

- No type checking (pure transpilation)
- Limited to esbuild's TypeScript subset
- Manual memory management required

## Alternatives

1. **SWC (Rust)**: More complete TS support via [swc.rs](https://swc.rs/)
2. **Corsa**: Future Microsoft Go port (not yet released)
3. **QuickJS+TS**: Bundle TypeScript compiler (slower)

## License

MIT License © 2025 Manfred Michaelis