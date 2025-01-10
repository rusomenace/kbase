### Lista el agregado
c190::*> aggr show
```
Aggregate     Size Available Used% State   #Vols  Nodes            RAID Status
--------- -------- --------- ----- ------- ------ ---------------- ------------
aggr_c190_n01_01
            3.29TB    3.29TB    0% online       2 c190_n01         raid_dp,
                                                                   normal
aggr_c190_n02_01
            3.29TB    3.29TB    0% online       0 c190_n02         raid_dp,
                                                                   normal
aggr_root_c190_n01
           159.9GB    7.75GB   95% online       1 c190_n01         raid_dp,
                                                                   normal
aggr_root_c190_n02
           159.9GB    7.75GB   95% online       1 c190_n02         raid_dp,
                                                                   normal
4 entries were displayed.
```
### Listar particiones de todos los discos
```
c190::*> storag disk partition show
  (storage disk partition show)
                          Usable  Container     Container
Partition                 Size    Type          Name              Owner
------------------------- ------- ------------- ----------------- -----------------
1.0.0.P1                  415.8GB aggregate     /aggr_c190_n01_01/plex0/rg0
                                                                  c190_n01
1.0.0.P2                  415.8GB aggregate     /aggr_c190_n02_01/plex0/rg0
                                                                  c190_n02
1.0.0.P3                  62.35GB aggregate     /aggr_root_c190_n02/plex0/rg0
                                                                  c190_n02
1.0.1.P1                  415.8GB aggregate     /aggr_c190_n01_01/plex0/rg0
                                                                  c190_n01
1.0.1.P2                  415.8GB aggregate     /aggr_c190_n02_01/plex0/rg0
                                                                  c190_n02
1.0.1.P3                  62.35GB aggregate     /aggr_root_c190_n02/plex0/rg0
                                                                  c190_n02
1.0.2.P1                  415.8GB aggregate     /aggr_c190_n01_01/plex0/rg0
                                                                  c190_n01
1.0.2.P2                  415.8GB aggregate     /aggr_c190_n02_01/plex0/rg0
                                                                  c190_n02
1.0.2.P3                  62.35GB aggregate     /aggr_root_c190_n02/plex0/rg0
                                                                  c190_n02
1.0.3.P1                  415.8GB aggregate     /aggr_c190_n01_01/plex0/rg0
                                                                  c190_n01
1.0.3.P2                  415.8GB aggregate     /aggr_c190_n02_01/plex0/rg0
                                                                  c190_n02
1.0.3.P3                  62.35GB aggregate     /aggr_root_c190_n02/plex0/rg0
                                                                  c190_n02
1.0.4.P1                  415.8GB aggregate     /aggr_c190_n01_01/plex0/rg0
                                                                  c190_n01
1.0.4.P2                  415.8GB aggregate     /aggr_c190_n02_01/plex0/rg0
                                                                  c190_n02
1.0.4.P3                  62.35GB aggregate     /aggr_root_c190_n02/plex0/rg0
                                                                  c190_n02
1.0.5.P1                  415.8GB aggregate     /aggr_c190_n01_01/plex0/rg0
                                                                  c190_n01
1.0.5.P2                  415.8GB aggregate     /aggr_c190_n02_01/plex0/rg0
                                                                  c190_n02
1.0.5.P3                  62.35GB spare         Pool0             c190_n02
1.0.6.P1                  431.4GB spare         Pool0             c190_n01
1.0.6.P2                  431.4GB spare         Pool0             c190_n02
1.0.6.P3                  31.19GB spare         Pool0             c190_n02
1.0.7.P1                  431.4GB spare         Pool0             c190_n01
1.0.7.P2                  431.4GB spare         Pool0             c190_n02
1.0.7.P3                  31.19GB aggregate     /aggr0/plex0/rg0  c190_n02
1.0.8.P1                  431.4GB spare         Pool0             c190_n01
1.0.8.P2                  431.4GB spare         Pool0             c190_n02
1.0.8.P3                  31.19GB aggregate     /aggr0/plex0/rg0  c190_n02
1.0.15.P1                       - unassigned    -                 -
1.0.15.P2                       - unassigned    -                 -
1.0.15.P3                       - unassigned    -                 -
1.0.16.P1                       - unassigned    -                 -
1.0.16.P2                       - unassigned    -                 -
1.0.16.P3                       - unassigned    -                 -
1.0.17.P1                       - unassigned    -                 -
1.0.17.P2                       - unassigned    -                 -
1.0.17.P3                       - unassigned    -                 -
1.0.18.P1                 415.8GB aggregate     /aggr_c190_n01_01/plex0/rg0
                                                                  c190_n01
1.0.18.P2                 415.8GB aggregate     /aggr_c190_n02_01/plex0/rg0
                                                                  c190_n02
1.0.18.P3                 62.35GB aggregate     /aggr_root_c190_n01/plex0/rg0
                                                                  c190_n01
1.0.19.P1                 415.8GB aggregate     /aggr_c190_n01_01/plex0/rg0
                                                                  c190_n01
1.0.19.P2                 415.8GB aggregate     /aggr_c190_n02_01/plex0/rg0
                                                                  c190_n02
1.0.19.P3                 62.35GB aggregate     /aggr_root_c190_n01/plex0/rg0
                                                                  c190_n01
1.0.20.P1                 415.8GB aggregate     /aggr_c190_n01_01/plex0/rg0
                                                                  c190_n01

                          Usable  Container     Container
Partition                 Size    Type          Name              Owner
------------------------- ------- ------------- ----------------- -----------------
1.0.20.P2                 415.8GB aggregate     /aggr_c190_n02_01/plex0/rg0
                                                                  c190_n02
1.0.20.P3                 62.35GB aggregate     /aggr_root_c190_n01/plex0/rg0
                                                                  c190_n01
1.0.21.P1                 415.8GB aggregate     /aggr_c190_n01_01/plex0/rg0
                                                                  c190_n01
1.0.21.P2                 415.8GB aggregate     /aggr_c190_n02_01/plex0/rg0
                                                                  c190_n02
1.0.21.P3                 62.35GB aggregate     /aggr_root_c190_n01/plex0/rg0
                                                                  c190_n01
1.0.22.P1                 415.8GB aggregate     /aggr_c190_n01_01/plex0/rg0
                                                                  c190_n01
1.0.22.P2                 415.8GB aggregate     /aggr_c190_n02_01/plex0/rg0
                                                                  c190_n02
1.0.22.P3                 62.35GB aggregate     /aggr_root_c190_n01/plex0/rg0
                                                                  c190_n01
1.0.23.P1                 415.8GB spare         Pool0             c190_n01
1.0.23.P2                 415.8GB spare         Pool0             c190_n02
1.0.23.P3                 62.35GB spare         Pool0             c190_n01
54 entries were displayed.
```
### Asignar particiones a nodos
```
c190::*> storage disk partition assign -partition 1.0.15.P1 -owner c190_n01

c190::*> storage disk partition assign -partition 1.0.16.P1 -owner c190_n01

c190::*> storage disk partition assign -partition 1.0.17.P1 -owner c190_n01

c190::*> storage disk partition assign -partition 1.0.15.P1 -owner c190_n02

Error: command failed: Failed to assign disks. Reason: Disk 1.0.15.P1 is already owned.

c190::*> storage disk partition assign -partition 1.0.15.P2 -owner c190_n02

c190::*> storage disk partition assign -partition 1.0.16.P2 -owner c190_n02

c190::*> storage disk partition assign -partition 1.0.17.P2 -owner c190_n02

c190::*> storage disk partition assign -partition 1.0.15.P3 -owner c190_n01

c190::*> storage disk partition assign -partition 1.0.16.P3 -owner c190_n01

c190::*> storage disk partition assign -partition 1.0.17.P3 -owner c190_n01
```


### Se ve el agregado viejo
```
c190::*> storage disk show
                     Usable           Disk    Container   Container
Disk                   Size Shelf Bay Type    Type        Name      Owner
---------------- ---------- ----- --- ------- ----------- --------- --------
1.0.0               894.0GB     0   0 SSD     shared      aggr_c190_n01_01, aggr_c190_n02_01, aggr_root_c190_n02
                                                                    c190_n02
1.0.1               894.0GB     0   1 SSD     shared      aggr_c190_n01_01, aggr_c190_n02_01, aggr_root_c190_n02
                                                                    c190_n02
1.0.2               894.0GB     0   2 SSD     shared      aggr_c190_n01_01, aggr_c190_n02_01, aggr_root_c190_n02
                                                                    c190_n02
1.0.3               894.0GB     0   3 SSD     shared      aggr_c190_n01_01, aggr_c190_n02_01, aggr_root_c190_n02
                                                                    c190_n02
1.0.4               894.0GB     0   4 SSD     shared      aggr_c190_n01_01, aggr_c190_n02_01, aggr_root_c190_n02
                                                                    c190_n02
1.0.5               894.0GB     0   5 SSD     shared      aggr_c190_n01_01, aggr_c190_n02_01
                                                                    c190_n02
1.0.6               894.0GB     0   6 SSD     shared      -         c190_n02
*1.0.7               894.0GB     0   7 SSD     shared      aggr0     c190_n02*
*1.0.8               894.0GB     0   8 SSD     shared      aggr0     c190_n02*
1.0.15              894.0GB     0  15 SSD     shared      -         c190_n01
1.0.16              894.0GB     0  16 SSD     shared      -         c190_n01
1.0.17              894.0GB     0  17 SSD     shared      -         c190_n01
1.0.18              894.0GB     0  18 SSD     shared      aggr_c190_n01_01, aggr_c190_n02_01, aggr_root_c190_n01
                                                                    c190_n01
1.0.19              894.0GB     0  19 SSD     shared      aggr_c190_n01_01, aggr_c190_n02_01, aggr_root_c190_n01
                                                                    c190_n01
1.0.20              894.0GB     0  20 SSD     shared      aggr_c190_n01_01, aggr_c190_n02_01, aggr_root_c190_n01
                                                                    c190_n01
1.0.21              894.0GB     0  21 SSD     shared      aggr_c190_n01_01, aggr_c190_n02_01, aggr_root_c190_n01
                                                                    c190_n01
1.0.22              894.0GB     0  22 SSD     shared      aggr_c190_n01_01, aggr_c190_n02_01, aggr_root_c190_n01
                                                                    c190_n01
1.0.23              894.0GB     0  23 SSD     shared      -         c190_n01
18 entries were displayed.
```
### Borrar agregado fantasma de discos anteriores
```
c190::*> storage aggregate remove-stale-record -nodename c190_n01 -aggregate aggr0

c190::*> storage aggregate remove-stale-record -nodename c190_n02 -aggregate aggr0
```
### Remover las particiones
```
c190::*> disk unpartition -disk 1.0.6
Warning: Partitions will be removed from disk "1.0.6".
Do you want to continue? {y|n}: y

Partitions are removed from disk "1.0.6".

c190::*> disk unpartition -diskl
c190::*> disk unpartition -disk 1.0.7

Warning: Partitions will be removed from disk "1.0.7".
Do you want to continue? {y|n}: y

Partitions are removed from disk "1.0.7".

c190::*> disk unpartition -disk 1.0.8

Warning: Partitions will be removed from disk "1.0.8".
Do you want to continue? {y|n}: y

Partitions are removed from disk "1.0.8".

c190::*> disk unpartition -disk 1.0.15

Warning: Partitions will be removed from disk "1.0.15".
Do you want to continue? {y|n}: y

Partitions are removed from disk "1.0.15".

c190::*> disk unpartition -disk 1.0.16

Warning: Partitions will be removed from disk "1.0.16".
Do you want to continue? {y|n}: y

Partitions are removed from disk "1.0.16".

c190::*> disk unpartition -disk 1.0.17

Warning: Partitions will be removed from disk "1.0.17".
Do you want to continue? {y|n}: y

Partitions are removed from disk "1.0.17".
```
###Agregar discos
Agregar discos a los agregados (Hay que hacerlo a todos los nodos y agregados correspondientes, tomar nota de como estan dispuestos en los otros discos)
```
c190::*> aggr add-disks -aggregate aggr_c190_n01_01 -disklist 1.0.15, 1.0.16, 1.0.17

Info: Disks would be added to aggregate "aggr_c190_n01_01" on node "c190_n01" in the following manner:

      First Plex

        RAID Group rg0, 3 disks (block checksum, raid_dp)
                                                            Usable Physical
          Position   Disk                      Type           Size     Size
          ---------- ------------------------- ---------- -------- --------
          shared     1.0.15                    SSD         415.8GB  415.8GB
          shared     1.0.16                    SSD         415.8GB  415.8GB
          shared     1.0.17                    SSD         415.8GB  415.8GB

      Aggregate capacity available for volume use would be increased by 1.10TB.

      The following disks would be partitioned: 1.0.15, 1.0.16, 1.0.17.

Do you want to continue? {y|n}: y

c190::*> aggr add-disks -aggregate aggr_c190_n02_01  -disklist 1.0.6, 1.0.7, 1.0.8

Info: Disks would be added to aggregate "aggr_c190_n02_01" on node "c190_n02" in the following manner:

      First Plex

        RAID Group rg0, 3 disks (block checksum, raid_dp)
                                                            Usable Physical
          Position   Disk                      Type           Size     Size
          ---------- ------------------------- ---------- -------- --------
          shared     1.0.6                     SSD         415.8GB  415.8GB
          shared     1.0.7                     SSD         415.8GB  415.8GB
          shared     1.0.8                     SSD         415.8GB  415.8GB

      Aggregate capacity available for volume use would be increased by 1.10TB.

      The following disks would be partitioned: 1.0.6, 1.0.7, 1.0.8.

Do you want to continue? {y|n}: y
```
***Este ultimo paso tiene pendiente agregarlo al agregado de root porque los discos tienen 3 particiones***


