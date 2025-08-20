from setuptools import find_packages, setup

setup(
    name='signLanguages',
    version='0.0.0',
    author='iNeuron',
    author_email='boktiar@ineuron.ai',
    packages=find_packages(),
    install_requires=[
        'numpy==1.24.3',
        'pandas==2.0.3',
        'scikit-learn==1.3.0',
        'matplotlib==3.7.1',
        'seaborn==0.12.2',
        'jupyter==1.0.0',
        'flask==2.3.2',
        'requests==2.31.0',
        'boto3==1.28.25',
        'opencv-python==4.8.0.74',
        'tensorflow==2.13.0',
        'torch==2.0.1',
        'pillow==9.5.0'
    ]
)
