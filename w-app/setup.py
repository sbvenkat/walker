"""
    :author Sridhar BV
    :description. This file list all the dependencies required
"""
import os
from setuptools import setup, find_packages


setup(
    name = "",
    version = "",
    author = "Sridhar BV",
    author_email = "sridbv@gmail.com",
    description = ("Master "),
    license = "BSD",
    install_requires = [
    ""
    ],
    packages    = find_packages('src'),
    package_dir = { '' : 'src' },
)
