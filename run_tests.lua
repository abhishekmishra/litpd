-- make directory out if it does not exist
os.execute('mkdir out')

print('===== Running tests in the test directory =====')

-- run tests in the test directory
os.execute('busted -v --pattern=_spec.lua test')
