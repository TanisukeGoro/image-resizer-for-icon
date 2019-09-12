#!/bin/sh
 
##################################################
#   画像のサイズを一括変更するスクリプト               #
#                                                #
#   Useage:                                      #
#   このshell scriptと画像を同じディレクトリに配置     #
#   terminalで [ sh resize.sh ファイル名 ]         #
##################################################
# コマンドラインの入力を受け付ける
fpath=$1
fname_ext="${fpath##*/}"
# ファイルの名前を取得
ICON_FILE="${fname_ext%.*}"
# ファイルの拡張子を取得
ICON_FORMAT="${fpath##*.}"
# 出力先のフォルダ名指定
OUTPUT_ICON_DIR="icons"
# 出力する画像の接頭語
OUTPUT_ICON_NAME="icon-"

# リサイズするサイズを指定する
# 縦横比が違う場合は長い方にフィットする
ICON_SIZES=(72 96 128 144 152 192 384 512)
 
 
if [[ -d "./${OUTPUT_ICON_DIR}" ]]; then
        printf "\e[33mFile has been exist.\e[m\n"
    else
        mkdir "./${OUTPUT_ICON_DIR}"
fi
 
for size in ${ICON_SIZES[@]}
do
    # アスペクト比を固定
    sips -Z ${size} "${ICON_FILE}.${ICON_FORMAT}" --out "./${OUTPUT_ICON_DIR}/tmp.${ICON_FORMAT}"
    # 生成した画像のサイズを取得 かなり冗長かも...
    TRANSED_IMG_W=$(sips -g pixelWidth ./${OUTPUT_ICON_DIR}/tmp.${ICON_FORMAT} | grep pixelWidth | sed -e "s/pixelWidth: //" | xargs)
    TRANSED_IMG_H=$(sips -g pixelHeight ./${OUTPUT_ICON_DIR}/tmp.${ICON_FORMAT} | grep pixelHeight | sed -e "s/pixelHeight: //" | xargs)
    # ファイル名を変更して終わり
    mv "./${OUTPUT_ICON_DIR}/tmp.${ICON_FORMAT}" "./${OUTPUT_ICON_DIR}/${OUTPUT_ICON_NAME}${TRANSED_IMG_W}x${TRANSED_IMG_H}.${ICON_FORMAT}"
done
