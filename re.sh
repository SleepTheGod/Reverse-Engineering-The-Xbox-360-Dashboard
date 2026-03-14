#!/bin/bash
# name it xex_everything_and_the_kitchen_sink.sh
# run and watch it rape your SSD with 50 almost-identical files kek

f="${1:-dash.xex}"

[[ -f "$f" ]] || { echo "$f not found kys"; exit 69; }

d="${f%.*}_ABSOLUTE_DEGENERACY_$(date +%s)"
mkdir -p "$d" && cd "$d"

echo "UNLEASHING EVERYTHING EVER SAID ABOUT $f … HOLD MY ONIGIRI"

# phase 0 – stare at the file like a creep
file "../$f"
xxd -l 256 "../$f"
hexdump -C "../$f" | head
strings "../$f" | head -50

# phase 1 – signatures like it’s 2008
grep -oba XEX2 "../$f"
grep -oba MZ "../$f"

# phase 2 – carve every offset anyone ever dreamed of
for off in 32768 65536 1048576 0 8192 16384 49152 131072 262144 524288; do
    dd if="../$f" of=slice_${off}.bin bs=1 skip=$off count=16M status=progress 2>/dev/null
done

mz=$(grep -oba MZ "../$f" | head -1 | cut -d: -f1 || echo 420)
[[ $mz != 420 ]] && dd if="../$f" of=slice_mz_$mz.bin bs=1 skip=$mz status=progress 2>/dev/null

stwu=$(grep -oba $'\x94\x21' "../$f" | head -1 | cut -d: -f1 || echo 69)
[[ $stwu != 69 ]] && dd if="../$f" of=slice_stwu_$stwu.bin bs=1 skip=$stwu status=progress 2>/dev/null

# phase 3 – disassemble EVERYTHING with EVERY flag variation
for bin in slice_*.bin; do
    [[ -s $bin ]] || continue
    n=${bin%.bin}

    powerpc-linux-gnu-objdump -D -b binary -m powerpc       $bin > $n.powerpc.asm       2>/dev/null &
    powerpc-linux-gnu-objdump -D -b binary -m powerpc:common64 $bin > $n.common64.asm  2>/dev/null &
    powerpc-linux-gnu-objdump -d -b binary -m powerpc       $bin > $n.powerpc_d.asm     2>/dev/null &
    wait
done

# phase 4 – grep spam apocalypse
for a in *.asm; do
    [[ -s $a ]] || continue
    echo -e "\n─── $a ────────────────────────────────────────"
    grep -m10 "stwu r1" $a || true
    grep -m15 "bl " $a || true
    grep -C3 "sc" $a | head -20 || true
    grep -C2 "tw" $a || true
    grep -m8 "mtlr" $a || true
    grep -m8 "blr" $a || true
done

# phase 5 – string degeneracy
strings "../$f" > ALL_STRINGS.txt
cat ALL_STRINGS.txt | grep -Ei 'xam|live|dash|nui|signin|xboxkrnl|xe|mm|ki|family|privacy|social|guide|avatar|beacon' \
    > STRINGS_I_ACTUALLY_CARE_ABOUT.txt

echo -e "\nDone. Your folder is now 90% garbage and 10% unobtainium. Go forth and mod the dashboard, king."
ls -Sh
