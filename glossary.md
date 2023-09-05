
# Hoon Glossary

## Terms

- Head: left side of a pair eg the node of a binary tree
- Tail: right side of a pair eg the node of a binary tree
- Core: allows saving code+data to a binary tree data structure; `[battery payload]`
- Battery: the code-as-data part in the head of a core
- Payload: the data part in the tail of a core
- Arm: like a method, code available in the subject, a core battery contains a series of arms
- Subject: data part of a nock evaluation is in the head
- Formula: code part of a nock evaluation is in the tail
- Face: variable name; in `x = 1` x is the face
- Pin: like assignment; in `x = 1` the value 1 is pinned to the face x
- Child: argument, in `=> ~ 1` the tisgar rune has two children: sig and one
- Wing: the address of something in the subject, can either be an arm (code) or a leg (data)
- Leg: a chunk of data available in the subject
- Door: a core that has a sample pinned to the head of its payload.
- Sample: the head of a core's payload. Frequently pinned before calling core arms
- Context: the tail of a core's payload. Frequently store the old subject
- Bunt: default value; eg the bunt of a string is "" and that of a number is 0
- Gate: a door with a single arm called $
- Trap: the single $ arm of a gate
- Kick: to execute a trap immediately after declaring it

## Runes

- `=/`: `(face value)`; pins the face to the value and sets this as the head of the old subject
- `=+`: `(face=value)`; similar to tisfas but the face/value is provided as one child rather than two
- `=>`: `(subject code)`; sets the 1st child as the subject and then runs the expression in the 2nd child
- `=<`: `(code subject)`; reversed tisgar; runs the code in the 1st child within the subject provided by the 2nd child
- `=|`: `(face=type)`; pint the bunt of type to the face

- `%=`: `(wing [(sub-wing new-value), ...] ==)`; replaces a series of sub-wings with new-values under the given wing
- `%~`: `(arm door sample)`; run the arm of the given door after substituting the given sample
- `%-`: `(gate sample)`; evaluate the $ arm of a gate providing the given sample

- `|%`: `( [(++ face code), ...] --)`; declare a core
- `|_`: `(face=type [(++ term code), ...] --)`; declare a door; pins the face bunt to the head of the payload before creating a door
- `|=`: `(face=type code)`; declare a gate; pins the face bunt to the head of the payload before creating a gate defined by the given code
- `|:`: `(type code)`; resets the default sample; infers the type of the given type and sets it as the sample for the given code
- `|.`: `(code)`; declare a gate; does not mess with the payload, just sets the given code to the core's battery
- `|-`: `(code)`; declare a gate and immediately run it's arm (build a trap and kick it)

- `++`: `(face code)`; declare an arm (code) on the parent core pinned at the given face
- `--`: `()`; terminates a series of eg arm declarations

- `^-`: `(type code); cast the result of running given code to the given type
- `^=`: `(face value)`; pins the given value to the given face

- `$?`: `(type, type, ..., ==)`; create a type from a union of other types

- `?:`: `(if then else)`; run the "then" code if the "if" code returns %.y otherwise run the "else" code
