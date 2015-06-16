__author__ = 'Raghav Sidhanti'

from subprocess import call
import sys


def __build_openssl_cmd(args, ifile, ofile):
    openssl = ['openssl',
               'enc',
               '-aes-256-cbc',
               '-a',
               '-in',
               ifile,
               '-out',
               ofile]

    for arg in args:
        if arg:
            openssl.append(arg)

    print(openssl)

    return openssl


def encrypt(ifile, ofile):

    cmd = __build_openssl_cmd(['-e'], ifile, ofile)

    call(cmd)


def decrypt(ifile, ofile):

    cmd = __build_openssl_cmd(['-d'], ifile, ofile)

    call(cmd)


def get_exec(opt):

    switch = {
        '-e': encrypt,
        '-d': decrypt
    }

    return switch.get(opt)


if __name__ == '__main__':
    args = sys.argv

    opt = args[1]
    ifile = args[2]
    ofile = args[3]

    get_exec(opt)(ifile, ofile)