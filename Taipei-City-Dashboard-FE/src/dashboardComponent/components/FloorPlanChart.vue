<!-- Developed by Indieveleoper 2025 -->

<script setup>
import { computed, ref } from "vue";

const props = defineProps([
	"chart_config",
	"activeChart",
	"series",
	"map_config",
	"map_filter",
	"map_filter_on",
]);




const emits = defineEmits([
	"filterByParam",
	"filterByLayer",
	"clearByParamFilter",
	"clearByLayerFilter",
	"fly"
]);


const targetRoom = ref(null);
const mousePosition = ref({ x: null, y: null });
const selectedIndex = ref(null);

 // Transform API data in form of {x: str, y: str} into more usable
 // Object of type {[roomName]: number IncidentCount}
const roomData = props.series[0].data.reduce((acc, { x, y }) => {
   acc[x] = y;
   return acc;
}, {});

// Map of box to allow more easily tweaking per-room coordinates of text
 const svgBoxMap = {
   'topleft': {
     x: 72,
     y: 393,

     path: "M264.532 143.853C273.369 143.853 280.532 151.017 280.532 159.853V501.311C280.532 510.148 273.369 517.311 264.532 517.311H16C7.16345 517.311 0 510.148 0 501.311V159.853C0 151.017 7.16344 143.853 16 143.853H264.532Z",
   },
   'midleft': {
     x: 62,
     y: 683,

     path: "M264.532 533.311C273.369 533.311 280.532 540.475 280.532 549.311V690.891C280.532 699.728 273.369 706.891 264.532 706.891H16C7.16357 706.891 0.000189678 699.728 0 690.891V549.311C0.000222664 540.475 7.16358 533.311 16 533.311H264.532Z",
   },
   'bottomleft': {
     x: 62,
     y: 852,
     path: "M264.532 722.891C273.369 722.891 280.532 730.055 280.532 738.891V880.47C280.532 889.307 273.369 896.47 264.532 896.47H16C7.16348 896.47 5.77289e-05 889.307 0 880.47V738.891C0 730.055 7.16344 722.891 16 722.891H264.532Z",
   },
   'topright': {
     x: 462,
     y: 112,
     path: "M741.634 0.569092C756.415 0.569092 768.397 9.87454 768.397 21.3533V106.937C768.397 118.416 756.415 127.722 741.634 127.722H323.301C308.52 127.722 296.538 118.416 296.538 106.937V21.3533C296.538 9.87462 308.52 0.569235 323.301 0.569092H741.634Z",
   },
   'midright': {
     x: 462,
     y: 282,
     path: "M752.397 143.853C761.234 143.853 768.397 151.017 768.397 159.853V307.293C768.397 316.129 761.234 323.293 752.397 323.293H312.538C303.702 323.293 296.538 316.129 296.538 307.293V159.853C296.538 151.017 303.701 143.854 312.537 143.853H752.397Z",
   },
   'bigmid': {
     x: 462,
     y: 552,
     path: "M752.397 340.318C761.234 340.318 768.397 347.482 768.397 356.318V600.598C768.397 609.435 761.234 616.598 752.397 616.598H493.209C484.373 616.599 477.209 623.762 477.209 632.598V880.598C477.209 889.435 470.045 896.598 461.209 896.598H312.532C303.696 896.598 296.532 889.435 296.532 880.598V356.318C296.532 347.482 303.696 340.318 312.532 340.318H752.397Z"
   },
   'bottomright': {
     x: 562,
     y: 772,

     path: "M752.397 630.683C761.234 630.683 768.397 637.847 768.397 646.683V788.262C768.397 797.099 761.234 804.262 752.397 804.262H506.486C497.65 804.262 490.486 797.099 490.486 788.262V638.683C490.486 634.265 494.068 630.683 498.486 630.683H752.397Z",
   },

 }

 const rooms = {
   "臥室": {
     "pathData": svgBoxMap.topleft.path,
     name: "臥室",
     textx: svgBoxMap.topleft.x,
     texty: svgBoxMap.topleft.y,
   },
   "書房": {
     pathData: svgBoxMap.midleft.path,
     name: "書房",
     textx: svgBoxMap.midleft.x,
     texty: svgBoxMap.midleft.y,
   },

   "神龕": {
     "pathData": svgBoxMap.bottomleft.path,
     name: "神龕",
     textx: svgBoxMap.bottomleft.x,
     texty: svgBoxMap.bottomleft.y,

   },

   "陽台": {
     "pathData": svgBoxMap.topright.path,
     name: "陽台",
     textx: svgBoxMap.topright.x,
     texty: svgBoxMap.topright.y,

   },
   "廚房": {
     "pathData": svgBoxMap.midright.path,
     name: "廚房",
     textx: svgBoxMap.midright.x,
     texty: svgBoxMap.midright.y,

   },

   "客廰": {
       "pathData": svgBoxMap.bigmid.path,
     name: "客廰",
       textx: svgBoxMap.bigmid.x,
       texty: svgBoxMap.bigmid.y,

     },

   "浴廁": {
     "pathData": svgBoxMap.bottomright.path,
     name: "浴廁",
     textx: svgBoxMap.bottomright.x,
     texty: svgBoxMap.bottomright.y,

   },
};

 const roomSumHighest = computed(()=>{
    let sum = 0;
    let highest = 0;

    // Create room data from series prop
    Object.keys(rooms).forEach((roomName) => {
        // Get value from series data or default to 0
        const value = roomData[roomName] || 0;
        sum += value;
        if (value > highest) highest = value;
      });

    return { sum, highest };

 });

// Helper function to create room path components
// returns an object with
// roomName: string,
// pathData: string,
// buildingName: string,
// roomIndex: number,
// fillOpacity: number,
// isActive: boolean
function createRoomPath(room, district, highest, sum) {
   const value = roomData[room] || 0;

  const fillOpacity = Math.max(0.12, value / highest);
  const pathData = rooms[room]?.pathData || "";

  return {
    name: room,
    pathData,
    fillOpacity,
    isActive: targetRoom.value === room || selectedIndex.value === room,
    value,
    textx: rooms[room].textx,
    texty: rooms[room].texty,
  };
}

const roomsMap = computed(() => {
  return Object.keys(rooms).map(room => createRoomPath(room, roomSumHighest.value.highest, roomSumHighest.value.sum));
});


// Parse Room Data (to support 2D or 3D data)
const tooltipPosition = computed(() => {
	if (!mousePosition.value.x || !mousePosition.value.y) {
		return {
			left: "-1000px",
			top: "-1000px",
		};
	}
	return {
		left: `${mousePosition.value.x - 10}px`,
		top: `${mousePosition.value.y - 54}px`,
	};
});

function toggleActive(roomPath) {
  targetRoom.value = roomPath;
}

function toggleActiveToNull() {
  targetRoom.value = null;
}

function updateMouseLocation(e) {
  mousePosition.value.x = e.pageX;
  mousePosition.value.y = e.pageY;
}

function handleDataSelection(roomName) {
  if (!props.map_filter || !props.map_filter_on) {
    return;
  }


  if (roomName !== selectedIndex.value) {
    // Room selected - apply filter
    if (props.map_filter.mode === "byParam") {
      emits("filterByParam", props.map_filter, props.map_config, roomName, null);
    } else if (props.map_filter.mode === "byLayer") {
      emits("filterByLayer", props.map_config, roomName);
    }
    selectedIndex.value = roomName;
  } else {
    // Room deselected - clear filter
    if (props.map_filter.mode === "byParam") {
      emits("clearByParamFilter", props.map_config);
    } else if (props.map_filter.mode === "byLayer") {
      emits("clearByLayerFilter", props.map_config);
    }
    selectedIndex.value = null;
  }
}



</script>

<template>
  <div
    v-if="activeChart === 'FloorPlanChart'"
    class="floorplanchart"
  >
    <div class="floorplanchart-title">
      <h5>總合</h5>
      <!-- <h6>{{ roomData.sum }}</h6> -->
      <div class="floorplanchart-title-legend">
        <p>多</p>
        <p>少</p>
      </div>
    </div>

    <div class="roomchart-chart">
      <div v-for="room in roomsMap" :key="room">
        <div >
          <p>{{ room.roomName }}</p>
        </div>
      </div>
    <svg class="main-svg" viewBox="0 0 1501 1486" fill="none" xmlns="http://www.w3.org/2000/svg">
      <rect y="0" width="820.398" height="954" rx="32" fill="#111111" stroke="gray" />
      <path v-for="room in roomsMap"
      :key="room.name"
      :d="room.pathData"
      fill="red"
            :fill-opacity="room.fillOpacity"
      :class="{ 'active-room': room.isActive }"
      @mouseenter="toggleActive(room.name)"
      @mousemove="updateMouseLocation"
      @mouseleave="toggleActiveToNull"
      @click="handleDataSelection(room.name)"
      />
      <text v-for="room in roomsMap"
            class="room-name"
            :x="room.textx"
            :y="room.texty"
            :dy="-55"
      >
{{room.name}}
      </text>

      <text v-for="room in roomsMap"
            class="room-value"
            :x="room.textx"
            :y="room.texty"
            :dx="25"
            >
        {{room.value}} 件
      </text>
      <text v-for="room in roomsMap"
            class="fire-emoji"
            :x="room.textx"
            :y="room.texty"
            :dx="-25"
      >
        🔥
      </text>

<g transform="translate(215,54)" >
<path d="M266.217 751V821H279.527V751H266.217Z" fill="white" fill-opacity="0.25"/>
<path d="M267 821V826H279V821H267Z" fill="black"/>
<path d="M267 746V751H279V746H267Z" fill="black"/>
<path d="M202.763 816.024V814.024H205.763V816.024H202.763Z" fill="black" fill-opacity="0.4"/>
<path d="M202.763 823.024V821.024H205.763V823.024H202.763Z" fill="black" fill-opacity="0.4"/>

<path :class="{'door': true, 'door-special': true, 'door-客廰': true, 'door-active': targetRoom === '客廰' }" d="M196.763 816.024V821.024H266.763V816.024H196.763Z" fill="black"/>

<path d="M69.5352 375.456L69.5351 305.456H85.5273V375.456H69.5352Z" fill="white" fill-opacity="0.25"/>
<path d="M70 305.456V300.456H85V305.456H70Z" fill="black"/>
<path d="M70 380.456V375.456H85V380.456H70Z" fill="black"/>
<path d="M6 310.456L6 312.456H9V310.456H6Z" fill="black" fill-opacity="0.4"/>
<path d="M6 303.456V305.456H9V303.456H6Z" fill="black" fill-opacity="0.4"/>
<path :class="{'door': true, 'door-臥室': true, 'door-active': targetRoom === '臥室' }" data-room="臥室" d="M0 310.456L0 305.456H70L70 310.456H2.18557e-07Z" fill="black"/>
<path d="M337 69.7226H407V85.8476H337V69.7226Z" fill="white" fill-opacity="0.25"/>
<path d="M407 70.2826H412V85.2826H407V70.2826Z" fill="black"/>
<path d="M332 70.2826H337V85.2826H332V70.2826Z" fill="black"/>
<path d="M402 6.28265H400V9.28265H402V6.28265Z" fill="black" fill-opacity="0.4"/>
<path d="M409 6.28265H407V9.28265H409V6.28265Z" fill="black" fill-opacity="0.4"/>

<path :class="{'door': true, 'door-陽台': true, 'door-active': targetRoom === '陽台' }" d="M402 0.282654H407V70.2826L402 70.2827V0.282654Z" fill="black"/>

<path d="M69.5352 605.723L69.5351 535.723H85.5273V605.723H69.5352Z" fill="white" fill-opacity="0.25"/>
<path d="M70 535.723V530.723H85V535.723H70Z" fill="black"/>
<path d="M70 610.723V605.723H85V610.723H70Z" fill="black"/>
<path d="M6 540.723L6 542.723H9V540.723H6Z" fill="black" fill-opacity="0.4"/>
<path d="M6 533.723V535.723H9V533.723H6Z" fill="black" fill-opacity="0.4"/>
<path :class="{'door': true, 'door-書房': true, 'door-active': targetRoom === '書房' }" d="M0 540.723L0 535.723H70L70 540.723H2.18557e-07Z" fill="black"/>
<path d="M279.488 658V728H266.211V658H279.488Z" fill="white" fill-opacity="0.25"/>
<path d="M279 728V733H267V728H279Z" fill="black"/>
<path d="M279 653V658H267V653H279Z" fill="black"/>
<path d="M345.263 722.781V720.781H342.263V722.781H345.263Z" fill="black" fill-opacity="0.4"/>
<path d="M345.263 729.781V727.781H342.263V729.781H345.263Z" fill="black" fill-opacity="0.4"/>

<path :class="{'door': true, 'door-浴廁': true, 'door-active': targetRoom === '浴廁' }" d="M351.263 722.781V727.781H281.263V722.781H351.263Z" fill="black"/>

<path d="M69.5352 766.282L69.5351 696.282H85.5273V766.282H69.5352Z" fill="white" fill-opacity="0.25"/>
<path d="M70 696.282V691.282H85V696.282H70Z" fill="black"/>
<path d="M70 771.282V766.282H85V771.282H70Z" fill="black"/>
<path d="M6 701.282L6 703.282H9V701.282H6Z" fill="black" fill-opacity="0.4"/>
<path d="M6 694.282V696.282H9V694.282H6Z" fill="black" fill-opacity="0.4"/>
<path :class="{'door': true, 'door-神龕': true, 'door-active': targetRoom === '神龕' }" d="M0 701.282L0 696.282H70L70 701.282H2.18557e-07Z" fill="black"/>
<path d="M239 265.297H419V282.309H239V265.297Z" fill="white" fill-opacity="0.25"/>
<path d="M419 265H424V282H419V265Z" fill="black"/>
<path d="M234 265H239V282H234V265Z" fill="black"/>
<path d="M404 271H419V276H404V271Z" fill="black"/>
<path d="M251 267.875C251 266.839 250.161 266 249.125 266H243.875C242.839 266 242 266.839 242 267.875C242 268.496 242.504 269 243.125 269H245V278H243.125C242.504 278 242 278.504 242 279.125C242 280.161 242.839 281 243.875 281H249.125C250.161 281 251 280.161 251 279.125C251 278.504 250.496 278 249.875 278H248V269H249.875C250.496 269 251 268.496 251 267.875Z" fill="black"/>
<path d="M416 267.875C416 266.839 415.161 266 414.125 266H408.875C407.839 266 407 266.839 407 267.875C407 268.496 407.504 269 408.125 269H410V278H408.125C407.504 278 407 278.504 407 279.125C407 280.161 407.839 281 408.875 281H414.125C415.161 281 416 280.161 416 279.125C416 278.504 415.496 278 414.875 278H413V269H414.875C415.496 269 416 268.496 416 267.875Z" fill="black"/>
<path d="M413 271V269H410V271H413Z" fill="black" fill-opacity="0.4"/>
<path d="M413 278V276H410V278H413Z" fill="black" fill-opacity="0.4"/>
<path d="M248 271V269H245V271H248Z" fill="black" fill-opacity="0.4"/>
<path d="M248 278V276H245V278H248Z" fill="black" fill-opacity="0.4"/>
<path d="M239 271H254V276H239V271Z" fill="black"/>
</g>
    </svg>
    </div>

    <!-- Tooltip -->
    <div
      v-if="targetRoom"
      class="roomchart-tooltip"
      :style="tooltipPosition"
    >
      <p>{{ targetRoom }}</p>
      <p>{{ roomData[targetRoom] }}</p>
    </div>
  </div>
</template>

<style scoped lang="scss">
* {
	margin: 0;
	padding: 0;
	font-family: "微軟正黑體", "Microsoft JhengHei", "Droid Sans", "Open Sans",
		"Helvetica";
	overflow: hidden;
}

.floorplanchart {
  height: 100%;
	max-height: 100%;
	position: relative;
	overflow-y: scroll;

	&-title {
		display: flex;
		flex-direction: column;
		justify-content: center;
		position: absolute;
		left: 0;
		top: 0;
		margin: 0.5rem 0 -0.5rem;

		h5 {
			color: var(--color-complement-text);
		}

		h6 {
			color: var(--color-complement-text);
			font-size: var(--font-m);
			font-weight: 400;
		}

		&-legend {
			display: flex;
			justify-content: space-between;

			div {
				position: relative;
				width: 3rem;
				margin: 0 4px;
				border-radius: 5px;
			}

			div:before {
				content: "";
				width: 3rem;
				height: var(--font-l);
				position: absolute;
				top: 0;
				left: 0;
				background: linear-gradient(
					270deg,
					rgba(40, 42, 44, 1),
					rgba(40, 42, 44, 0.2)
				);
			}

			p {
				font-size: var(--font-s);
				color: var(--color-complement-text);
			}
		}
	}

	&-chart {
		// height: 100%;
		display: flex;
		justify-content: center;

		svg {
			height: auto;

			path {
				transition: transform 0.2s;
			}
		}

		&-info {
			position: fixed;
			z-index: 20;
		}
	}
}

.active-room {
	transform: translateY(-5px);
    fill: #DDDDDD;
}

 .room-name {
     font-size: 4rem;
     fill: white;
 }
 .room-value {
     font-size: 3rem;
     fill: white;
 }
 .fire-emoji {
     fill: red;
     font-size: 3rem;
 }

 @keyframes ease-in {
	   0% {
		     opacity: 0;
	   }

	   100% {
		     opacity: 1;
	   }
 }

 .main-svg {
     height: 717px;
 }
 .door {
     transition: transform 0.8s ease-in-out;
     transform: rotate(-90deg);
 }
 .door.door-active {
     transform: rotate(0deg);
 }

 .door-special {
     transform: rotate(90deg);
 }


 .door.door-臥室 {
     transform-origin: 62px 313px;
 }
 .door.door-書房 {
     transform-origin: 62px 540px;
 }
 .door.door-神龕 {
     transform-origin: 62px 700px;
 }
 .door.door-陽台{
     transform-origin: 403px 71.2px;
 }
 .door.door-客廰{
     transform-origin: 257px 814px;
 }
 .door.door-浴廁{
     transform-origin: 289px 724px;
 }

</style>
