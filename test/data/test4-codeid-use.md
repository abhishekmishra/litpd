---
title: Test2 - Program with sections marked with code ids
author: Abhishek Mishra
date: 21/03/2024
---

# Test2: Program with sections marked with code ids
There are two sections to this file

One with the function to say something...

```lua {code_id="fnsay"}
function say(text)
    print('>' .. text)
end
```

```lua {code_id="fndo"}
function do(text)
    print('>' .. text)
end
```

Another to say hello using the function defined above...

```lua {code_id="sayhello"}
say("hello")
```

Use this to to create a program...

```lua {code_file="hello3.lua"}
@<fnsay@>

@<fndo@>

@<sayhello@>
```