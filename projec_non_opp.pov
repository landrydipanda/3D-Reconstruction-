#include "shapes.inc"
#include "colors.inc"
#include "textures.inc"
#include "woods.inc"
#include "glass.inc"
#include "metals.inc"
#include "functions.inc" 
#include "stones1.inc"
#include "skies.inc"

#declare Pi = 3.1415926535897932384626;
#declare ciel=1;
#declare sca=3;

// axes
#declare Font="cyrvetic.ttf"
#declare O3=<0,0,0>;
#declare I=<1,0,0>;
#declare J=<0,1,0>;
#declare K=<0,0,1>;
#declare rCyl=0.025;
#declare rCone=0.075;

camera {
location <1.2*sca,1*sca,0.5>
 look_at <0,0,0>
 sky   <0,0,1> // pour avoir le Z en haut
 right <-image_width/image_height,0,0> // pour un repere direct
}



     light_source { <-17, 0, 0> color Magenta }
     light_source { <0, 0, 0> color White }
     light_source { <0, 0, 0> color rgb <0.75,0.5,0.59>spotlight radius 2 falloff 10 tightness 10 point_at <10,0,0>}
     light_source { <0 , 10 , 0 > color  rgb <0.5,0.5,0.49>}
     light_source { <10 , 10 , 10 > color  rgb <0.825,0.5,0.9>}
     light_source { <15 , 15 , -15 > color Red }
     light_source { <15 , 15 , 0 > color Green }
     light_source { <15 , -15 , 15 > color rgb <0.5,0.25,0.49>}



background {White}


global_settings{
  max_trace_level 60//32*3
  ambient_light 1.00
  assumed_gamma 2.0
}


#if (ciel)
    sky_sphere {S_Cloud5 rotate <90,0.051, 1>}
#end


light_source{
	<0,4,-3>
	rgb<1,1,1>
}     
light_source{
	<0,4,3>
	rgb<0,1,1>
} 
light_source{
	<0,4,0>
	rgb<1,0,1>
}


// Elle prends en paramètre les points de contoles et les poids 
     
//1er calcul : ok ok 
                                                                                                                                                                        
#macro calcul1(P0,P1,P2,W0,W1,W2)
//Calcul intermediare :
    #declare n1_x=array[3] ;
    #declare n1_y=array[3] ;
    #declare d_=array[3];

    //1ère simplification numerateur abscisses
    #declare n1_x[0]=W0*P0.x-2*W1*P1.x+W2*P2.x;
    #declare n1_x[1]=-2*W0*P0.x+2*W1*P1.x;
    #declare n1_x[2]=W0*P0.x;    
    
    //1ère simplifcication numerateur ordonnée
    //1ère simplification numerateur abscisses
    #declare n1_y[0]=W0*P0.y-2*W1*P1.y+W2*P2.y;
    #declare n1_y[1]=-2*W0*P0.y+2*W1*P1.y;
    #declare n1_y[2]=W0*P0.y;
    
    //1ère simplification dénominateur commun
    #declare d_[0]=W0-2*W1+W2  ;
    #declare d_[1]=-2*W0+2*W1  ;
    #declare d_[2]=W0          ; 
#end                                              

// 2ème calcul  : calcul de x'(t) , y'(t) et z'(t)       

    //Expression dans la base canonique 1,t,t²,t^3,t^4
#macro calcul2(P0,P1,P1,W0,W1,W2)
    calcul1(P0,P1,P1,W0,W1,W2)

    #declare n2_x=array[5] ;
    #declare n2_y=array[5] ;
    #declare n2_z=array[5];
    #declare d_t=array[5]  ;     
    
    //coefficient numerateurs de x'(t)
    #declare n2_x[0]=2*n1_x[0]*d_[0];                       ;
    #declare n2_x[1]=2*(n1_x[0]*d_[1]+n1_x[1]*d_[0])           ;
    #declare n2_x[2]=2*(n1_x[0]*d_[2]+n1_x[1]*d_[1]+n1_x[2]*d_[0]);   
    #declare n2_x[3]=2*(n1_x[1]*d_[2]+n1_x[2]*d_[1]) ; 
    #declare n2_x[4]=2*(n1_x[2]*d_[2]) ; 
    
    
    //coefficient numerateurs de y'(t)
    #declare n2_y[0]=2*n1_y[0]*d_[0];                       ;
    #declare n2_y[1]=2*(n1_y[0]*d_[1]+n1_y[1]*d_[0])           ;
    #declare n2_y[2]=2*(n1_y[0]*d_[2]+n1_y[1]*d_[1]+n1_y[2]*d_[0]);   
    #declare n2_y[3]=2*(n1_y[1]*d_[2]+n1_y[2]*d_[1]) ; 
    #declare n2_y[4]=2*(n1_y[2]*d_[2]) ;  
    
    //Coefficient numerateur de z'(t)
    
    #declare n2_z[0]=pow(n1_x[0],2) + pow(n1_y[0],2) - pow(d_[0],2) ;
    #declare n2_z[1]=2*n1_x[1]*n1_x[0] + 2*n1_y[1]*n1_y[0] - 2*d_[1]*d_[0] ;
    #declare n2_z[2]=2*n1_x[0]*n1_x[2]+pow(n1_x[1],2)+  2*n1_y[0]*n1_y[2]+pow(n1_y[1],2)- 2*d_[0]*d_[2]-pow(d_[1],2) ;
    #declare n2_z[3]=2*n1_x[1]*n1_x[2]+ 2*n1_y[1]*n1_y[2]- 2*d_[1]*d_[2];
    #declare n2_z[4]=pow(n1_x[2],2)+ pow(n1_y[2],2)- pow(d_[2],2);
    
    //denominateur commun x'(t) et y'(t) 
    
    #declare d_t[0]=pow(n1_x[0],2) + pow(n1_y[0],2) + pow(d_[0],2) ;
    #declare d_t[1]=2*n1_x[1]*n1_x[0] + 2*n1_y[1]*n1_y[0] + 2*d_[1]*d_[0] ;
    #declare d_t[2]=2*n1_x[0]*n1_x[2]+pow(n1_x[1],2)+  2*n1_y[0]*n1_y[2]+pow(n1_y[1],2)+ 2*d_[0]*d_[2]+pow(d_[1],2) ;
    #declare d_t[3]=2*n1_x[1]*n1_x[2]+ 2*n1_y[1]*n1_y[2]+ 2*d_[1]*d_[2];
    #declare d_t[4]=pow(n1_x[2],2)+ pow(n1_y[2],2)+ pow(d_[2],2);   
  

#end    
                                 
    //Expression dans la base de Beinstein

#macro calcul3(P0,P1,P1,W0,W1,W2) 
    calcul2(P0,P1,P1,W0,W1,W2)   
    
    #declare n_x=array[5]
    #declare n_y=array[5]
    #declare n_z=array[5]
    #declare d_b=array[5]


//Expression du numerateur x'(t) dans la base de beinstein

    #declare n_x[0]=n2_x[4] ;
    #declare n_x[1]=(n2_x[3]/4)+n2_x[4] ;  
    #declare n_x[2]=(n2_x[2]/6)+(n2_x[3]/2)+n2_x[4] ;
    #declare n_x[3]=(n2_x[1]/4)+(n2_x[2]/2)+((3*n2_x[3])/4)+n2_x[4]   ;
    #declare n_x[4]=n2_x[0]+n2_x[1]+n2_x[2]+n2_x[3]+n2_x[4]      ;


//Expression du numerateur y'(t) dans la base de beinstein 
    #declare n_y[0]=n2_y[4] ;
    #declare n_y[1]=(n2_y[3]/4)+n2_y[4] ;  
    #declare n_y[2]=(n2_y[2]/6)+(n2_y[3]/2)+n2_y[4] ;
    #declare n_y[3]=(n2_y[1]/4)+(n2_y[2]/2)+((3*n2_y[3])/4)+n2_y[4]   ;
    #declare n_y[4]=n2_y[0]+n2_y[1]+n2_y[2]+n2_y[3]+n2_y[4]      ;

//Expression du  numerateur z'(t) dans la base de beinstein 

    #declare n_z[0]=n2_z[4] ;
    #declare n_z[1]=(n2_z[3]/4)+n2_z[4] ;  
    #declare n_z[2]=(n2_z[2]/6)+(n2_z[3]/2)+n2_z[4] ;
    #declare n_z[3]=(n2_z[1]/4)+(n2_z[2]/2)+((3*n2_z[3])/4)+n2_z[4]   ;
    #declare n_z[4]=n2_z[0]+n2_z[1]+n2_z[2]+n2_z[3]+n2_z[4]      ;


//Expression du denominateur commun 
    #declare d_b[0]=d_t[4] ;
    #declare d_b[1]=(d_t[3]/4)+d_t[4] ;  
    #declare d_b[2]=(d_t[2]/6)+(d_t[3]/2)+d_t[4] ;
    #declare d_b[3]=(d_t[1]/4)+(d_t[2]/2)+((3*d_t[3])/4)+d_t[4]   ;
    #declare d_b[4]=d_t[0]+d_t[1]+d_t[2]+d_t[3]+d_t[4]      ;

#end

    //Calculs les Points de controles et poids : 
    
#macro calcul_bezier_4(P0,P1,P1,W0,W1,W2,ctr_pts,pds)  
    calcul3(P0,P1,P1,W0,W1,W2)
    #local ctr_pts=array[5] ;
        #local ctr_pts[0]=<0,0,0>;   
        #local ctr_pts[1]=<0,0,0>;
        #local ctr_pts[2]=<0,0,0>;
        #local ctr_pts[3]=<0,0,0>;
        #local ctr_pts[4]=<0,0,0>;
    
    #declare pds=array[5]      ;
    
    //calcul des poids : 
    #local pds[0]=d_b[0];
    #local pds[1]=d_b[1];
    #local pds[2]=d_b[2];
    #local pds[3]=d_b[3];
    #local pds[4]=d_b[4];
    
    //Calcul des points de contoles :
        //Calcul des abscisses , ordonnées, cotes 
        #local i=0  ;
        #while(i<4)
            #local ctr_pts[i]=<(n_x[i])/(pds[i]),(n_y[i])/(pds[i]),(n_z[i])/(pds[i]) > ;
            #local i=i+1;
        
        #end
         
#end 


#macro paraBez_4 (t1,P0,P1,P2,P3,P4,W0,W1,W2,W3,W4,M) 
    #local Den=pow((1-t1),4)*W0*P0+ t1*4*pow((1-t1),3)*W1*P1+ 6*pow(t1,2)*W2*P2+ 4*pow(t1,3)*(1-t1)*W3*P3+ pow(t1,4)*W4*P4  ;
    #local Num= pow((1-t1),4)*W0+ t1*4*pow((1-t1),3)*W1+ 6*pow(t1,2)*W2+ 4*pow(t1,3)*(1-t1)*W3+ pow(t1,4)*W4 ;
    #local M=Num/Den;
#end

#macro paraBez_2(t1,P0,P1,P2,W0,W1,W2,M)
    #local Den=pow((1-t1),2)*W0+ t1*2*(1-t1)*W1+ W2*pow(t1,2); 
    #local Num=pow((1-t1),2)*W0*P0+ t1*2*(1-t1)*W1*P1+ W2*pow(t1,2)*P2;
    #local M=Num/Den;
#end

//Affichage d'une courbe de Bézier d'ordre 4 :
#macro aff_Bez_4(nb,P0,P1,P2,P3,P4,W0,W1,W2,W3,W4,dimPt,dimCyl,coulPt,coulCycl)
    #declare tabP=array[nb]
    #local Pas=(1.0)/(nb-1); //mon pas d'avacement de mes elements du tableaux
    #local i=0   ;
    #local j=0    ;
    #while(i<=1)  
        #local Pt=<0,0,0>;
        paraBez_4(i,P0,P1,P2,P3,P4,W0,W1,W2,W3,W4,Pt) 
        #declare tabP[j]=<Pt.x,Pt.y,Pt.z> ;
        #local i=i+Pas   ;
        #local j=j+1  ;  
    #end                              
    /* Affichage des points sous forme de cylindre */
   #local i=0  ; 
    #while(i<nb)
        sphere{
            tabP[i] dimPt
            pigment{coulPt}
        }  
        #local i=i+1;
    #end  
    
    #local i=0 ;
    #while(i<(nb-1))
        cylinder{
            tabP[i] tabP[i+1] dimCyl
            pigment {coulCycl}
        }
       #local i=i+1 ;
    #end   


#end 

//Affichage d'une courbe de Bézier quadratique par des bouts de segments :

#macro aff_Bez_2(nb,P0,P1,P2,W0,W1,W2,dimPt,dimCyl,coulPt,coulCycl)  
    #declare tabP=array[nb]
    #local Pas=(1.0)/(nb-1); //mon pas d'avacement de mes elements du tableaux
    #local i=0   ;
    #local j=0    ;
    #while(i<=1)  
        #local Pt=<0,0,0>;
        paraBez_2(i,P0,P1,P2,W0,W1,W2,Pt) 
        #declare tabP[j]=<Pt.x,Pt.y,0> ;
        #local i=i+Pas   ;
        #local j=j+1  ;  
    #end                              
    /* Affichage des points sous forme de cylindre */
   #local i=0  ; 
    #while(i<nb)
        sphere{
            tabP[i] dimPt
            pigment{coulPt}
        }  
        #local i=i+1;
    #end  
    
    #local i=0 ;
    #while(i<(nb-1))
        cylinder{
            tabP[i] tabP[i+1] dimCyl
            pigment {coulCycl}
        }
       #local i=i+1 ;
    #end  
    
 #end        

//Essayons d'afficher quelque chose:    :        
#declare W0=1 ; 
#declare W1=1 ;
#declare W2=2 ;    

#declare nb=100;   //0.01 0.02
#declare dimPt=0.01;
#declare dimcyl=0.02;           

#declare coulPt=pigment{
    color <1,0,0>
}  ;

#declare coulCyl=pigment{
    color <0,0,1>
} ;
            
                        
                        
sphere{
    <0,1,0> 0.01
    pigment{coulPt}
   }                    
        
#declare P0=<1,0,0>   ;
#declare P1=<1,1,0>   ;
#declare P2=<0,1,0>   ;

//Calcul de points dans le plan de projection : 


#macro ptPlan(x1,y1,Ptpl)  
    #local z1=-sqrt(1-pow(x1,2)-pow(y1,2)); 
    #local Ptpl=<x1/(1-z1),y1/(1-z1)>;
#end   
                  

#declare x1=0.2;
#declare y1=0.8;  

#declare x2=0.7;
#declare y2=0.6;


#declare x3=0.2;
#declare y3=0.6;


#declare pt1=<0.3,0.5,0> ;  
#declare pt2=<0.4,-0.4,0> ;
#declare pt3=<0.6,0.2,0> ;
/*                   
ptPlan(x1,y1,pt1)
ptPlan(x2,y2,pt2)
ptPlan(x3,y3,pt3)     
                  
  */
#declare pds_2=array[3];
#declare pds_2[0]=1;
#declare pds_2[1]=1;
#declare pds_2[2]=0.5;
                                       
#declare crt_pts=array[5]   ;
#declare crt_pts[0]=<0,0,0> ;
#declare crt_pts[1]=<0,0,0> ;
#declare crt_pts[2]=<0,0,0> ;
#declare crt_pts[3]=<0,0,0> ;
#declare crt_pts[4]=<0,0,0> ;

#declare pds=array[5];
#declare pds[0]=0; 
#declare pds[1]=0;
#declare pds[2]=0;
#declare pds[3]=0;
#declare pds[4]=0;
                   

#declare nb=50;  
#declare dimPt= 0.01     ;
#declare dimCyl= 0.02     ;

#declare coulPt=pigment{
    color <1,0,0>
}  ;

#declare coulCyl=pigment{
    color <0,0,1>
} ; 

calcul_bezier_4(pt1,pt2,pt3,pds_2[0],pds_2[1],pds_2[2],crt_pts,pds)   


aff_Bez_2(nb,pt1,pt2,pt3,pds_2[0],pds_2[1],pds_2[2],dimPt,dimCyl,coulPt,coulCyl) 

aff_Bez_4(nb,crt_pts[0],crt_pts[1],crt_pts[2],crt_pts[3],crt_pts[4],pds[0],pds[1],pds[2],pds[3],pds[4],0.6,dimCyl,coulPt,coulCyl)

sphere{
<0,0,0> 1
pigment{
rgb<1,0,1>
}
}


//aff_Bez_2(nb,P0,P1,P2