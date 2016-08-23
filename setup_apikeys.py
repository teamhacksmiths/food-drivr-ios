from subprocess import call
import os

directory = './hackathon-for-hunger'
filename = 'ApiKeysDist.plist'
new_filename = 'ApiKeys.plist'

def clearOldFile(dir):
    old_files = os.listdir(dir)
    for file_name in old_files:
        full_file_name = os.path.join(dir, file_name)
        if (os.path.isfile(full_file_name)):
            if "ApiKeys.plist" in file_name:
                os.remove(full_file_name)


def copyPlist():
    clearOldFile(directory)
    file_one = os.path.join(directory, filename)
    file_two = os.path.join(directory, new_filename)
    call(['cp', file_one, file_two])
    print("The file ApiKeysDist.plist has been copied to ApiKeys.plist")

copyPlist()
