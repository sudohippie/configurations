__author__ = 'Raghav Sidhanti'

import sys

from os import path
from subprocess import call


class Command(object):

    type = None
    args = []

    file_a = None
    file_b = None

    def __init__(self, args):
        self.args = args

    def _validate(self):
        pass

    def _get_command(self):
        return []

    def execute(self):
        # validate the arguments
        try:
            self._validate()
        except Exception as e:
            print ('Enigma user exception - ' + str(e.message))
            return

        # get the command
        cmd = self._get_command()
        if not cmd or len(cmd) == 0:
            raise Exception('Enigma fatal - Missing native command')

        # call
        call(cmd)

        print(str(cmd))

    def _pipe(*args):
        cmd = []

        for arg in args[1:]:

            if type(arg) is list:
                cmd.extend(arg)

            else:
                cmd.append(arg)

            cmd.append('|')
        return list(cmd[: len(cmd) - 1])


class CrytoCommand(Command):

    def _validate(self):

        # check argument size
        args_len = len(self.args)
        if args_len < 1 or args_len > 3:
            raise Exception("Invalid number of arguments.")

        # check for force flag
        has_force_flag = (self.args[0] == '-f')
        if has_force_flag and args_len < 2:
            raise Exception("Missing file paths.")

        # check if in-file exists
        file_a_idx = 0
        if has_force_flag:
            file_a_idx += 1

        file_a = self.args[file_a_idx]
        if not path.isfile(file_a):
            raise Exception('In-file does not exist: ' + file_a)

        # check if out file exists
        file_b_idx = args_len - 1
        file_b = self.args[file_b_idx]
        # if force flag doesnt exist, raise
        if path.isfile(file_b) and not has_force_flag:
            raise Exception('Out-file exists. Use -f option to force overwrite: ' + file_b)

        file_a = str(file_a).strip()
        file_b = str(file_b).strip()

        if file_a == file_b:
            raise Exception('In and Out files can not be the same: ' + file_a)

        self.file_a = file_a
        self.file_b = file_b


class EncryptCommand(CrytoCommand):

    type = 'encrypt'

    def _get_command(self):
        compress = ['tar', 'zcvf', '-', self.file_a]
        encrypt = ['openssl', 'enc', '-e', '-a', '-aes-256-cbc', '-out', self.file_b]
        return self._pipe(compress, encrypt)


class DecryptCommand(CrytoCommand):

    type = 'decrypt'

    def _get_command(self):
        decrypt = ['openssl', 'enc', '-aes-256-cbc', '-d', '-a', '-in', self.file_a]
        decompress = ['tar', 'zxvf', '-']
        return self._pipe(decrypt, decompress)


def __get_command(name):

    command_map = {
        EncryptCommand.type: EncryptCommand,
        DecryptCommand.type: DecryptCommand
    }

    return command_map.get(name, None)


# encrypt [-f] file_a [file_b]
# decrypt [-f] file_a [file_b]
# change-pass [-f] file_a [file_b]

if __name__ == '__main__':
    args = sys.argv

    # preconditions
    if len(args) < 2:
        print('Enigma user exception - No input arguments were specified')
    else:
        name = args[1]

        CMD = __get_command(name)

        if not CMD:
            print('Enigma user exception - Invalid command: ' + name)
        else:
            cmd_args = args[2:]

            obj = CMD(cmd_args)
            obj.execute()
