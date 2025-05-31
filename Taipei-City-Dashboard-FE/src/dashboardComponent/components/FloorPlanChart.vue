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
    <svg viewBox="0 0 1501 1486" fill="none" xmlns="http://www.w3.org/2000/svg">
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



</style>
