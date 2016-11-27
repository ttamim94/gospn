#!/bin/bash

tprocs=4
nrun=0

for i in `seq 0 $(( tprocs - 1 ))`; do
  pid[i]=-1
done

i=1
while true; do
  if [ "$i" -gt 9 ]; then
    break
  fi

  if [ "$nrun" -lt "$tprocs" ]; then
    echo "Running ${i}-th process."
    (/usr/bin/time -v go run main.go -mode=class -width=20 -height=30 -max=2 -dataset=digits -pval=0.01 -iterations=10 -p=0.$i) > p0_$i.put 2>&1 &
    for j in `seq 0 3`; do
      if [ "${pid[j]}" -eq -1 ]; then
        pid[j]=$!
        echo "Storing ${i}-th process to slot $j."
        break
      fi
    done
    let nrun=nrun+1
    let i=i+1
  else
    # Wait for any process to finish.
    found=false
    while ! $found; do
      for j in `seq 0 3`; do
        p=${pid[j]}
        if [ "$p" -ne -1 ]; then
          kill -0 "$p"
          alive=$?
          if [ "$alive" -ne 0 ]; then
            pid[j]=-1
            found=true
            let nrun=nrun-1
            echo "Found ${j}-th slot to be dead."
            break
          fi
        fi
      done
      if ! [ $found ]; then
        echo "None found. Sleeping for 0.5 seconds..."
        sleep 0.5
      fi
    done
  fi
done

wait
