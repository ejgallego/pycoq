import io
from setuptools import setup

NAME = "pycoq"

# requirements.txt and README.md two directories up because dune runs setup.py from `_build/default`
with io.open("requirements.txt", "r") as reqfile:
    dev_requirements = reqfile.readlines()
with io.open("README.md", "r") as readmefile:
    readme = readmefile.read()

setup(
    name=NAME,
    install_requires=[],
    extras_require={"dev": dev_requirements},
    version="0.0.1",
    author="Jonathan Laurent",  # who is this? should I switch it to your name?
    author_email="Jonathan.laurent@cs.cmu.edu",
    description=(
        "PyCoq is a set of bindings and libraries allowing to interact with the Coq "
        "interactive proof assistant from inside Python 3."
    ),
    long_description=readme,
    packages=[NAME],
    package_data={NAME: ["pycoq.so"]},
    project_urls={"GitHub": "https://github.com/ejgallego/pycoq"},
)
