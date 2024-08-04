def createInst():
    file = open('./instructions.txt/', 'w')

    instructions = []

    acabou = False

    while not acabou:
        command = input()
        if command == 'Fim':
            acabou = True
        else:
            instructions.append(command)

    for line in instructions:
        file.write(f"32'h{line[0:10]}: instruction = 32'h{line[10:20]}; //{line[20:]}\n")

    file.close()

def noX():
    with open('./instructions.txt/', 'r') as file:
        lines = file.readlines()

    modified = []

    for line in lines:
        modified_line = line[0:14] + 'instruction = ' + line[14:]
        modified.append(modified_line)

    with open('./instructions.txt/', 'w') as file:
        lines = file.writelines(modified)

noX()