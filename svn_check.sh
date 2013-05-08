
svn_dir=""
function svn_check {
  testsvn=`svn info > /dev/null 2>&1 | wc -l`
  if [ ! -z $testsvn ] ; then
    echo "In svn controlled directory"
  else
    echo "Not in svn controlled directory"
  fi
}

svn_check
