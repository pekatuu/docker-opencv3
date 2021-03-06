FROM nvidia/cuda:7.5-devel

#3.4.3
ENV PYTHON_VERSION 2.7
ENV NUM_CORES 4

# Install OpenCV 3.0
RUN apt-get -y update
RUN apt-get -y install python$PYTHON_VERSION-dev wget unzip \
                       build-essential cmake git pkg-config libatlas-base-dev gfortran \
                       libjasper-dev libgtk2.0-dev libavcodec-dev libavformat-dev \
                       libswscale-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libv4l-dev
RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py
RUN pip install numpy matplotlib

RUN wget https://github.com/Itseez/opencv/archive/3.1.0.zip -O opencv3.zip && \
    unzip -q opencv3.zip && mv /opencv-3.1.0 /opencv
RUN wget https://github.com/Itseez/opencv_contrib/archive/3.1.0.zip -O opencv_contrib3.zip && \
    unzip -q opencv_contrib3.zip && mv /opencv_contrib-3.1.0 /opencv_contrib
RUN mkdir /opencv/build
WORKDIR /opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D BUILD_PYTHON_SUPPORT=ON \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
	-D BUILD_opencv_adas=OFF \
	-D BUILD_opencv_bgsegm=OFF \
	-D BUILD_opencv_bioinspired=OFF \
	-D BUILD_opencv_ccalib=OFF \
	-D BUILD_opencv_cvv=OFF \
	-D BUILD_opencv_datasets=ON \
	-D BUILD_opencv_datasettools=OFF \
	-D BUILD_opencv_face=ON \
	-D BUILD_opencv_latentsvm=OFF \
	-D BUILD_opencv_line_descriptor=OFF \
	-D BUILD_opencv_matlab=OFF \
	-D BUILD_opencv_optflow=OFF \
	-D BUILD_opencv_reg=OFF \
	-D BUILD_opencv_rgbd=ON \
	-D BUILD_opencv_saliency=OFF \
	-D BUILD_opencv_surface_matching=OFF \
	-D BUILD_opencv_text=ON \
	-D BUILD_opencv_tracking=ON \
	-D BUILD_opencv_xfeatures2d=OFF \
	-D BUILD_opencv_ximgproc=OFF \
	-D BUILD_opencv_xobjdetect=OFF \
	-D BUILD_opencv_xphoto=OFF \
	-D BUILD_opencv_stereo=OFF \
	-D BUILD_opencv_hdf=OFF \
	-D BUILD_opencv_fuzzy=OFF \
	-D BUILD_NEW_PYTHON_SUPPORT=ON \
	-D WITH_IPP=OFF \
	-D WITH_V4L=ON \
	-D WITH_CUDA=ON \
	..
RUN make -j$NUM_CORES
RUN make install
RUN ldconfig
# Define default command.
CMD ["bash"]
