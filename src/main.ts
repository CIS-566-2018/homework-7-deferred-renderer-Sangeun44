import {vec3} from 'gl-matrix';
import * as Stats from 'stats-js';
import * as DAT from 'dat-gui';
import Square from './geometry/Square';
import Mesh from './geometry/Mesh';
import OpenGLRenderer from './rendering/gl/OpenGLRenderer';
import Camera from './Camera';
import {setGL} from './globals';
import {readTextFile} from './globals';
import ShaderProgram, {Shader} from './rendering/gl/ShaderProgram';
import Texture from './rendering/gl/Texture';
import Icosphere from './geometry/Icosphere';

// Define an object with application parameters and button callbacks
// const controls = {
//   // Extra credit: Add interactivity
// };

let square: Square;

// TODO: replace with your scene's stuff

let obj0: string;
let obj1: string;

let mesh0: Mesh;
let mesh1: Mesh;

let tex0: Texture;
let tex1: Texture;

let processes = [0,0,0];

const controls = {
  'DOF': false,
  'Bloom': true,
  'Hatching': false,
};

var timer = {
  deltaTime: 0.0,
  startTime: 0.0,
  currentTime: 0.0,
  updateTime: function() {
    var t = Date.now();
    t = (t - timer.startTime) * 0.001;
    timer.deltaTime = t - timer.currentTime;
    timer.currentTime = t;
  },
}

function loadOBJText() {
  obj0 = readTextFile('../resources/obj/wahoo.obj')
  obj1 = readTextFile('../resources/obj/flowey.obj')
}

function loadScene() {
  square && square.destroy();
  mesh0 && mesh0.destroy();
  mesh1 && mesh1.destroy();

  square = new Square(vec3.fromValues(0, 0, 0));
  square.create();

  mesh0 = new Mesh(obj0, vec3.fromValues(0, 0, 0));
  mesh1 = new Mesh(obj1, vec3.fromValues(0, 0, 0));

  mesh0.create();
  mesh1.create();

  tex0 = new Texture('../resources/textures/wahoo.bmp')
  tex1 = new Texture('../resources/textures/flowey.png')
}

function main() {
  
  //GUI
  const gui = new DAT.GUI();
  var dof = gui.addFolder('depthOfField');
  var DOFOn = dof.add(controls, 'DOF');
  var hatching = gui.addFolder('Hatching');
  var hatchOn = hatching.add(controls, 'Hatching')
  var bloom = gui.addFolder('Bloom');
  var bloomOn = bloom.add(controls, 'Bloom');


  // Initial display for framerate
  const stats = Stats();
  stats.setMode(0);
  stats.domElement.style.position = 'absolute';
  stats.domElement.style.left = '0px';
  stats.domElement.style.top = '0px';
  document.body.appendChild(stats.domElement);

  // Add controls to the gui
  // const gui = new DAT.GUI();

  // get canvas and webgl context
  const canvas = <HTMLCanvasElement> document.getElementById('canvas');
  const gl = <WebGL2RenderingContext> canvas.getContext('webgl2');
  if (!gl) {
    alert('WebGL 2 not supported!');
  }
  // `setGL` is a function imported above which sets the value of `gl` in the `globals.ts` module.
  // Later, we can import `gl` from `globals.ts` to access it
  setGL(gl);

  // Initial call to load scene
  loadScene();

  const camera = new Camera(vec3.fromValues(0, 9, 25), vec3.fromValues(0, 9, 0));

  const renderer = new OpenGLRenderer(canvas);
  renderer.addProcesses(processes);

  renderer.setClearColor(0, 0, 0, 1);
  gl.enable(gl.DEPTH_TEST);

  const standardDeferred = new ShaderProgram([
    new Shader(gl.VERTEX_SHADER, require('./shaders/standard-vert.glsl')),
    new Shader(gl.FRAGMENT_SHADER, require('./shaders/standard-frag.glsl')),
    ]);

  standardDeferred.setupTexUnits(["tex_Color"]);

  function tick() {
    DOFOn.onChange(function() {
      if(controls.DOF.valueOf() == true) {
        processes[0] = 1;
      } else {
        processes[0] = 0;
      }
    });

    hatchOn.onChange(function() {
      if(controls.Hatching.valueOf() == true) {
        processes[1] = 1;
      } else {
        processes[1] = 0;
      }
    });

    bloomOn.onChange(function() {
      if(controls.Bloom.valueOf() == true) {
        processes[2] = 1;
      } else {
        processes[2] = 0;
      }
    });
    renderer.addProcesses(processes);

    camera.update();
    stats.begin();
    gl.viewport(0, 0, window.innerWidth, window.innerHeight);
    timer.updateTime();
    renderer.updateTime(timer.deltaTime, timer.currentTime);

    standardDeferred.bindTexToUnit("tex_Color", tex0, 0);

    renderer.clear();
    renderer.clearGB();

    // TODO: pass any arguments you may need for shader passes
    // forward render mesh info into gbuffers
    renderer.renderToGBuffer(camera, standardDeferred, [mesh0]);
    renderer.renderToGBuffer(camera, standardDeferred, [mesh1]);
    // render from gbuffers into 32-bit color buffer
    renderer.renderFromGBuffer(camera);
    // apply 32-bit post and tonemap from 32-bit color to 8-bit color
    renderer.renderPostProcessHDR();
    // apply 8-bit post and draw
    renderer.renderPostProcessLDR();

    stats.end();
    requestAnimationFrame(tick);
  }

  window.addEventListener('resize', function() {
    renderer.setSize(window.innerWidth, window.innerHeight);
    camera.setAspectRatio(window.innerWidth / window.innerHeight);
    camera.updateProjectionMatrix();
  }, false);

  renderer.setSize(window.innerWidth, window.innerHeight);
  camera.setAspectRatio(window.innerWidth / window.innerHeight);
  camera.updateProjectionMatrix();

  // Start the render loop
  tick();
}


function setup() {
  timer.startTime = Date.now();
  loadOBJText();
  main();
}

setup();
