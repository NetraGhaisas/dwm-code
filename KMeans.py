import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import copy

def plot_dataset(df,x,y,k,centroidx,centroidy,ptcolor,ctcolor,opacity):
    fig = plt.figure(figsize=(5, 5))
    for i in range(df.shape[0]):
        plt.plot(x[i],y[i],'bo',marker='o',markersize=5, color=ptcolor[i],alpha=opacity)
    for i in range(k):
        plt.plot(centroidx[i],centroidy[i],'bo',marker='o',markersize=7, color=ctcolor[i])
    plt.xlim(min(x)-5, max(x)+5)
    plt.ylim(min(y)-5,max(y)+5)
    plt.show(block=True)

def make_clusters(df, centroids, colmap,num_features):
    features = list(df)[:num_features]
    for i in centroids.index:
        df['dist_square'] = pd.Series([0 for i in range(df.shape[0])])
        # print('RE INITED')
        # print(centroids)
        for k in features:
            # print(i,k,num_features,centroids[k][i],df[k])
            centre = centroids[k][i]
            df['dist_square'] += (df[k] - centre)**num_features
            # print(k,df)
        df['distance_from_{}'.format(i)] = abs(df['dist_square'])**(1/num_features)
        # print(i,df)
    centroid_dists = ['distance_from_{}'.format(i) for i in centroids.index]
    df['closest'] = df.loc[:, centroid_dists].idxmin(axis=1)
    df['closest'] = df['closest'].map(lambda x: int(x.lstrip('distance_from_')))
    df['color'] = df['closest'].map(lambda x: colmap[x])
    return df


def update_centroids(df,centroids):
    for i in centroids.index:
        for k in centroids.columns:
            match_df = df[df['closest'] == i][k]
            # print('FOR FEATURE AND I: '+str(k)+' '+str(i))
            # print(df[df['closest'] == i][k])
            if not match_df.empty:
                centroids.loc[i,k] = np.nanmean(df[df['closest'] == i][k])
    return centroids

def read_dataset():
    # f = open('test2.csv','r')
    # dataset = [int(x) for x in f.readline().split(',')]
    # print(dataset)
    # df = pd.DataFrame({'x':dataset, 'color':['k' for i in range(len(dataset))] })
    filepath = input("Enter file to read: ")
    df = pd.read_csv('./'+filepath)
    dmin = min(df.min())
    dmax = max(df.max())
    df['color'] = ['k' for i in range(df.shape[0])]
    return df,len(df.columns)-1,dmin,dmax

# NUM = 50

# dataset = np.array([np.random.randint(1,1000) for i in range(NUM)])


df,num_features,dmin,dmax = read_dataset()
print(df)
# k = 3
k=int(input('Enter value of K: '))
f1 = input("Enter feature to plot on x axis: ")
f2 = input("Enter feature to plot on y axis: ")
colmap = list(input("Enter colors for clusters: ").split())

np.random.seed(int(dmin))

# centroids = {
#     i+1: {'x': np.random.randint(0, 1000)}
#     for i in range(k)
# }

# centroids = pd.DataFrame({'x':[np.random.randint(0,1000) for i in range(k)]})
centroids = pd.DataFrame({feat : [np.random.randint(int(dmin),int(dmax+1)) for i in range(k)] for feat in list(df)[:-1]})
print('Centroids')
print(centroids)
    
# colmap = ['r','g','b']
if num_features <= 1:
    plot_dataset(df,list(df[f1]),np.zeros_like(df[f1]),k,list(centroids[f1]),np.zeros(k),df['color'],colmap,1)
else:
    plot_dataset(df,list(df[f1]),list(df[f2]),k,list(centroids[f1]),list(centroids[f2]),df['color'],colmap,1)

# initialization
df = make_clusters(df,centroids,colmap,1)
centroids = update_centroids(df,centroids)
# print(df.head(10))
counter = 0
while True:
    closest_centroids = df['closest'].copy(deep=True)
    centroids = update_centroids(df,centroids)
    df = make_clusters(df, centroids,colmap,1)
    print("\nIteration "+str(counter))
    print(df.head(10))
    counter+=1
    if closest_centroids.equals(df['closest']):
        break

print('\nFinal result')
print(df.head(10))
print('\nCentroids')
print(centroids)
# for i in range(1,k+1):
#     print('Cluster '+str(i)+' (Mean: '+str(centroids[i])+'): '+str(list(df[df['closest']==i]['x'])))

# if num_features <= 1:
#     plot_dataset(df,df[f1],np.zeros_like(df[f1]),k,list(centroids['x']),np.zeros(k),df['color'],colmap,0.3)
# else:

if num_features <= 1:
    plot_dataset(df,list(df[f1]),np.zeros_like(df[f1]),k,list(centroids[f1]),np.zeros(k),df['color'],colmap,0.3)
else:
    plot_dataset(df,list(df[f1]),list(df[f2]),k,list(centroids[f1]),list(centroids[f2]),df['color'],colmap,0.3)