import subprocess

def copyPlist():
    subprocess.call(['cp', './hackathon-for-hunger/ApiKeysDist.plist', './hackathon-for-hunger/ApiKeys4.plist'])

copyPlist()
