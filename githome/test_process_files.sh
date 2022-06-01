# write file list into file

tmp_file="filelist.txt"

find -maxdepth 1 -name 'gl*.sh' > "${tmp_file}"

while read -r line; do
    p=" ${line}"
    echo "Processing ${p}"; 
    # functions from other scripts need to be exported
    # eval "open \"${p}\""
done < filelist.txt

# delete file
rm "${tmp_file}"


