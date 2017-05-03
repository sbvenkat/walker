"""
    :author Sridhar BV
    :description. This file list all the dependencies required
"""
import os
from setuptools import setup, find_packages


setup(
    name = "f-gevent",
    version = "0.0.2",
    author = "Sridhar BV",
    author_email = "sridbv@gmail.com",
    description = ("Master gevent"),
    license = "BSD",
    install_requires = [
    "gevent==1.2.1"
    ],
    packages    = find_packages('modules'),
    package_dir = { '' : 'modules' },
)
