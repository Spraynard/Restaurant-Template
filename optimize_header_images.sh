# !/usr/bin/bash

# optimize_header_images.sh
# Looks at all of the images in /public/img/header-images
# and runs them through a gamut of image optimization operations
# to be built for the <picture> tag on menu category pages.

# This script wont work without imagemagick
imagemagick_path=$(command -v magick)
if [ ${#imagemagick_path} -eq 0 ]
then
	echo "You need imagemagick's convert command to use this script"
	exit 1
fi
imagemagick_command=""

script_dir=$(dirname $0)
image_dir="${script_dir}/public/static/img"
user_has_mozjpeg=0

sizes_array=("1200" "992" "768" "480")
aspect_ratio_array=(1 3)

# Check to see if the user has mozjpeg availability
mozjpeg_path=$(command -v mozjpeg)

if [ ${#mozjpeg_path} -gt 0 ]
then
	user_has_mozjpeg=1
fi

keep_original_image=0
crop_base_image=''

for image in header-images/*
do
	file_base=$(basename ${image})
	file_extension="${file_base##*.}"
	file_name="${file_base%.*}"
	file_original_dimensions_string=$(identify -ping -format '%w %h' "${image}")
	file_original_dimensions_array=(${file_original_dimensions_string})
	file_original_width="${file_original_dimensions_array[0]}"
	file_original_height="${file_original_dimensions_array[1]}"

	# Check and see if the current width is the aspect ratio set.
	file_original_aspect_ratio_height=$(expr ${file_original_width} / ${aspect_ratio_array[1]})

	if [ ${file_original_aspect_ratio_height} -ne ${file_original_height} ]
	then
		# If not, make a crop of the image at the correct size and use that image
		# to base all image scale reductions on.
		total_height_takeaway=$(expr ${file_original_height} - ${file_original_aspect_ratio_height})
		height_offset=$(expr ${total_height_takeaway} / 2)
		new_image_name="${file_name}_temp.${file_extension}"
		new_image="${image_dir}/optimized-images/${new_image_name}"
		convert "${image}" -crop "${file_original_width}x${file_original_aspect_ratio_height}+0+${height_offset}" "${new_image}"
		image="${new_image}"

		file_original_dimensions_string=$(identify -ping -format '%w %h' "${image}")
		file_original_dimensions_array=(${file_original_dimensions_string})
		file_original_width="${file_original_dimensions_array[0]}"
		file_original_height="${file_original_dimensions_array[1]}"
	else
		keep_original_image=1
	fi

	# echo "${file_original_aspect_ratio_height}"
	# echo "${file_original_width}"
	xxs_image_height=600
	xxs_image_width=480
	for i in "${sizes_array[@]}"
	do
		opti_image_name="${image_dir}/optimized-images/${file_name}_optimized_${i}.${file_extension}"

		# This will make it so the 480 px image is cropped and fitted for a small screen.
		if [ ${i} = "480" ]
		then
			middle_x_offset=$(expr $(expr ${file_original_width} - ${xxs_image_width} ) / 2 )
			middle_y_offset=$(expr $(expr ${file_original_height} - ${xxs_image_height} ) / 2)
			convert "${crop_base_image}" -crop "${xxs_image_width}x${xxs_image_height}+${middle_x_offset}+${middle_y_offset}" "${opti_image_name}"
			continue
		fi

		opti_image_file_height=$(expr ${i} / ${aspect_ratio_array[1]})
		if [ ${user_has_mozjpeg} -gt 0 ]
		then
			convert "${image}" -resize "${i}x${opti_image_file_height}" PNM:- | mozcjpeg -quality 60 -outfile "${opti_image_name}"
		else
			convert "${image}" -resize "${i}x${opti_image_file_height}" -sampling-factor 4:2:0 -strip -interlace Plane -quality 60 -colorspace sRGB "${opti_image_name}"
		fi

		if [ ${i} = "1200" ]
		then
			crop_base_image="${opti_image_name}"
			file_original_dimensions_string=$(identify -ping -format '%w %h' "${crop_base_image}")
			file_original_dimensions_array=(${file_original_dimensions_string})
			file_original_width="${file_original_dimensions_array[0]}"
			file_original_height="${file_original_dimensions_array[1]}"
		fi
	done

	if [ ${keep_original_image} -eq 0 ]
	then
		if [ ${user_has_mozjpeg} -gt 0 ]
		then
			# echo "Hello there"
			# echo "${image}"
			mozcjpeg -outfile "${image_dir}/optimized-images/${file_name}_optimized.${file_extension}" -quality 60 "${image}"
		else
			mogrify -sampling-factor 4:2:0 -strip -interlace Plane -quality 60 "${image}"
		fi
		rm "${image}" #Remove the temporary image that was made
	else
		if [ ${user_has_mozjpeg} -gt 0 ]
		then
			mozcjpeg -outfile "${image_dir}/optimized-images/${file_name}_optimized.${file_extension}" -quality 60 "${image}"
		else
			convert "${image}" -sampling-factor 4:2:0 -strip -interlace Plane -quality 60 "${image_dir}/optimized-images/${file_name}_optimized.${file_extension}"
		fi
	fi
done