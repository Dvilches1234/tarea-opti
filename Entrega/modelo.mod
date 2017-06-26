#--------------------------------           PARAMETROS Y VARIABLES TIENEN COMENTADO A UN LADO
#--------------------------------           SU RESPECTIVA NOMENCLATURA EN LA PAUTA ENTREGADA
#CONJUNTOS                                  POR EL PROFESOR
#--------------------------------

set ESTANCIAS;    #i
set CAMIONES;     #k
set DIAS;         #t

#--------------------------------
#--------------------------------
#PARAMETROS
#--------------------------------

param p_agropat_max;      #N
param cap_contenedor;     #U
param distancia{i in ESTANCIAS};    #D_i
param precio_c{k in CAMIONES};      #C_k
param precio_agropat{t in DIAS};  #P_1t
param precio_arriendo{t in DIAS}; #P_2t
param cap_camion{k in CAMIONES};   #F_k
param lana_estancia{i in ESTANCIAS};   #L_i


#--------------------------------
#--------------------------------
#VARIABLES
#--------------------------------

var arrienda{i in ESTANCIAS, k in CAMIONES, t in DIAS } binary;  #x_ikt
var retira{i in ESTANCIAS, t in DIAS} binary;  #y_it
var contenedores_agropat{t in DIAS} integer >= 0;     #v_t
var contenedores_arriendo{t in DIAS} integer >= 0;     #w_t
#-------VARIABLES EXTRAS------------------------
#----------------------------------------------
#var inventario{t in DIAS} integer >= 0; # m_t
#var lana_bodega{t in DIAS} integer >= 0; #n_t
#--------------------------------
#--------------------------------
#FUNCION OBJETIVO
#--------------------------------

minimize z:
 sum{i in ESTANCIAS, k in CAMIONES, t in DIAS} distancia[i] * precio_c[k] * arrienda[i,k,t]
 + sum{t in DIAS} (precio_agropat[t] * contenedores_agropat[t] + precio_arriendo[t] * contenedores_arriendo[t]);

 #--------------------------------                    RESTRICCIONES ENUMERADAS SEGÚN EL ENUNCIADO
 #--------------------------------
 #RESTRICCIONES
 #--------------------------------

 subject to camion_dia {k in CAMIONES, t in DIAS}:                #RESTRICCION 2
    sum{i in ESTANCIAS} arrienda[i,k,t] <= 1;

subject to todo_dia{i in ESTANCIAS}:                            #RESTRICCION 3
  sum{t in DIAS }retira[i,t] == 1; #COMPARADOR ES == no =

 subject to capacidad_minima{i in ESTANCIAS, t in DIAS}:
  sum{k in CAMIONES} cap_camion[k]*arrienda[i,k,t] >= lana_estancia[i] * retira[i,t]; #RESTRICCION 4

subject to no_ultimo_dia:                         ##RESTRICCION 5
  sum{i in ESTANCIAS} retira[ i,60] == 0;

subject to compactar_lana{t in DIAS: t > 1}:                              #RESTRICCION 6
  sum{i in ESTANCIAS} lana_estancia[i] * retira[i, t - 1] <= cap_contenedor * (contenedores_agropat[t] + contenedores_arriendo[t]);

subject to max_agropat {t in DIAS} :                        # #RESTRICCION 7
	contenedores_agropat[t] <= p_agropat_max;

#------ RESTRICCIONES EXTRAS --------------    ESTAS RESTRICCIONES SON DEL SEGUNDO MODELO
#------------------------------------
#subject to retirada_bodega {t in DIAS}:
#  lana_bodega[t] <= cap_contenedor * (contenedores_agropat[t] + contenedores_arriendo[t]);

#subject to cantidad_inventario {t in DIAS}:
#  inventario[t] = inventario[t - 1] + sum{i in ESTANCIAS} lana_estancia[i] * retira[i][t-1] - lana_bodega[t];
