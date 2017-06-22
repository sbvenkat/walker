"""
    :author Sridhar BV
    :description. This file list all the dependencies required
"""
import os
from setuptools import setup, find_packages

setup(
    name = "valsink",
    version = "0.0.1",
    author = "Sridhar BV",
    author_email = "sridbv@gmail.com",
    description = ("Feature valsink"),
    license = "BSD",
    install_requires = [
    "flask==0.12.2"
    ],
    packages    = find_packages('src'),
    package_dir = { '' : 'src' },
)
