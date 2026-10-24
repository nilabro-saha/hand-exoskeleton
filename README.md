# Hand exoskeleton kinematics

MATLAB and Python analysis of a five-digit, six-actuator, linkage-driven hand exoskeleton for master-slave grasping and force feedback. The work was done as a B.Tech. project at NIT Durgapur with CSIR-CMERI, February–May 2022.

Each non-thumb finger is a planar closed chain of 16 links and 3 mechanism degrees of freedom, driven by one actuator. The thumb uses two actuators. Forward kinematics use circle-circle intersection for the fingers and circle-sphere intersection for the thumb. Link lengths were adjusted so the modeled MCP flexion reaches 110° without the singularity that stopped the original linkage. Inverse kinematics for the four fingers come from monotonic actuator-to-pose curves. The thumb inverse map is a 500 by 500 numerical table.

Advisors: Prof. Shibendu Shekhar Roy (NIT Durgapur) and Dr. Abhijit Mahapatra (CSIR-CMERI).

The written thesis is on Zenodo: [doi:10.5281/zenodo.22812016](https://doi.org/10.5281/zenodo.22812016).

![Frontal render of the hand assembly](figures/assembly-frontal.jpg)

Frontal SolidWorks render of the assembly. The thumb mechanism is on the right. The finger linkages sit on the dorsal shell.

![Dorsal render of the finger linkages](figures/assembly-sagittal.jpg)

Dorsal render of the same assembly. The arched links over the fingers are the four planar mechanisms.

![Close-up of one finger linkage](figures/finger-linkage-closeup.png)

Close-up of one finger linkage on the dorsal shell.

## Linkage

![Kinematic diagram of one finger](figures/linkage-diagram.png)

Kinematic diagram of one finger. The labels match the loop-closure scripts in `kinematics/`.

![Index finger at the start of travel](figures/index-pose-initial.png)

![Index finger at the end of travel](figures/index-pose-final.png)

Index finger from the forward-kinematics study, at the start of travel and at the end. The dotted curve is the fingertip path.

![Open and closed poses from the linkage script](figures/index-linkage-motion.png)

Open pose and closed pose from `kinematics/linkage_kinematics.m`, with the fingertip path. In that script the finger command runs from 0° to −107°.

## Range

![Index deflections before length optimization](figures/index-deflection-before.png)

![Index deflections after length optimization](figures/index-deflection-after.png)

Index-finger joint travel against actuator displacement, before and after the link-length change recorded in `data/length_optimization.xlsx`. After the change, MCP flexion passes 110° and PIP flexion passes the 45° grasp target.

![Index joint angles over the simulation](figures/index-joint-angles.png)

Joint angles over 100 steps of the index-finger simulation.

![Joint deflection of three fingers after the length change](figures/finger-deflection-after.png)

The same joint deflections for the index, middle, and little fingers, taken from the results sheets in `data/linkage_model_data.xlsx`. The dashed line is 45°. On these curves, θ₁ reaches 45° at 23.8 mm, 20.3 mm, and 25.3 mm of actuator displacement. The workbook has no ring-finger results sheet.

## Full hand

![Hand linkage, initial pose](figures/hand-pose-initial.png)

![Hand linkage, closed pose](figures/hand-pose-final.png)

All five digits from `hand/hand_simulation.mlx`, open and closed.

![Thumb workspace](figures/thumb-workspace.png)

Thumb linkage and the fingertip workspace from the thumb forward-kinematics study.

![Thumb inverse map](figures/thumb-inverse-theta1.png)

Thumb inverse map θ₁(θ₀, θ₀\*), drawn from `data/theta1-inverse-mapping-500x500.xlsx`. The axes are the query ranges in `fingers/thumb/thumb_analysis.m`.

## Two-link dynamics

![Angular position of the two-link model](figures/two-link-angular-position.png)

Angular position of the planar two-link model in `dynamics/`.

## Results carried in this repository

- Modeled MCP flexion extended to 110°.
- Circular-grasp target of 45° PIP flexion, with actuator travel of about 23.0–27.6 mm across the four fingers.
- Thumb flexion extended to 50°, with actuator travel of about 23–24 mm.
- MATLAB and MSC Adams index-finger kinematics agree closely. The Adams run also shows a linkage collision near 60° of index MCP flexion.

![Adams and MATLAB finger angle change](figures/adams-vs-matlab.png)

Finger angle change from `data/adams-vs-matlab.xlsx`. The largest absolute difference is 6.6° for the index, 5.3° for the middle, 0.7° for the ring, and 19.2° for the little finger.

## Layout

| Path | Contents |
| --- | --- |
| `kinematics/` | Finger loop-closure position and inverse-kinematics scripts |
| `dynamics/` | Symbolic two-link planar dynamics in MATLAB and Python, plus a short animation |
| `fingers/` | Per-digit forward-kinematics live scripts and the thumb analysis |
| `hand/` | Full-hand simulation driven by six actuator inputs |
| `data/` | Link-length optimization, Adams comparison, and the thumb inverse-mapping tables |
| `geometry/` | FreeCAD sketches of the four fingers and the linkage model |
| `results/` | Adams result channels for the hand (`hand.res` and the accompanying request files) |

`fingers/thumb/thumb_analysis.m` and `thumb_simulation.m` read the spreadsheets in `data/`.

The scripts were written for MATLAB with the Symbolic Math Toolbox, and for Python with SymPy, NumPy, and Matplotlib. The `.mlx` files are MATLAB live scripts.

## Models

Adams binaries and CAD solids are attached to the `models-v1` release. They are not in the git history. Clone this repository for the code, then download the release assets below.

| Release asset | What it is |
| --- | --- |
| `adams-verification-model1.bin` | Adams model compared with `data/adams-vs-matlab.xlsx` |
| `adams-hand-v3.bin` | Later Adams model of the hand |
| `adams-index-finger.bin` | Index-finger Adams model used for the kinematic check |
| `hand-v8-adams.stp` | STEP of the verified assembly |
| `hand-model.stp` | Full solid export of the hand |
| `hand-model-v3.SLDASM` | SolidWorks assembly |
| `thumb-model.FCStd` | Thumb model in FreeCAD |

## License

MIT. See [LICENSE](LICENSE).
