import numpy as np
import cv2
import matplotlib.pyplot as plt
import math as mp

image = cv2.imread('/fs03/share/users/gaelle.leroux/home/Documents/TraitementImage/TP LPE/smarties.png',0)
imageS = cv2.threshold(image,250,255,cv2.THRESH_BINARY_INV)
imageSS = imageS[1]


S = cv2.getStructuringElement(cv2.MORPH_ELLIPSE,(40,20))
imageM = cv2.erode(imageSS, S, iterations = 1)


imageML = cv2.connectedComponents(imageM)
imageMLL = imageML[1]

imageF = cv2.threshold(image,250,33,cv2.THRESH_BINARY)
imageFond = imageF[1]

imageMarqueurs = imageFond+imageMLL


imageD = cv2.distanceTransform(imageSS,cv2.DIST_L2,3,cv2.CV_32F)
u = np.max(imageD)
imageN = imageD * (255/u)

imageI = 255 - imageN

imageF = cv2.threshold(image,250,1,cv2.THRESH_BINARY_INV)
ImageFin = imageI * imageF[1]

u = np.max(ImageFin)
Imagetempo = ImageFin * (255/u)

imageDistFin = np.uint8(Imagetempo)
min = np.max(imageDistFin)
max = np.min(imageDistFin)


T = np.copy(imageMarqueurs)

filex = []
filey = []
for i in range(256):
    filex.append([])
    filey.append([])

taille = imageMarqueurs.shape
taillex = taille[0]
tailley = taille[1]

for i in range(taillex):
    for j in range(tailley):
        if imageMarqueurs[i][j]!=0 :
            filex[imageDistFin[i][j]].append(i)
            filey[imageDistFin[i][j]].append(j)
            # filex[0].append(i)
            # filey[0].append(j)

# print(np.asarray(filez).shape)
# print(filez)

min = 0
while min!=256 :
    # print(len(filex[min]))
    if filex[min]:
        # print(min)
        while filex[min]:
            i = filex[min].pop(0)
            j = filey[min].pop(0)
            # print(len(filex[min]))
            if(i<taillex-1):
                if T[i+1][j]==0:
                    T[i+1][j]=T[i][j]
                    u = imageDistFin[i+1][j]
                    filex[np.max([u,min])].append(i+1)
                    filey[np.max([u,min])].append(j)
                
            if(j<tailley-1):
                if T[i][j+1]==0:
                    T[i][j+1]=T[i][j]
                    u = imageDistFin[i][j+1]
                    filex[np.max([u,min])].append(i)
                    filey[np.max([u,min])].append(j+1)

            if(i!=0) :
                if T[i-1][j]==0:
                    T[i-1][j]=T[i][j]
                    u = imageDistFin[i-1][j]
                    filex[np.max([u,min])].append(i-1)
                    filey[np.max([u,min])].append(j)

            if(j!=0):
                if T[i][j-1]==0:
                    T[i][j-1]=T[i][j]
                    u = imageDistFin[i][j-1]
                    filex[np.max([u,min])].append(i)
                    filey[np.max([u,min])].append(j-1)
            # print('min = {}'.format(min))
            # print('u = {}'.format(u))
    else :
        print(len(filex[min]))
        
        min+=1

plt.figure(2, figsize=(50,20))

plt.subplot(121)
plt.title("Image des distances obtenue avec distanceTransform")
plt.imshow(imageMarqueurs) # affichage de l'image I en niveau de gris

plt.subplot(122)
plt.title("Image des distances obtenue avec distanceTransform")
plt.imshow(T) # affichage de l'image I en niveau de gris
plt.show()
