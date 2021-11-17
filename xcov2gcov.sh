#!/bin/sh

xcov_files=$(find . -type f -name '*.xcov')

#   State_Char : constant State_Char_Array :=
#     (No_Code                 => '.',
#      Not_Coverable           => '0',
#      Not_Covered             => '-',
#      Partially_Covered       => '!',
#      Covered                 => '+',
#      Exempted_With_Violation => '*',
#      Exempted_No_Violation   => '#');

sed_rules=""
sed_rules="${sed_rules} s/\([[:digit:]]\+\) \.:/     -: \1:/g;" # not coverable
sed_rules="${sed_rules} s/\([[:digit:]]\+\) 0:/     -: \1:/g;"  # not coverable
sed_rules="${sed_rules} s/\([[:digit:]]\+\) -:/ #####: \1:/g;"  # not covered
sed_rules="${sed_rules} s/\([[:digit:]]\+\) \!:/ #####: \1:/g;" # not covered
sed_rules="${sed_rules} s/\([[:digit:]]\+\) +:/     1: \1:/g;"  # covered
sed_rules="${sed_rules} s/\([[:digit:]]\+\) \*:/     -: \1:/g;" # not coverable
sed_rules="${sed_rules} s/\([[:digit:]]\+\) #:/     -: \1:/g;"  # not coverable

gnatcov_header_lines=6

for file in ${xcov_files}; do
    echo "Input file:" $file
    src_basename="$(basename -- ${file%.xcov})"
    src_file=$(cat ${file} | head -1 | cut -d: -f1)
    gcov_file=${src_file}.gcov

    echo "Output file:" $gcov_file
    echo "        -: 0:Source:${src_basename}" > ${gcov_file}
    echo "        -: 0:Graph:${src_basename}.gcno" >> ${gcov_file}
    echo "        -: 0:Data:${src_basename}.gcda" >> ${gcov_file}
    echo "        -: 0:Runs:1" >> ${gcov_file}
    tail -n +${gnatcov_header_lines} ${file} | sed "${sed_rules}" >> ${gcov_file}
done
