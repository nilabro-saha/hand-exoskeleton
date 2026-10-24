
-------------------------------------------------------------------------------
|        ..          ..                                                       |
|       ####*.      ####.                                                     |
|         `###*.       `#.              MSC Software                          |
|            `###.       #.             ------------                          |
|               `##.     ##                                                   |
|                 `##.   ##                                                   |
|                   `## ##'             A d a m s   C++   S o l v e r         |
|                     ####              Build:   2020.0.0-CL711253            |
|                     ###.              Version: Adams 2020                   |
|                    ###`#.                                                   |
|                  .###  `#                                                   |
|                 ####    `#                                                  |
|                ####      #.                                                 |
|              #####       `#           http://www.mscsoftware.com            |
|            .#####                                                           |
|           #####'                                                            |
|           ####                                                              |
|                                                                             |
|    *********************************************************************    |
|    *                                                                   *    |
|    *                      MSC Software Corporation                     *    |
|    *                                                                   *    |
|    *                             A d a m s                             *    |
|    *                                                                   *    |
|    *          Automatic Dynamic Analysis of Mechanical Systems         *    |
|    *                                                                   *    |
|    *********************************************************************    |
|    *                                                                   *    |
|    *                         LEGAL INFORMATION                         *    |
|    *                                                                   *    |
|    *  Warning:  This computer  program is protected  by copyright law  *    |
|    *  and  international  treaties.    Unauthorized  reproduction  or  *    |
|    *  distribution  of this  computer program, or any  portion of it,  *    |
|    *  may result in severe civil and criminal penalties.               *    |
|    *                                                                   *    |
|    *  Copyright (C) 2020 MSC Software Corporation and  its licensors.  *    |
|    *                        All rights reserved.                       *    |
|    *                                                                   *    |
|    *********************************************************************    |
|                                                                             |
|-----------------------------------------------------------------------------|
|                                                                             |
|    *********************************************************************    |
|    *                                                                   *    |
|    *   Local Time: 2022-03-14 18:19:19                                 *    |
|    *    Host Name:                                      *    |
|    *        Uname: MS Windows NT                                       *    |
|    *      OS Info: 6.2                                                 *    |
|    *         User: nilab                                               *    |
|    *  Customer ID: C316EE13-413F4BA1                                   *    |
|    *  Current dir: .     *    |
|    *   Process ID: 10472                                               *    |
|    *                                                                   *    |
|    *********************************************************************    |
|                                                                             |
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
|                                 Model Title                                 |
|=============================================================================|
|                                                                             |
|                        ADAMS/View model name: model1                        |
|                                                                             |
-------------------------------------------------------------------------------



  Begin Simulation

  ****** Performing Dynamic Simulation using Gstiff I3 Integrator ******
  Time T=0.000000000E+00.
  Degree-of-freedom analysis identified redundant constraints in the model:
  -------------------------------------------------------------------------
   -  deactivating constraint equation  Zi.Xj in model1.Joint_155
   -  deactivating constraint equation  Zi.Xj in model1.Joint_107
   -  deactivating constraint equation  Zi.Yj in model1.Joint_170
   -  deactivating constraint equation  Zi.Xj in model1.Joint_169
   -  deactivating constraint equation  Zi.Yj in model1.Joint_168
   -  deactivating constraint equation  Zi.Yj in model1.Joint_167
   -  deactivating constraint equation  Zi.Xj in model1.Joint_167
   -  deactivating constraint equation  Zi.Xj in model1.Joint_166
   -  deactivating constraint equation  Zi.Xj in model1.Joint_164
   -  deactivating constraint equation  Zi.Yj in model1.Joint_161
   -  deactivating constraint equation  Zi.Xj in model1.Joint_159
   -  deactivating constraint equation  Zi.Yj in model1.Joint_158
   -  deactivating constraint equation  Zi.Yj in model1.Joint_157
   -  deactivating constraint equation  Zi.Xj in model1.Joint_157
   -  deactivating constraint equation  Zi.Xj in model1.Joint_153
   -  deactivating constraint equation  Zi.Yj in model1.Joint_152
   -  deactivating constraint equation  Zi.Xj in model1.Joint_149
   -  deactivating constraint equation  Zi.Xj in model1.Joint_148
   The system is modelled with INDEX-3 DAEs.
   The integrator is GSTIFF, CORRECTOR = original
   Integration error =    1.000000E-03

   Simulation      Step        Function    Cumulative   Integration     CPU
      Time         Size       Evaluations  Steps Taken    Order        time
   ___________  ___________   ___________  ___________   _________    ________
   0.00000E+00  1.00000E-04            0            0       1            0.39 
   5.00000E-01  1.00000E-02          188           74       4            0.88 
   1.00000E+00  1.00000E-02          258          124       4            1.16 
   1.50000E+00  1.00000E-02          308          174       4            1.44 
   2.00000E+00  1.00000E-02          358          224       4            1.73 
   2.50000E+00  1.00000E-02          408          274       4            2.03 
   3.00000E+00  1.00000E-02          458          324       4            2.34 
   3.50000E+00  1.00000E-02          508          374       4            2.62 
   4.00000E+00  1.00000E-02          558          424       4            2.94 
   4.50000E+00  1.00000E-02          608          474       4            3.23 
   5.00000E+00  1.00000E-02          658          524       4            3.55 

  End Simulation


Finished -----
Elapsed time = 1480.94s,  CPU time = 6.05s,  0.41%

