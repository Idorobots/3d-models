SIDE_WIDTH = 8;
DEPTH = 0.7;
IMAGE_SCALE = 100;

SPHERE_ROUNDING = true;
SPHERE_DIA = SIDE_WIDTH * 2.6;

SIDES = [
    ["dice/1.svg", 1.0],
    ["dice/2.svg", 1.0],
    ["dice/3.svg", 1.0],
    ["dice/4.svg", 1.0],
    ["dice/5.svg", 1.0],
    ["dice/6.svg", 1.0],
    ["dice/7.svg", 1.0],
    ["dice/8.svg", 1.0],
    ["dice/9.svg", 1.0],
    ["dice/10.svg", 1.0],
    ["dice/11.svg", 1.0],
    ["dice/12.svg", 1.0]
];

COLOR = "white";

$fn = 100;

// Taken from https://github.com/benjamin-edward-morgan/openscad-polyhedra
polyhedraPhi = (1 + sqrt(5))/2;
dodecahedron_vertices=[[-1,-1,-1],[1,-1,-1],[-1,1,-1],[1,1,-1],[-1,-1,1],[1,-1,1],[-1,1,1],[1,1,1],[0,polyhedraPhi,1/polyhedraPhi],[0,-polyhedraPhi,1/polyhedraPhi],[0,polyhedraPhi,-1/polyhedraPhi],[0,-polyhedraPhi,-1/polyhedraPhi],[1/polyhedraPhi,0,polyhedraPhi],[-1/polyhedraPhi,0,polyhedraPhi],[1/polyhedraPhi,0,-polyhedraPhi],[-1/polyhedraPhi,0,-polyhedraPhi],[polyhedraPhi,1/polyhedraPhi,0],[-polyhedraPhi,1/polyhedraPhi,0],[polyhedraPhi,-1/polyhedraPhi,0],[-polyhedraPhi,-1/polyhedraPhi,0]]/(2/polyhedraPhi);
dodecahedron_edges=[[8,10],[8,6],[8,7],[10,2],[10,3],[9,11],[9,4],[9,5],[11,0],[11,1],[12,13],[12,5],[12,7],[13,4],[13,6],[14,15],[14,1],[14,3],[15,0],[15,2],[16,18],[16,7],[16,3],[18,1],[18,5],[17,19],[17,2],[17,6],[19,0],[19,4]];
dodecahedron_adjacent_vertices=[[15,19,11],[18,14,11],[15,17,10],[16,10,14],[9,19,13],[12,9,18],[13,17,8],[12,16,8],[6,10,7],[5,4,11],[2,3,8],[0,9,1],[13,5,7],[12,6,4],[15,1,3],[0,2,14],[3,18,7],[19,2,6],[1,16,5],[0,17,4]];
dodecahedron_faces=[[16,18,5,12,7],[3,16,7,8,10],[2,10,8,6,17],[17,6,13,4,19],[4,13,12,5,9],[13,6,8,7,12],[10,2,15,14,3],[3,14,1,18,16],[18,1,11,9,5],[9,11,0,19,4],[19,0,15,2,17],[11,1,14,15,0]];

function map_verts(verts, face) =
  [ for(i=[0:len(face)-1]) verts[face[i]] ];

function sum_verts(verts, i=0, sum=[0,0,0]) =
  i<len(verts) ? sum_verts(verts, i+1, verts[i] + sum) : sum ;

module orient_face(verts) {
    u = verts[0] - verts[1] ;
    uhat = u/norm(u);
    q = verts[1] - verts[2] ;
    w = cross(q,u);
    what = w/norm(w);
    vhat = cross(what,uhat);

    center = sum_verts(verts)/len(verts) ;

    mat =
      [[uhat[0],vhat[0],what[0],center[0]],
       [uhat[1],vhat[1],what[1],center[1]],
       [uhat[2],vhat[2],what[2],center[2]],
       [0,0,0,1]];

    multmatrix(mat)
       children();
}

module d12(sides) {
    side_size = 0.6;
    scale(SIDE_WIDTH/side_size)
    difference() {
        intersection() {
            polyhedron(
                points = dodecahedron_vertices,
                faces = dodecahedron_faces
            );
            if(SPHERE_ROUNDING) {
                sphere(d = SPHERE_DIA/SIDE_WIDTH);
            }
        }

        for(i=[0:len(sides)-1])
            orient_face(
                map_verts(dodecahedron_vertices, dodecahedron_faces[i])
            )
            rotate(180/len(dodecahedron_faces[i])-90)
            translate([0, 0, -DEPTH/SIDE_WIDTH])
            linear_extrude(DEPTH/SIDE_WIDTH * 2)
            scale(sides[i][1] * side_size/IMAGE_SCALE)
            import(sides[i][0], center = true);
    }
}

color(COLOR)
d12(SIDES);
