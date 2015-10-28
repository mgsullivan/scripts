# a classic
print('Hello world!')
print('What is your name?')
myName = input()
lastIndex = len(myName)
spaceIndex = myName.find(' ')
if spaceIndex > -1:
    lastIndex = spaceIndex
firstName = myName[0:lastIndex]
print('It is good to meet you, ' + firstName)
