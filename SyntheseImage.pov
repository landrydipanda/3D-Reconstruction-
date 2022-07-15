#include "math.inc"  
#include "colors.inc"

#declare Pi = 3.1415926535897932384626;

camera{
location<5,4,-5>
look_at<0,0,0>
}

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

//dans le cas ou on a deux points diametre du cercle
//Prends en parametre nos deux points de controles extrêmes  
//choix1 : x=0 , choix2: y=0 , choix3 z=0
#macro calcul(P0,P1,P2,W0,W2,choix,rayon,centre)
    

    #local P0P2=P2-P0 ; 
    #declare centre=0.5*(P2+P0) ;
    
    #declare rayon= 0.5*sqrt(pow(P2.x-P0.x,2)+pow(P2.y-P0.y,2)+pow(P2.z-P0.z,2)); 
    #if (choix=1)
        #local P1=<-P0P2.z,0,P0P2.y> ;
        #local n_u=vlength(P0P2)*vlength(P0P2)  ;
        #local n_P1=vlength(P1)*vlength(P1)  ;
        #local W0=1              ;
        #local W2=4*n_P1/(n_u*W0)   ;
    #end
   
    #if (choix=2)  
        #local P1=<-P0P2.z,0,P0P2.x> ;
        #local n_u=vlength(P0P2)*vlength(P0P2)  ;
        #local n_P1=vlength(P1)*vlength(P1)  ;
        #local W0=1              ;
        #local W2=4*n_P1/(n_u*W0)   ;
    #end
   
    #if (choix=3)
        #local P1=<-P0P2.y,0,P0P2.x> ;
        #local n_u=vlength(P0P2)*vlength(P0P2)  ;
        #local n_P1=vlength(P1)*vlength(P1)  ;
        #local W0=1              ;
        #local W2=4*n_P1/(n_u*W0)   ;
    #end
   
    //vecteur orthogonal à P0P2
   // #local P1=<-P0P2.y,P0P2.x,0> ;  
    #local P1=<-P0P2.z,0,P0P2.x> ;
    #local n_u=vlength(P0P2)*vlength(P0P2)  ;
    #local n_P1=vlength(P1)*vlength(P1)  ;
    #local W0=1              ;
    #local W2=4*n_P1/(n_u*W0)   ;  
   
#end 
         

//dans le cas ou les deux points ne sont pas diametre du cercle         
//P0 , P1 et P2 trois points du cercle :
#macro calcul_xy(P0,P1,P2,a_,b_,r_c)
    #local b_=( (pow(P2.y,2)+pow(P2.x,2)-pow(P0.x,2)-pow(P0.y,2))/(2*P2.x-2*P0.x)-(pow(P1.y,2)+pow(P1.x,2)-pow(P0.x,2)-pow(P0.y,2))/(2*P2.x-2*P0.x) ) / ( (2*P0.y-2*P1.y)/(2*P1.x-2*P0.x)-(2*P0.y-2*P2.y)/(2*P2.x-2*P0.x)  ) ;
    #local a_=((2*P0.y-2*P2.y)*b_+pow(P2.y,2)+pow(P2.x,2)-pow(P0.x,2)-pow(P0.y,2))/(2*P2.x-2*P0.x);
    //Calcul du centre
    #local r_c=sqrt(pow(P2.x,2)-2*P2.x*a_+pow(a_,2)+pow(P2.y,2)-2*P2.y*b_+pow(b_,2) );
    //On a le centre du cercle et on a le rayon c'est terminer :  
#end

#macro calcul_xz(P0,P1,P2)
    #declare b_=( (pow(P2.z,2)+pow(P2.x,2)-pow(P0.x,2)-pow(P0.z,2))/(2*P2.x-2*P0.x)-(pow(P1.z,2)+pow(P1.x,2)-pow(P0.x,2)-pow(P0.z,2))/(2*P2.x-2*P0.x) ) / ( (2*P0.z-2*P1.z)/(2*P1.x-2*P0.x)-(2*P0.z-2*P2.z)/(2*P2.x-2*P0.x)  ) ;
    #declare a_=((2*P0.z-2*P2.z)*b_+pow(P2.z,2)+pow(P2.x,2)-pow(P0.x,2)-pow(P0.z,2))/(2*P2.x-2P0.x);
    //Calcul du centre
    #declare r_c=sqrt(pow(P2.x,2)-2*P2.x*a_+pow(a_,2)+pow(P2.z,2)-2*P2.z*b_+pow(b_,2) );
    //On a le centre du cercle et on a le rayon c'est terminer :  
#end

#macro calcul_yz(P0,P1,P2)
    #declare b_=( (pow(P2.z,2)+pow(P2.y,2)-pow(P0.y,2)-pow(P0.z,2))/(2*P2.y-2*P0.y)-(pow(P1.z,2)+pow(P1.y,2)-pow(P0.y,2)-pow(P0.z,2))/(2*P2.y-2*P0.y) ) / ( (2*P0.z-2*P1.z)/(2*P1.y-2*P0.y)-(2*P0.z-2*P2.z)/(2*P2.y-2*P0.y)  ) ;
    #declare a_=((2*P0.y-2*P2.y)*b_+pow(P2.y,2)+pow(P2.x,2)-pow(P0.x,2)-pow(P0.y,2))/(2*P2.x-2P0.x);
    //Calcul du centre
    #declare r_c=sqrt(pow(P2.y,2)-2*P2.y*a_+pow(a_,2)+pow(P2.z,2)-2*P2.z*b_+pow(b_,2) );
    //On a le centre du cercle et on a le rayon c'est terminer :  
#end
 
//P1 c'est le point du cercle
#macro calcul_OK(P0,P1,P1_,P2,W1,centre,rayon)
    #local a_=0;
    #local b_=0;
    #local r_c=0;
    //prends en paramètre les 3 points du cercle
    calcul_xy(P0,P1,P2,a_,b_,r_c)
    #declare rayon=r_c;
    #declare Oo=<a_,b_,0>;
    #declare centre=Oo;
    #local I1=(P2+P0)/2;
   
    #local OP0=P0-Oo ;
    #local I1P0=P0-I1 ;
    #local OoI1=I1-Oo ;    
   
    #local T1=(vdot(OP0,I1P0)/vdot(OP0,OoI1)) ;  
   
    //calcul de P1_
    #local P1_=I1+T1*OoI1;
    #local P0P1_=P1_-P0  ;
    #local P0P2=P2-P0;  
   
    //calcul de W1
    #declare cos_angle=(vdot(P0P1_,P0P2))/(pow(P0P1_.x,2)+pow(P0P1_.y,2)+pow(P0P1_.z,2)+pow(P0P2.x,2)+pow(P0P2.y,2)+pow(P0P2.z,2));
    #local W1=sqrt(pow(cos_angle,2));
#end
 
//pour le cas ou P1 et P2 ne font pas le diametre      
#macro paraBez_2_arc(t1,P0,P1,P2,W0,W1,W2,M)
    #local Den=pow((1-t1),2)*W0+ t1*2*(1-t1)*W1+ W2*pow(t1,2);
    #local Num=pow((1-t1),2)*W0*P0+ t1*2*(1-t1)*W1*P1+ W2*pow(t1,2)*P2;
    #local M=Num/Den;
#end    
   
//pour le cas ou p1 et p2 font le diametre
#macro paraBez_2_cercle(t1,P0,P1,P2,W0,W2,M)
    #local Den=W0*pow((1-t1),2)+W2*pow(t1,2) ;      
    #local Num=pow((1-t1),2)*W0*P0+ 2*t1*(1-t1)*P1+ W2*pow(t1,2)*P2;
    #local M=Num/Den   ;
#end 
   
//Affichage de la courbe de Bézier quadratique :

#macro aff_Bez_2(nb,P0,P1,P2,W0,W2,dimPt,dimCyl,coulPt,coulCycl,choix)  
    #declare tabP=array[nb]
    #local Pas=(1.0)/(nb-1); //mon pas d'avacement de mes elements du tableaux
    #local i=0   ;
    #local j=0    ;
    #while(i<=1)  
        #local Pt=<0,0,0>;
        #if (choix=2)
            paraBez_2_arc(i,P0,P1,P2,W0,W1,W2,Pt)
        #end 
        #if (choix=1)
            paraBez_2_cercle(i,P0,P1,P2,W0,W2,Pt)
        #end
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
      
      
//Gestion du poids W1 qui sera calculer :

#declare W1=0;


#declare nb=50            ;  
#declare dimPt= 0.01      ;
#declare dimCyl= 0.02     ;

#declare coulPt=pigment{
    color <1,0,0>
}  ;

#declare coulCyl=pigment{
    color <0,0,1>
} ;  


//le i correspont au choix des points de controle a utiliser. si on veut une demi-cercle ou arc     
#declare i=2;


#switch (i)
#case (1) 
    #include "Points1.inc"; 
    #local centre=<0,0,0> ;
    #local rayon=0 ;
    calcul(P0,P1,P2,W0,W2,2,rayon,centre)
    aff_Bez_2(nb,P0,P1,P2,W0,W2,dimPt,dimCyl,coulPt,coulCyl,1)
    cylinder {  P0 P1 dimPt/3
        pigment {color White}
        
    }  
    
    cylinder {  P1 P2 dimPt/3
        pigment {color White}
        
    } 
#break;
#case (2)  

    #include "Points2.inc";
    #local centre=<0,0,0> ;
    #local rayon=0 ;

    calcul_OK(P0,P1,P1_,P2,W1,centre,rayon)
    aff_Bez_2(nb,P0,P1_,P2,W0,W2,dimPt,dimCyl,coulPt,coulCyl,2) 
    sphere {
        P1_ dimPt*3
        pigment{color Yellow}
    } 

    cylinder {  P0 P1_ dimPt/3
        pigment {color White}
        
    }  
    
    cylinder {  P1_ P2 dimPt/3
        pigment {color White}
        
    }
    
    //le centre du cercle
    
    sphere {
        centre dimPt*2
        pigment{color White}
    } 
#break;
#case (3) #include "Points2.inc";
#break;
#end 

 


  


sphere {
    P0 dimPt*2
    pigment{color Magenta}
}
      
sphere {
    P1 dimPt*2
    pigment{color White}
}

sphere {
    P2 dimPt*2
    pigment{color Green}
}

   


 
//calcul(P0,P1,P2,W0,W2,2)    

      


//recuperation du point suivant de la courbe de la courbe a un instant pour être le centre de la sphere en mouvement 
#declare centrePtiSphere=tabP[floor(nb*clock)]; 

sphere{ (1+0.3/rayon)*centrePtiSphere 0.3
        texture{ pigment{ rgb<1,0,0>}
                  finish { diffuse 0.9
                           phong 1}
               } // end of texture 
              
} // fin de sphere -------------   


// La sphere fixe:
sphere{ centre, rayon
        texture{ pigment{ rgb<1,1,0>}
                  finish { diffuse 0.9
                           phong 1} //pour donner plus de lumiere a l'objet
               } // end of texture   
               
 }     
 











 
 
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



     light_source { <-17, 0, 0> color White }
     light_source { <0, 0, 0> color White }
    
     light_source { <0 , 10 , 0 > color  White}
     light_source { <10 , 10 , 10 > color  White}
     light_source { <15 , 15 , 0 > color White }
     light_source { <15 , -15 , 15 > color rgb White}



background {White}


global_settings{
  max_trace_level 60//32*3
  ambient_light 1.00
  assumed_gamma 2.0
}


#if (ciel)
    sky_sphere {S_Cloud5 rotate <9,0.051, 1>}
#end

#macro flecheDiffuseNom(G,H,Coul,alph,rCyl,rCon,diffu,text1,sca,rot,trans)
#local H1 = G + alph* (H-G);
union{
    union{
      cylinder{
	  G, H1, rCyl
     }
      cone{
	  H1, rCon
	  H , 0
      }
    }
    text {
                ttf "timrom.ttf"  text1
	        0.1, 0  
                scale sca 
                rotate rot
                translate trans   
    } 
    pigment {color Coul} finish {diffuse diffu}
    
   translate <3,-5,4>  //pour le positionner devant la camera 
}// fin union
#end // fin macro fleche


//sca,rot,trans
flecheDiffuseNom(O3,I,Red,0.75,rCyl,rCone,1,"X",0.35,<9,0,0>,<0.5,0,0.125>)
flecheDiffuseNom(O3,J,Green,0.75,rCyl,rCone,1,"Y",0.35,<9,0,-4.5>,<0.0,0.75,0.1250>)
flecheDiffuseNom(O3,K,Blue,0.75,rCyl,rCone,1,"Z",0.35,<9,0,18>,<-0.20,0.0,0.750>)

plane{
-z 150
  pigment{ brick rgbt<1.0,1.,1.0,0.250>, rgbt<0.750,.5,0.0,0.850>  
	      mortar 5 brick_size 125   
	 }	
rotate <0,0,45>
}
