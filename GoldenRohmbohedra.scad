//Created by Alfredo Sanz on 7/11/2016
//
//These modules are useful for generating golden rohmbohedra, which are
//6-sided polyhedra whose faces all are golden rhombi (rohombus with the 
//golden ration between its diagonals).
//
//Originally, these modules where creted to 3D print theese kind of
//rombohedra and play with them to honeycomb the 3D space in an aperiodic
//way. For more information about this, search for the following keywords:
//>Quasicrystal
//>Aperiodic/non-periodic tiling/tesselation
//>Honeycomb (geometry)
//And/or check theese web-pages:
//>http://www.steelpillow.com/polyhedra/quasicr/quasicr.htm
//>http://fabacademy.org/archives/2013/students/perezdelama.jose/03_computer_controlled_cutting_jpl.html
//This list may be expanded in the future. If you find something interesting
//about this topic, make sure to contact and tell me!

//To-Look more in-depth:
//>http://www.mi.sanu.ac.rs/vismath/hafner2008a/DissectGoldenRhomb.html
//>http://robertinventor.com/cubeetc/rhombic.htm
//>https://www.fields.utoronto.ca/programs/scientific/03-04/coxeterlegacy/senechal.pdf
//>http://archive.bridgesmathart.org/2005/bridges2005-411.pdf
//>http://link.springer.com/article/10.1007/s00022-016-0342-2
//>http://myweb.rz.uni-augsburg.de/~eschenbu/Penrose3D.pdf
//>http://www.georgehart.com/dissect-re/dissect-re.htm
//>https://searchworks.stanford.edu/view/8828719
//>https://en.wikipedia.org/wiki/Coxeter_group
//>http://whistleralley.com/polyhedra/derivations.htm

//EXAMPLES
//
//Uncomment any example to see how these modules are used

l=10;
g=1;

//GOLDEN ROHMOBOHEDRA (PROLATE)
//cross_prolate(edge=l);

//GOLDEN ROHMOBOHEDRA (OBLATE)
//cross_oblate(edge=l);

//GOLDEN ROHMOBOHEDRA SKELETON (PROLATE)
/*difference(){
    cross_prolate(edge=l);
    cross_prolate(edge=l, thick=-g, extension=g);
}*/

//GOLDEN ROHMOBOHEDRA SKELETON (OBLATE)
/*difference(){
    cross_oblate(edge=l);
    cross_oblate(edge=l, thick=-g, extension=g);
}*/

//GOLDEN ROHMOBOHEDRA TUBE (PROLATE)
/*difference(){
    cross_prolate(edge=l);
    cross_prolate(edge=l, thick=-g, sides=[1,0,0], extension=g);
}*/

//GOLDEN ROHMOBOHEDRA FLOORS (OBLATE)
/*difference(){
    cross_oblate(edge=l);
    cross_oblate(edge=l, thick=-g, sides=[0,1,1], extension=g);
}*/


module g_rhombus(lado=1, ancho=0){
    big_angle=2*atan((1+sqrt(5))/2);
    small_angle=180-big_angle;
    polygon(
        points=[[-ancho/tan(small_angle/2)                         ,-ancho                     ],
                [lado+ancho/tan(big_angle/2)                       ,-ancho                     ],
                [lado*(1+cos(small_angle))+ancho/tan(small_angle/2),lado*sin(small_angle)+ancho],
                [lado*cos(small_angle)-ancho/tan(big_angle/2)      ,lado*sin(small_angle)+ancho]]);
}

module cross_prolate(edge=1, thick=0, extension=0, sides=[1,1,1], precision=0.0001){

    s1=sides[0];
    s2=sides[1];
    s3=sides[2];

    big_angle=2*atan((1+sqrt(5))/2);
    small_angle=180-big_angle;
    dihedral_small_angle=acos((cos(small_angle)-pow(cos(small_angle),2))/pow(sin(small_angle),2));
    dihedral_big_angle=180-dihedral_small_angle;
    
    v1=[1               ,0                                        ,0                                          ];
    v2=[cos(small_angle),sin(small_angle)                         ,0                                          ];
    v3=[cos(small_angle),sin(small_angle)*cos(dihedral_small_angle),sin(small_angle)*sin(dihedral_small_angle)];

    if(s1) hull(){
        translate(-extension*v3)
            linear_extrude(precision) g_rhombus(lado=edge, ancho=thick);
        translate((edge+extension)*v3)
            linear_extrude(precision) g_rhombus(lado=edge, ancho=thick);
    }
    if(s2) hull(){
        translate(-extension*v2) rotate(a=dihedral_small_angle,v=v1)
            linear_extrude(precision) g_rhombus(lado=edge, ancho=thick);
        translate((edge+extension)*v2) rotate(a=dihedral_small_angle,v=v1)
            linear_extrude(precision) g_rhombus(lado=edge, ancho=thick);
    }
    if(s3) hull(){
        translate(-extension*v1) rotate(a=-dihedral_small_angle,v=v2)
            linear_extrude(precision) g_rhombus(lado=edge, ancho=thick);
        translate((edge+extension)*v1) rotate(a=-dihedral_small_angle,v=v2)
            linear_extrude(precision) g_rhombus(lado=edge, ancho=thick);
    }
}

module cross_oblate(edge=1, thick=0, extension=0, sides=[1,1,1], precision=0.0001){

    s1=sides[0];
    s2=sides[1];
    s3=sides[2];

    big_angle=2*atan((1+sqrt(5))/2);
    small_angle=180-big_angle;
    dihedral_big_angle=acos((cos(big_angle)-pow(cos(big_angle),2))/pow(sin(big_angle),2));
    dihedral_small_angle=180-dihedral_big_angle;
    
    v1=[1              ,0                                      ,0                                     ];
    v2=[cos(big_angle) ,-sin(big_angle)                        ,0                                     ];
    v3=[-cos(big_angle),+sin(big_angle)*cos(dihedral_big_angle),sin(big_angle)*sin(dihedral_big_angle)];

    if(s1)hull(){
        translate(-extension*v3)
            linear_extrude(precision) g_rhombus(lado=edge, ancho=thick);
        translate((edge+extension)*v3)
            linear_extrude(precision) g_rhombus(lado=edge, ancho=thick);
    }
    if(s2)hull(){
        translate(extension*v2) rotate(a=dihedral_big_angle,v=v1)
            linear_extrude(precision) g_rhombus(lado=edge, ancho=thick);
        translate(-(edge+extension)*v2) rotate(a=dihedral_big_angle,v=v1)
            linear_extrude(precision) g_rhombus(lado=edge, ancho=thick);
    }
    if(s3)hull(){
        translate((edge+extension)*v1) rotate(a=-dihedral_big_angle,v=v2) translate(-edge*v1)
            linear_extrude(precision) g_rhombus(lado=edge, ancho=thick);
        translate(-extension*v1) rotate(a=-dihedral_big_angle,v=v2) translate(-edge*v1)
            linear_extrude(precision) g_rhombus(lado=edge, ancho=thick);
    }
}