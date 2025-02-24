Obtaining the image:

```
docker pull thecoulter/boost-1.41_gcc-4.4.7:latest
docker run --rm -it thecoulter/boost-1.41_gcc-4.4.7:latest bash
```
Image Paths:

```
boost : /opt/boost_1.41.0/include/boost/  
C_INCLUDE_PATH is set to have that location
```

The gcc version is 4.4.7 



Submitting on Thoreau: 

module load docker/24.0.7 

Do this at runtime or in a bashrc, according to preference.

