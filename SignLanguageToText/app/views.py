from django.shortcuts import render
import json
import base64
from rest_framework.decorators import permission_classes
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.http import JsonResponse
from PIL import Image
from io import BytesIO
import numpy as np
from rest_framework import status
import cv2
# Create your views here.
from collections import defaultdict
solution = []
class Graph:
    def minDistance(self,dist,queue):
        minimum = float("Inf")
        min_index = -1
        for i in range(len(dist)):
            if dist[i] < minimum and i in queue:
                minimum = dist[i]
                min_index = i
        return min_index
    def printPath(self, parent, j,i):
        if parent[j] == -1 :
            solution[i][0].append(j)
            return
        self.printPath(parent , parent[j],i)
        solution[i][0].append(j)

    def printSolution(self, dist, parent,source):
        for i in range(0, len(dist)):
            solution.append([[],[dist[i]]])
            self.printPath(parent,i,i)
    def dj(self, graph, src):
        row = len(graph)
        col = len(graph[0])
        dist = [float("Inf")] * row

        parent = [-1] * row
        dist[src] = 0
        queue = []
        for i in range(row):
            queue.append(i)
            
        while queue:
            u = self.minDistance(dist,queue)
            queue.remove(u)

            for i in range(col):
                if graph[u][i] and i in queue:
                    if dist[u] + graph[u][i] < dist[i]:
                        dist[i] = dist[u] + graph[u][i]
                        parent[i] = u
                        
        self.printSolution(dist,parent,src)



graph = [[0, 4, 0, 0, 0, 0, 0, 8, 0],
           [4, 0, 8, 0, 0, 0, 0, 11, 0],
           [0, 8, 0, 7, 0, 4, 0, 0, 2],
           [0, 0, 7, 0, 9, 14, 0, 0, 0],
           [0, 0, 0, 9, 0, 10, 0, 0, 0],
           [0, 0, 4, 14, 10, 0, 2, 0, 0],
           [0, 0, 0, 0, 0, 2, 0, 1, 6],
           [8, 11, 0, 0, 0, 0, 1, 0, 7],
           [0, 0, 2, 0, 0, 0, 6, 7, 0]
           ]


x = {"Mumbai": 0, "Delhi": 1, "Kolkata": 2 , "Maldives": 3, "Dubai": 4, "Bali": 5, "New York": 6, "Bangkok": 7, "London": 8}

@api_view(['POST'])
def AslToText(request):
    if request.method == "POST":
        fro = x[request.data['from']]
        to = x[request.data['to']]
        print("->", request.data['from'], request.data['to'])
        print (fro, to)
        global solution
        solution = []
        g= Graph()
        g.dj(graph,fro)
        ans={}
        print(to,fro,len(solution))
        ans['path'] = solution[to][0]
        ans['cost'] = solution[to][1]
        cs = []
        prev = 0
        for i in solution[to][0]:
            cs.append(solution[i][1][0]-prev)
            prev = solution[i][1][0]
        print(solution)
        print(cs)
        ans['edge']= cs
        return Response(ans,200)
