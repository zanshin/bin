#!/usr/bin/python
import random
f = open('/usr/share/dict/words')
words = map(lambda x: x.strip(), f.readlines())
password = '-'.join(random.choice(words) for i in range(2)).capitalize()
password += str(random.randint(1, 9999))
print (password)
