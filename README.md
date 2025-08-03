# i19c — Internationalization C

## Installation

Clone or add `i19c` as a submodule:

```bash
git submodule add https://github.com/RahulNavneeth/i19c lib/i19c
```

---

## Usage

### Step 1: Add to your build

If you're using `make`, add the following:

```make
CFLAGS += -Ilib/i19c/include -Ilib/i19c/.i19c
LDFLAGS += -Llib/i19c/bin -li19c
```

Then build i19c:

```bash
cd lib/i19c && make all path=../../<path-to-your-i18n-folder>
```

Adjust the `path` as needed based on your project layout.

---

### Step 2: Create your language files

In your internationalization folder, add a file like `english.h`:

```c
#ifndef ENGLISH_H
#define ENGLISH_H

#define GREETING "Welcome @! Good to have you here."

#endif
```

* The file name (without `.h`) is the language key used in code.
* Use `@` in strings to denote dynamic variables.

---

### Step 3: Use in your code

```c
#include "i19c.h"

int main() {
    I19C *lang_ctx = get_i19c();
    set_lang_i19c(lang_ctx, "english");

    T(lang_ctx, "GREETING", "Rahul");
}
```

This will print: `Welcome Rahul! Good to have you here.`

---

## Example

Video demo:

https://github.com/user-attachments/assets/52cd4f4d-5357-4154-af52-4ad2825e305c

Example project: [https://github.com/RahulNavneeth/i19c-example](https://github.com/RahulNavneeth/i19c-example)

---
