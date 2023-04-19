
Geometry is a branch of mathematics concerned with questions of shape, size, the relative position of figures, and the properties of space.

Points, Vectors, and Matrices are instrumental in making CG images

You need to be aware of these conventions as they are often not mentioned in books (and poorly documented on the web). However, these conventions are essential; before reading or using another developer's code or techniques, you must check their conventions.  

A Vector can be represented as an array of **numbers**. This array of numbers, which can assume any desired length, is also sometimes called a **tuple** in mathematics.

collectively they represent another value or concept that is meaningful in the context of the problem.  
vectors can represent either a position or direction in space.  
The process of transforming the content of a vector is achieved through what is called a **linear transformation**.


A **point** is a **position** in a three-dimensional space. A **vector**, on the other hand, usually means a **direction** (and some corresponding magnitude or size) in three-dimensional space.  
represented by the tuple notation mentioned above.  
a vector could be arbitrary or even infinite  

**homogeneous points**. Sometimes it is necessary to add a fourth element for mathematical convenience. An example of a point with homogeneous coordinates is given below:

  
Homogeneous points are used when it comes to multiplying points with matrices  
most common operations we perform on points in CG consists of simply moving them around in space. This transformation is called **translation** and plays a vital role in rendering.  
linear transformation of the original point  
Translation has no meaning when applied to a vector  
where the vector begins (that is, where it is centered) is unimportant; regardless of position, all "arrows" of the same length, pointing in the same direction, are equivalent.  
linear transformation on vectors: rotation  
translation for points and rotations for vectors  
When the length of a vector is precisely 1, we say that the vector is **normalized**  
trace a line from point to point  
The line created is a vector that indicates where point is located relative to point . It gives the direction of as if you were standing at point . In this case, the vector's length indicates the distance from to . This distance is sometimes required in specific algorithms.  
consciously ask yourself if this vector is/isn't or should/shouldn't be normalized.  
A normal is a technical term used in Computer Graphics (and Geometry) to describe the orientation of a surface of a geometric object at a point on that surface. Technically, the **surface normal** to a surface at point , can be seen as the vector perpendicular to a plane tangent to the surface at . Normals play an essential role in shading, where they are used to compute the brightness of objects  
Normals can be thought of as vectors with one caveat: they do not transform the same way as vectors.  
a vector can be of any dimension  
**vector** is a direction in 3D space (and therefore represented by three numbers)  
**points** as representations of positions (also in 3D space and represented by three numbers)


## Cartesian Coordinate Space

3D math is all about measuring locations, distances, and angles precisely and mathematically in 3D space. The most frequently used framework to perform such calculations using a computer is called the _Cartesian coordinate system_.


![](https://gamemath.com/book/figs/cartesianspace/map_of_cartesia.png)

### Coordinate Space with Origin and x,y-axis 
![](https://gamemath.com/book/figs/cartesianspace/2d_cartesian_space.png)

### Computer Image Coordinate System
![Computer Image Coordinate System](https://gamemath.com/book/figs/cartesianspace/screen_space.png)


![](https://gamemath.com/book/figs/cartesianspace/2d_labeled_points.png)

### 3D Cartesian Coordinate Space
![](https://gamemath.com/book/figs/cartesianspace/3d_cartesian_space.png)


### Locating Points in 3D Space
![](https://gamemath.com/book/figs/cartesianspace/3d_locating_points.png)


### Left Handed Coordinate System
![](https://gamemath.com/book/figs/cartesianspace/left_handed_coordinate_space.png)

![](https://gamemath.com/book/figs/cartesianspace/left_hand_rule_rotation.png)


### Right Handed Coordinate System
![](https://gamemath.com/book/figs/cartesianspace/right_handed_coordinate_space.png)

![](https://gamemath.com/book/figs/cartesianspace/right_hand_rule_rotation.png)




