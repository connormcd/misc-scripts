cat ocw_file_list | while read f1 f2
do
echo $f1 $f2
curl -o $f1 "$f2" \
  -H $'Cookie: ....' 
done
