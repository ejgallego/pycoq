from distutils.core import setup

NAME = "pycoq"

setup(
    name=NAME,
    version="0.0.1",
    author="Jonathan Laurent",
    author_email="Jonathan.laurent@cs.cmu.edu",
    description="A small example package",
    packages=[NAME],
    package_data={NAME: ['pycoq.so']})
