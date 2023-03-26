###CONTRIBUTORS###
#CLAVEL Vincent
#LE Celia
##################

###Code###
#Ce code met en oeuvre la methode de segmentation du snake
##########

import numpy as np
import matplotlib.pyplot as plt
import random
from scipy.ndimage import gaussian_filter

###Fonction de bruitage poivre et sel###
def bruitage_poivresel(image,prob):
    output = np.zeros(image.shape, dtype=np.uint8)
    l=len(image)
    c=len(image[0])
    for i in range(l):
        for j in range(c):
            rdn = random.random()
            if rdn < prob:
                output[i][j] = 0
            elif rdn > 1-prob:
                output[i][j] = 1
            else:
                output[i][j] = image[i][j]
    return output
########################################

###Ouverture image###
ImageOriginale = plt.imread("im6.png")
ImageOriginale = ImageOriginale[:,:,0]
#ImageOriginale=bruitage_poivresel(ImageOriginale,0.005)
ImageOriginale=gaussian_filter(ImageOriginale,1)
lignes = len(ImageOriginale)
colones = len(ImageOriginale[0])
plt.figure(1)
plt.imshow(ImageOriginale,'gray')
plt.show()
#####################

###Parametres###
alpha = 1
beta = 0.5
gamma = 15
################

###Creation du snake###
centre=[int(colones/2),int(lignes/2)]
rayon=min(int((colones-5)/2),int((lignes-5)/2))
delta = 1.
K = 1000
snakeX = []
snakeY = []
pas = (2*np.pi)/K
for i in range(K):
    teta = i*pas
    snakeX = np.append(snakeX, int(centre[0] + rayon * np.cos(teta)))
    snakeY = np.append(snakeY, int(centre[1] + rayon * np.sin(teta)))
#######################

###Creation de D2, D4, D et A###
Mat_Identite = np.identity(K)
D2 = np.roll(Mat_Identite, -1, axis=1) + Mat_Identite*(-2) + np.roll(Mat_Identite,1, axis=1)
D4 = (np.roll(Mat_Identite, -1, axis=1) + np.roll(Mat_Identite,1, axis=1))*-4 + (np.roll(Mat_Identite, -2, axis=1) + np.roll(Mat_Identite,2, axis=1)) + Mat_Identite*(6)
D = alpha*D2 - beta*D4
A = np.linalg.inv(Mat_Identite - D)
################################

###Calcul des differents gradient necessaires###
gradY,gradX = np.gradient(ImageOriginale)
gradient = gradX**2 + gradY**2
GradGradY, GradGradX = np.gradient(gradient)
################################################

###Algorithme iteratif###
GradSuivX = np.zeros(snakeX.shape)
GradSuivY = np.zeros(snakeY.shape)
compteur=0
k=0
while compteur<16000:
    for i in range(K):
        Y=int(snakeY[i])
        X=int(snakeX[i])
        GradSuivX[i] = GradGradX[Y][X]
        GradSuivY[i] = GradGradY[Y][X]
    snakeX = np.dot(A, snakeX+gamma*GradSuivX)
    snakeY = np.dot(A, snakeY+gamma*GradSuivY)
    if compteur%2000==0:
        if k==0:
            Snake1 = [snakeX,snakeY]
        if k==1:
            Snake2 = [snakeX,snakeY]
        if k==2:
            Snake3 = [snakeX,snakeY]
        if k==3:
            Snake4 = [snakeX,snakeY]
        if k==4:
            Snake5 = [snakeX,snakeY]
        if k==5:
            Snake6 = [snakeX,snakeY]
        if k==6:
            Snake7 = [snakeX,snakeY]
        if k==7:
            Snake8 = [snakeX,snakeY]
        k+=1
    compteur += 1
#########################

###Affichage(s)###
plt.figure(2)
for i in range(8):
    plt.subplot(2,4,i+1)
    titre=str(i*1000)+'eme iteration'
    plt.title(titre)
    plt.imshow(ImageOriginale,'gray')
    if i == 0:
        plt.plot(Snake1[0], Snake1[1], 'g', linewidth=3)
    if i == 1:
        plt.plot(Snake2[0], Snake2[1], 'g', linewidth=3)
    if i == 2:
        plt.plot(Snake3[0], Snake3[1], 'g', linewidth=3)
    if i == 3:
        plt.plot(Snake4[0], Snake4[1], 'g', linewidth=3)
    if i == 4:
        plt.plot(Snake5[0], Snake5[1], 'g', linewidth=3)
    if i == 5:
        plt.plot(Snake6[0], Snake6[1], 'g', linewidth=3)
    if i == 6:
        plt.plot(Snake7[0], Snake7[1], 'g', linewidth=3)
    if i == 7:
        plt.plot(Snake8[0], Snake8[1], 'g', linewidth=3)
plt.show()
plt.figure(3)
plt.imshow(ImageOriginale,'gray')
plt.plot(snakeX, snakeY, 'g', linewidth=3)
plt.show()
##################