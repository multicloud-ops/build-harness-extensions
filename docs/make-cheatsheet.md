# Cheat sheet for Makefiles

### Variables

Brackets `$()` and curly brackets `${}` formats can be used interchangably, but the most commonly used format is brackets `$()`

### ?= and := 
In both cases value is only set if `VARIABLE` is not already defined


`VARIABLE :=` is evaluated only once such that

```
FOO = bar
BAR := $(FOO)
FOO = foobar

## $(BAR) will evaluate to "bar"
```

`VARIABLE ?=` will evaluate at use, such that

```
FOO = bar
BAR := $(FOO)
FOO = foobar

## $(BAR) will evaluate to "foobar"
```
