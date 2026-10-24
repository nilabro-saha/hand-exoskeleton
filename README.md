# Hand exoskeleton kinematics

MATLAB and Python analysis of a five-digit, six-actuator, linkage-driven hand exoskeleton for master-slave grasping and force feedback. The work was done as a B.Tech. project at NIT Durgapur with CSIR-CMERI, February–May 2022.

Each non-thumb finger is a planar closed chain of 16 links and 3 mechanism degrees of freedom, driven by one actuator. The thumb uses two actuators. Forward kinematics use circle-circle intersection for the fingers and circle-sphere intersection for the thumb. Link lengths were adjusted so the modeled MCP flexion reaches 110° without the singularity that stopped the original linkage. Inverse kinematics for the four fingers come from monotonic actuator-to-pose curves. The thumb inverse map is a 500 by 500 numerical table.

Advisors: Prof. Shibendu Shekhar Roy (NIT Durgapur) and Dr. Abhijit Mahapatra (CSIR-CMERI).

The written thesis is on Zenodo: [doi:10.5281/zenodo.22812016](https://doi.org/10.5281/zenodo.22812016).

## Results carried in this repository

- Modeled MCP flexion extended to 110°.
- Circular-grasp target of 45° PIP flexion, with actuator travel of about 23.0–27.6 mm across the four fingers.
- Thumb flexion extended to 50°, with actuator travel of about 23–24 mm.
- MATLAB and MSC Adams index-finger kinematics agree closely. The Adams run also shows a linkage collision near 60° of index MCP flexion.

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
