%let pgm=utl-examine-whether-group-members-make-the-same-choices-sas-r-sql-sas--r-python-mukti-language;

Examine whether group members make the same choices sas r sql sas  r python mukti-language

github
https://tinyurl.com/4zdb8s2t
https://github.com/rogerjdeangelis/utl-examine-whether-group-members-make-the-same-choices-sas-r-sql-sas--r-python-mukti-language

stackoverflow
https://tinyurl.com/2rnfmu74
https://stackoverflow.com/questions/79237368/examine-whether-group-members-make-the-same-choices

         SOLUTIONS

           1 sas sql (self expanatory?)
           2 sas sort nouniquekey and uniquekey options
           3 base r some what obsure?
           4 r sql (little longer than sas because sqllite does not do automatic remerging)
           5 pyhton sql

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                        |                                                |                                              */
/*      INPUT             |        PROCESSES                               |               OUTPUT                         */
/*                        |                                                |                                              */
/*                        |                                                |                                              */
/* ID  GROUPS  CHOICE     |   DATA SORTED FOR                              |       ID    GROUPS    CHOICE    DUP          */
/*                        |   DOCUMENTATION ONLY                           |                                              */
/*  1     0       1.5     |                                                |        1       0         1.5     1           */
/*  2     0       1.5     |   ID    GROUPS    CHOICE                       |        2       0         1.5     1           */
/*  5     2      -0.2     |                           -                    |        3       0         1.5     1           */
/*  6     2      12.9     |    1       0         1.5 |                     |        5       2        -0.2     0           */
/* 11     4       2.0     |    2       0         1.5 | SAME                |        4       2         9.7     0           */
/*  7     3      23.7     |    3       0         1.5 | CHOICES             |        6       2        12.9     0           */
/*  3     0       1.5     |                           -                    |        8       3         2.3     0           */
/*  8     3       2.3     |                           -                    |        9       3        12.5     0           */
/*  9     3      12.5     |    5       2        -0.2 |                     |        7       3        23.7     0           */
/* 10     4       7.5     |    4       2         9.7 | ALL                 |       11       4         2.0     0           */
/*  4     2       9.7     |    6       2        12.9 | UNIQUE              |       10       4         7.5     0           */
/* 12     4      14.0     |    8       3         2.3 |                     |       12       4        14.0     0           */
/*                        |    9       3        12.5 |                     |                                              */
/*                        |    7       3        23.7 |                     |                                              */
/*                        |   11       4         2.0 |                     |                                              */
/*                        |   10       4         7.5 |                     |                                              */
/*                        |   12       4        14.0 |                     |                                              */
/*                        |                           -                    |                                              */
/*                        |------------------------------------------------|                                              */
/*                        |                                                |                                              */
/*                        |   1 SAS SQL SOLUTION                           |                                              */
/*                        |     SELF EXPANATORY                            |                                              */
/*                        |   =================                            |                                              */
/*                        |                                                |                                              */
/*                        |   FIRST WE GET ALL DUPGROUPS                   |                                              */
/*                        |   (SAME GROUP AND CHOICE)                      |                                              */
/*                        |                                                |                                              */
/*                        |   select                                       |                                              */
/*                        |      *                                         |                                              */
/*                        |     ,1 as dupgroups                            |                                              */
/*                        |   from                                         |                                              */
/*                        |      sd1.have                                  |                                              */
/*                        |   group                                        |                                              */
/*                        |      by groups, choice                         |                                              */
/*                        |   having                                       |                                              */
/*                        |      count(*) > 1                              |                                              */
/*                        |                                                |                                              */
/*                        |   THEN WE UNION WITH UNIQUES                   |                                              */
/*                        |                                                |                                              */
/*                        |   union                                        |                                              */
/*                        |      all                                       |                                              */
/*                        |   select                                       |                                              */
/*                        |      *                                         |                                              */
/*                        |     ,0 as dupgroups                            |                                              */
/*                        |   from                                         |                                              */
/*                        |      sd1.have                                  |                                              */
/*                        |   group                                        |                                              */
/*                        |      by groups, choice                         |                                              */
/*                        |   having                                       |                                              */
/*                        |     count(*) = 1                               |                                              */
/*                        |                                                |                                              */
/*                        |------------------------------------------------|                                              */
/*                        |                                                |                                              */
/*                        |   2 SAS SORT                                   |                                              */
/*                        |   ==========                                   |                                              */
/*                        |                                                |                                              */
/*                        |   /*--- APPEND UNIQUES TO DUPS ---*/           |                                              */
/*                        |                                                |                                              */
/*                        |   data havview/view=havview;                   |                                              */
/*                        |     set havdup(in=dups)                        |                                              */
/*                        |         havunq;                                |                                              */
/*                        |     if dups then dugroup =1;                   |                                              */
/*                        |     else dupgroup=0                            |                                              */
/*                        |   run;quit;                                    |                                              */
/*                        |                                                |                                              */
/*                        |   proc datasets lib=sd1 nolist nodetails;      |                                              */
/*                        |    delete rwant;                               |                                              */
/*                        |   run;quit;                                    |                                              */
/*                        |                                                |                                              */
/*                        |------------------------------------------------|                                              */
/*                        |                                                |                                              */
/*                        |  3 BASE R SOLUTION (SOMEWHAT OBSCURE?)         |                                              */
/*                        |  =====================================         |                                              */
/*                        |                                                |                                              */
/*                        |  want<-transform(have,                         |                                              */
/*                        |    Symmetric = as.integer(                     |                                              */
/*                        |      ave(CHOICE, GROUPS                        |                                              */
/*                        |      ,FUN = \(x) length(unique(x)) == 1)))     |                                              */
/*                        |  want<-want[order(want$GROUPS,want$CHOICE),]   |                                              */
/*                        |                                                |                                              */
/*                        |------------------------------------------------|                                              */
/*                        |                                                |                                              */
/*                        |  3 R AND PYTHON SQL                            |                                              */
/*                        |  ==================                            |                                              */
/*                        |                                                |                                              */
/*                        |  with                                          |                                              */
/*                        |      dups                                      |                                              */
/*                        |  as  (                                         |                                              */
/*                        |  select                                        |                                              */
/*                        |     *                                          |                                              */
/*                        |    ,count(*) as dupgroups                      |                                              */
/*                        |  from                                          |                                              */
/*                        |     have                                       |                                              */
/*                        |  group                                         |                                              */
/*                        |     by groups, choice                          |                                              */
/*                        |  having                                        |                                              */
/*                        |     count(*) > 1 )                             |                                              */
/*                        |  select                                        |                                              */
/*                        |     l.*                                        |                                              */
/*                        |    ,coalesce(r.dupgroups,0) as dupgroups       |                                              */
/*                        |  from                                          |                                              */
/*                        |     have as l left join dups as r              |                                              */
/*                        |  on                                            |                                              */
/*                        |         l.groups = r.groups                    |                                              */
/*                        |     and l.choice = r.choice                    |                                              */
/*                        |  order                                         |                                              */
/*                        |    by  l.groups, l.choice                      |                                              */
/*                        |                                                |                                              */
/*                        |------------------------------------------------|                                              */
/*                        |                                                |                                              */
/*                        |                                                |                                              */
/*                        |  4 R SQL and 5 Pyhon SQL                       |                                              */
/*                        |  =======================                       |                                              */
/*                        |                                                |                                              */
/*                        |  with                                          |                                              */
/*                        |      dups                                      |                                              */
/*                        |  as  (                                         |                                              */
/*                        |  select                                        |                                              */
/*                        |     *                                          |                                              */
/*                        |    ,count(*) as dupgroups                      |                                              */
/*                        |  from                                          |                                              */
/*                        |     have                                       |                                              */
/*                        |  group                                         |                                              */
/*                        |     by groups, choice                          |                                              */
/*                        |  having                                        |                                              */
/*                        |     count(*) > 1 )                             |                                              */
/*                        |  select                                        |                                              */
/*                        |     l.*                                        |                                              */
/*                        |    ,coalesce(r.dupgroups,0) as dupgroups       |                                              */
/*                        |  from                                          |                                              */
/*                        |     have as l left join dups as r              |                                              */
/*                        |  on                                            |                                              */
/*                        |         l.groups = r.groups                    |                                              */
/*                        |     and l.choice = r.choice                    |                                              */
/*                        |  order                                         |                                              */
/*                        |    by  l.groups, l.choice                      |                                              */
/*                        |                                                |                                              */
/**************************************************************************************************************************/


/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options
  validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input ID Groups Choice;
cards4;
 1  0  1.5
 2  0  1.5
 5  2 -0.2
 6  2 12.9
11  4  2.0
 7  3 23.7
 3  0  1.5
 8  3  2.3
 9  3 12.5
10  4  7.5
 4  2  9.7
12  4 14.0
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  Obs    ID    GROUPS    CHOICE                                                                                         */
/*                                                                                                                        */
/*    1     1       0         1.5                                                                                         */
/*    2     2       0         1.5                                                                                         */
/*    3     5       2        -0.2                                                                                         */
/*    4     6       2        12.9                                                                                         */
/*    5    11       4         2.0                                                                                         */
/*    6     7       3        23.7                                                                                         */
/*    7     3       0         1.5                                                                                         */
/*    8     8       3         2.3                                                                                         */
/*    9     9       3        12.5                                                                                         */
/*   10    10       4         7.5                                                                                         */
/*   11     4       2         9.7                                                                                         */
/*   12    12       4        14.0                                                                                         */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                             _
/ |  ___  __ _ ___   ___  __ _| |
| | / __|/ _` / __| / __|/ _` | |
| | \__ \ (_| \__ \ \__ \ (_| | |
|_| |___/\__,_|___/ |___/\__, |_|
                            |_|
*/
proc sql;
  create
     table want as
  select
     *
    ,1 as dupgroups
  from
     sd1.have
  group
     by groups, choice
  having
     count(*) > 1
  union
     all
  select
     *
    ,0 as dupgroups
  from
     sd1.have
  group
     by groups, choice
  having
    count(*) = 1
;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*                                                                                                                        */
/*   ID    GROUPS    CHOICE    DUPGROUPS                                                                                  */
/*                                                                                                                        */
/*    3       0         1.5        1                                                                                      */
/*    2       0         1.5        1                                                                                      */
/*    1       0         1.5        1                                                                                      */
/*    5       2        -0.2        0                                                                                      */
/*    4       2         9.7        0                                                                                      */
/*    6       2        12.9        0                                                                                      */
/*    8       3         2.3        0                                                                                      */
/*    9       3        12.5        0                                                                                      */
/*    7       3        23.7        0                                                                                      */
/*   11       4         2.0        0                                                                                      */
/*   10       4         7.5        0                                                                                      */
/*   12       4        14.0        0                                                                                      */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                                   _
|___ \   ___  __ _ ___   ___  ___  _ __| |_
  __) | / __|/ _` / __| / __|/ _ \| `__| __|
 / __/  \__ \ (_| \__ \ \__ \ (_) | |  | |_
|_____| |___/\__,_|___/ |___/\___/|_|   \__|

*/

proc sort data=sd1.have
          out=havdup nouniquekey
          uniqueout=havUnq ;
by groups choice;
run;quit;

/*--- append uniques to dups ---*/
data havview/view=havview;
  set havdup(in=dups)
      havunq;
  if dups then dugroup =1;
  else dupgroup=0
run;quit;

proc datasets lib=sd1 nolist nodetails;
 delete rwant;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  Obs    ID    GROUPS    CHOICE    DUP                                                                                  */
/*                                                                                                                        */
/*    1     1       0         1.5     1                                                                                   */
/*    2     2       0         1.5     1                                                                                   */
/*    3     3       0         1.5     1                                                                                   */
/*    4     5       2        -0.2     0                                                                                   */
/*    5     4       2         9.7     0                                                                                   */
/*    6     6       2        12.9     0                                                                                   */
/*    7     8       3         2.3     0                                                                                   */
/*    8     9       3        12.5     0                                                                                   */
/*    9     7       3        23.7     0                                                                                   */
/*   10    11       4         2.0     0                                                                                   */
/*   11    10       4         7.5     0                                                                                   */
/*   12    12       4        14.0     0                                                                                   */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____   _
|___ /  | |__   __ _ ___  ___   _ __
  |_ \  | `_ \ / _` / __|/ _ \ | `__|
 ___) | | |_) | (_| \__ \  __/ | |
|____/  |_.__/ \__,_|___/\___| |_|

*/

%utl_rbeginx;
parmcards4;
library(haven)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
want<-transform(have,
  Symmetric = as.integer(
    ave(CHOICE, GROUPS
    ,FUN = \(x) length(unique(x)) == 1)))
want<-want[order(want$GROUPS,want$CHOICE),]
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="rwant"
     )
;;;;
%utl_rendx;

proc print data=sd1.rwant;
run;quit;

/**************************************************************************************************************************/
/*                                    |                                                                                   */
/*  R                                 |     SAS                                                                           */
/*                                    |                                                                                   */
/*     ID GROUPS CHOICE Symmetric     |     ROWNAMES    ID    GROUPS    CHOICE    SYMMETRIC                               */
/*                                    |                                                                                   */
/*  1   1      0    1.5         1     |         1        1       0         1.5        1                                   */
/*  2   2      0    1.5         1     |         2        2       0         1.5        1                                   */
/*  7   3      0    1.5         1     |         7        3       0         1.5        1                                   */
/*  3   5      2   -0.2         0     |         3        5       2        -0.2        0                                   */
/*  11  4      2    9.7         0     |        11        4       2         9.7        0                                   */
/*  4   6      2   12.9         0     |         4        6       2        12.9        0                                   */
/*  8   8      3    2.3         0     |         8        8       3         2.3        0                                   */
/*  9   9      3   12.5         0     |         9        9       3        12.5        0                                   */
/*  6   7      3   23.7         0     |         6        7       3        23.7        0                                   */
/*  5  11      4    2.0         0     |         5       11       4         2.0        0                                   */
/*  10 10      4    7.5         0     |        10       10       4         7.5        0                                   */
/*  12 12      4   14.0         0     |        12       12       4        14.0        0                                   */
/*                                    |                                                                                   */
/**************************************************************************************************************************/

/*  _                      _
| || |    _ __   ___  __ _| |
| || |_  | `__| / __|/ _` | |
|__   _| | |    \__ \ (_| | |
   |_|   |_|    |___/\__, |_|
                        |_|
*/

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
have
want<-sqldf('
  with
      dups
  as  (
  select
     *
    ,count(*) as dupgroups
  from
     have
  group
     by groups, choice
  having
     count(*) > 1 )
  select
     l.*
    ,coalesce(r.dupgroups,0) as dupgroups
  from
     have as l left join dups as r
  on
         l.groups = r.groups
     and l.choice = r.choice
  order
    by  l.groups, l.choice
 ')
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="rrwant"
     )
;;;;
%utl_rendx;

proc print data=sd1.rrwant;
run;quit;

/***************************************************************************************************************************/
/*                                  |                                                                                      */
/*  R                               |   SAS                                                                                */
/*                                  |                                                                                      */
/*     ID GROUPS CHOICE dupgroups   |   ROWNAMES    ID    GROUPS    CHOICE    DUPGROUPS                                    */
/*                                  |                                                                                      */
/*  1   1      0    1.5         3   |       1        1       0         1.5        3                                        */
/*  2   2      0    1.5         3   |       2        2       0         1.5        3                                        */
/*  3   3      0    1.5         3   |       3        3       0         1.5        3                                        */
/*  4   5      2   -0.2         0   |       4        5       2        -0.2        0                                        */
/*  5   4      2    9.7         0   |       5        4       2         9.7        0                                        */
/*  6   6      2   12.9         0   |       6        6       2        12.9        0                                        */
/*  7   8      3    2.3         0   |       7        8       3         2.3        0                                        */
/*  8   9      3   12.5         0   |       8        9       3        12.5        0                                        */
/*  9   7      3   23.7         0   |       9        7       3        23.7        0                                        */
/*  10 11      4    2.0         0   |      10       11       4         2.0        0                                        */
/*  11 10      4    7.5         0   |      11       10       4         7.5        0                                        */
/*  12 12      4   14.0         0   |      12       12       4        14.0        0                                        */
/*                                  |                                                                                      */
/***************************************************************************************************************************/

/*  _                 _   _                             _
| || |    _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
| || |_  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
|__   _| | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
   |_|   | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
         |_|    |___/                                |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read());
have,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat');
want=pdsql('''
  with                                     \
      dups                                 \
  as  (                                    \
  select                                   \
     *                                     \
    ,count(*) as dupgroups                 \
  from                                     \
     have                                  \
  group                                    \
     by groups, choice                     \
  having                                   \
     count(*) > 1 )                        \
  select                                   \
     l.*                                   \
    ,coalesce(r.dupgroups,0) as dupgroups  \
  from                                     \
     have as l left join dups as r         \
  on                                       \
         l.groups = r.groups               \
     and l.choice = r.choice               \
  order                                    \
    by  l.groups, l.choice                 \
 ''')
print(want);
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
;;;;
%utl_pyendx;

proc print data=sd1.pywant;
run;quit;

/**************************************************************************************************************************/
/*                                       |                                                                                */
/*  R                                    |   SAS                                                                          */
/*                                       |                                                                                */
/*        ID  GROUPS  CHOICE  dupgroups  |   ID    GROUPS    CHOICE    DUPGROUPS                                          */
/*                                       |                                                                                */
/*  0    1.0     0.0     1.5          3  |    1       0         1.5        3                                              */
/*  1    2.0     0.0     1.5          3  |    2       0         1.5        3                                              */
/*  2    3.0     0.0     1.5          3  |    3       0         1.5        3                                              */
/*  3    5.0     2.0    -0.2          0  |    5       2        -0.2        0                                              */
/*  4    4.0     2.0     9.7          0  |    4       2         9.7        0                                              */
/*  5    6.0     2.0    12.9          0  |    6       2        12.9        0                                              */
/*  6    8.0     3.0     2.3          0  |    8       3         2.3        0                                              */
/*  7    9.0     3.0    12.5          0  |    9       3        12.5        0                                              */
/*  8    7.0     3.0    23.7          0  |    7       3        23.7        0                                              */
/*  9   11.0     4.0     2.0          0  |   11       4         2.0        0                                              */
/*  10  10.0     4.0     7.5          0  |   10       4         7.5        0                                              */
/*  11  12.0     4.0    14.0          0  |   12       4        14.0        0                                              */
/*                                       |                                                                                */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
