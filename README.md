# YORA

*Glory to Devola and Popola.*

---

## What is YORA?

YORA scans files for suspicious patterns using custom `.yora` rules. Define what you're looking for, point it at a file, get a report. Simple.

> *Disclaimer: This is a personal project, not a YARA replacement.*

---

## Project Structure

```
YORA/
├── bin/
│   └── yora.rb         # entry point
├── lib/
│   ├── parser.rb       # .yora rule parser
│   ├── scanner.rb      # pattern scanner
│   └── reporter.rb     # report generator
├── src/
│   └── scanner.c       # C scanner source
├── native/             # compiled C library
├── rules/
│   └── default.yora    # default rule set
├── cache/              # parsed rule cache (auto-generated)
├── test/               # test files
├── reports/            # scan reports (auto-generated)
└── README.md
```

> Note: I've included a test sample, sample report, and default.json so you can try the project. Feel free to clear them.

---

## Requirements

- Ruby 3.x
- FFI gem: `gem install ffi`

---

## Usage

### 1. Compile the C scanner

```bash
mkdir native
gcc -shared -fPIC -o native/scanner.so src/scanner.c
```

### 2. Run YORA

```bash
ruby bin/yora.rb <rule_file> <target_file>
```

Example:

```bash
ruby bin/yora.rb rules/default.yora test/sample.txt
```

Report is automatically saved to `reports/`.

---

## .yora Rule Format

```
rule rule_name
{
    meta:
        description = "what this rule detects"
        author = "your name"
        severity = "critical"

    patterns:
        $a = "suspicious string"
        $b = "another pattern"
        $c = "one more"

    condition:
        any of them
}
```

### Supported Conditions

| Condition | Meaning |
|-----------|---------|
| `any of them` | at least one pattern must match |
| `all of them` | every pattern must match |
| `2 of them` | at least N patterns must match |

---

## Example Output

```
YORA SCAN REPORT
================
Description : Detects common reverse shell patterns
Author      : Admin
Severity    : critical
Target      : test/sample.txt
Scanned at  : 2026-03-13 23:47:38

Patterns:
  [+] $a = "bash -i >& /dev/tcp/"  MATCH
  [-] $b = "nc -e /bin/sh"         NO MATCH
  [-] $c = "socket.socket"         NO MATCH

Condition : ANY
Result    : MATCH DETECTED
```

---

## Feature Upgrades
1. Add CLI colors

---

## License

MIT
