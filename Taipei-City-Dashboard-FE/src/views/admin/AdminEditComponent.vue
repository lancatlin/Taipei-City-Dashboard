<!-- Developed by Taipei Urban Intelligence Center 2023-2024-->
<script setup>
import { onMounted, ref, computed } from "vue";
import { useAdminStore } from "../../store/adminStore";
import { useDialogStore } from "../../store/dialogStore";
import { useContentStore } from "../../store/contentStore";

import TableHeader from "../../components/utilities/forms/TableHeader.vue";
// import ComponentTag from "../../components/utilities/miscellaneous/ComponentTag.vue";
import ComponentTag from "../../dashboardComponent/components/ComponentTag.vue";
import AdminComponentSettings from "../../components/dialogs/admin/AdminComponentSettings.vue";

import { chartTypes } from "../../assets/configs/apexcharts/chartTypes";
import { mapTypes } from "../../assets/configs/mapbox/mapConfig";
import AdminComponentTemplate from "../../components/dialogs/admin/AdminComponentTemplate.vue";
import { t } from "../../utils/i18n";

const adminStore = useAdminStore();
const dialogStore = useDialogStore();
const contentStore = useContentStore();

const searchParams = ref({
	searchbyindex: "",
	searchbyname: "",
	sort: "",
	order: "",
	pagesize: 10,
	pagenum: 1,
});

const pages = computed(() => {
	// return an array of pages based on results no stored in admin store
	if (adminStore.components) {
		const pages = Math.ceil(
			adminStore.componentResults / searchParams.value.pagesize
		);
		return Array.from({ length: pages }, (_, i) => i + 1);
	}
	return [];
});

function updateFreq(update_freq, update_freq_unit) {
	const unitRef = {
		minute: t("分"),
		hour: t("時"),
		day: t("天"),
		week: t("週"),
		month: t("月"),
		year: t("年"),
	};
	if (update_freq == 0 || !update_freq) {
		return t("不定期更新");
	}
	return `${t("每")}${update_freq}${unitRef[update_freq_unit]}${t("更新")}`;
}

function parseTime(time) {
	time = new Date(time);
	time.setHours(time.getHours() + 8);
	time = time.toISOString();
	return time.slice(0, 19).replace("T", " ");
}

function handleSort(sort) {
	// asc => desc => "" => asc
	if (searchParams.value.sort === sort) {
		if (searchParams.value.order === "asc") {
			searchParams.value.order = "desc";
		} else {
			searchParams.value.order = "";
			searchParams.value.sort = "";
		}
	} else {
		searchParams.value.sort = sort;
		searchParams.value.order = "asc";
	}
	adminStore.getPublicComponents(searchParams.value);
}

function handleNewQuery() {
	searchParams.value.pagenum = 1;
	adminStore.getPublicComponents(searchParams.value);
}

function handleNewPage(page) {
	searchParams.value.pagenum = page;
	adminStore.getPublicComponents(searchParams.value);
}

function handleOpenSettings(component) {
	adminStore.getComponentData(component);
	dialogStore.showDialog("adminComponentSettings");
}
// const showAdminAddComponent = () => {
// 	dialogStore.showDialog("adminAddComponentTemplate");
// };

onMounted(() => {
	adminStore.getPublicComponents(searchParams.value);
});
</script>

<template>
  <div class="admineditcomponent">
    <!-- 1. Search bar to search components by name or index -->
    <div class="admineditcomponent-search">
      <div>
        <input
          v-model="searchParams.searchbyname"
          type="text"
          placeholder="以組件名稱搜尋"
        >
        <span
          v-if="searchParams.searchbyname !== ''"
          @click="searchParams.searchbyname = ''"
        >cancel</span>
      </div>
      <div>
        <input
          v-model="searchParams.searchbyindex"
          type="text"
          placeholder="以組件Index搜尋"
        >
        <span
          v-if="searchParams.searchbyindex !== ''"
          @click="searchParams.searchbyindex = ''"
        >cancel</span>
      </div>
      <button @click="handleNewQuery">
        {{ $t("搜尋") }}
      </button>
      <!-- <button @click="showAdminAddComponent">
        新增組件
      </button> -->
    </div>
    <!-- 2. The main table displaying all public components -->
    <table class="admineditcomponent-table">
      <thead>
        <tr class="admineditcomponent-table-header">
          <TableHeader min-width="60px" />
          <TableHeader
            min-width="40px"
          >
            City
          </TableHeader>
          <!-- <TableHeader
            :sort="true"
            :mode="
              searchParams.sort === 'id' ? searchParams.order : ''
            "
            min-width="40px"
            @sort="handleSort('id')"
          >
            ID
          </TableHeader> -->
          <TableHeader
            :sort="true"
            :mode="
              searchParams.sort === 'index'
                ? searchParams.order
                : ''
            "
            min-width="200px"
            @sort="handleSort('index')"
          >
            Index
          </TableHeader>
          <TableHeader min-width="200px">
            {{ $t("名稱") }}
          </TableHeader>
          <TableHeader>
            {{ $t("狀態") }}
          </TableHeader>
          <TableHeader
            :sort="true"
            :mode="
              searchParams.sort === 'source'
                ? searchParams.order
                : ''
            "
            min-width="150px"
            @sort="handleSort('source')"
          >
            {{ $t("資料來源") }}
          </TableHeader>
          <TableHeader min-width="165px">
            {{ $t("圖表類型") }}
          </TableHeader>
          <TableHeader min-width="165px">
            {{ $t("地圖類型") }}
          </TableHeader>
          <TableHeader>
            {{ $t("歷史資料") }}
          </TableHeader>
          <TableHeader>
            {{ $t("更新頻率") }}
          </TableHeader>
          <TableHeader
            :sort="true"
            :mode="
              searchParams.sort === 'updated_at'
                ? searchParams.order
                : ''
            "
            min-width="200px"
            @sort="handleSort('updated_at')"
          >
            {{ $t("上次編輯") }}
          </TableHeader>
        </tr>
      </thead>
      <!-- 2-1. Components are present -->
      <tbody v-if="adminStore.components.length !== 0">
        <tr
          v-for="component in adminStore.components"
          :key="`${component.index}-${component.city}`"
        >
          <td class="admineditcomponent-table-settings">
            <button @click="handleOpenSettings(component)">
              <span>settings</span>
            </button>
          </td>
          <td>{{ $t(component.city) }}</td>
          <td>{{ $t(component.index) }}</td>
          <td>{{ $t(component.name) }}</td>
          <td>{{ $t("啟動") }}</td>
          <td>{{ $t(component.source) }}</td>
          <td>
            <div class="admineditcomponent-table-charts">
              <ComponentTag
                v-for="(chart, index) in component.chart_config
                  .types"
                :key="`${component.index}-chart-${index}`"
                :text="chartTypes[chart]"
                mode="fill"
              />
            </div>
          </td>
          <td>
            <div
              v-if="component.map_config[0] !== null"
              class="admineditcomponent-table-maps"
            >
              <ComponentTag
                v-for="(map, index) in component.map_config"
                :key="`${component.index}-map-${index}`"
                :text="mapTypes[map?.type]"
                mode="fill"
              />
            </div>
          </td>
          <td>
            <span>{{
              component.history_config !== null
                ? "check_circle"
                : ""
            }}</span>
          </td>
          <td>
            <div class="admineditcomponent-table-update">
              <ComponentTag
                :text="
                  updateFreq(
                    component.update_freq,
                    component.update_freq_unit
                  )
                "
                mode="small"
              />
            </div>
          </td>
          <td>{{ parseTime(component.updated_at) }}</td>
        </tr>
      </tbody>
      <!-- 2-2. Components are still loading -->
      <div
        v-else-if="contentStore.loading"
        class="admineditcomponent-nocontent"
      >
        <div class="admineditcomponent-nocontent-content">
          <div />
        </div>
      </div>
      <!-- 2-3. An Error occurred -->
      <div
        v-else-if="contentStore.error"
        class="admineditcomponent-nocontent"
      >
        <div class="admineditcomponent-nocontent-content">
          <span>sentiment_very_dissatisfied</span>
          <h2>{{ $t("發生錯誤，無法載入組件列表") }}</h2>
        </div>
      </div>
      <!-- 2-4. Components are loaded but there are none -->
      <div
        v-else
        class="admineditcomponent-nocontent"
      >
        <div class="admineditcomponent-nocontent-content">
          <span>search_off</span>
          <h2>{{ $t("查無符合篩選條件的公開組件") }}</h2>
        </div>
      </div>
    </table>
    <!-- 3. Records per page and pagination control -->
    <div
      v-if="adminStore.components.length !== 0"
      class="admineditcomponent-control"
    >
      <label for="pagesize">{{ $t("每頁顯示") }}</label>
      <select
        v-model="searchParams.pagesize"
        @change="handleNewQuery"
      >
        <option value="10">
          10
        </option>
        <option value="20">
          20
        </option>
        <option value="30">
          30
        </option>
      </select>
      <div class="admineditcomponent-control-page">
        <button
          v-for="page in pages"
          :key="`component-page-${page}`"
          :class="{ active: page === searchParams.pagenum }"
          @click="handleNewPage(page)"
        >
          {{ $t(page) }}
        </button>
      </div>
    </div>
    <AdminComponentSettings :search-params="searchParams" />
    <AdminComponentTemplate />
  </div>
</template>

<style scoped lang="scss">
.admineditcomponent {
	height: 100%;
	width: 100%;
	display: flex;
	flex-direction: column;
	margin-top: 20px;
	padding: 0 20px 20px;

	&-search {
		display: flex;
		column-gap: 0.5rem;
		margin-bottom: var(--font-ms);

		div {
			position: relative;

			span {
				position: absolute;
				right: 0;
				top: 0.3rem;
				margin-right: 4px;
				color: var(--color-complement-text);
				font-family: var(--font-icon);
				font-size: var(--font-m);
				transition: color 0.2s;
				cursor: pointer;

				&:hover {
					color: var(--color-highlight);
				}
			}
		}

		button {
			display: flex;
			align-items: center;
			justify-self: baseline;
			margin-right: 0.4rem;
			padding: 0px 4px;
			border-radius: 5px;
			background-color: var(--color-highlight);
			font-size: var(--font-ms);
			transition: opacity 0.2s;

			&:hover {
				opacity: 0.8;
			}
		}
	}

	&-table {
		max-width: calc(100% - 40px);
		max-height: calc(100% - 90px);

		&::-webkit-scrollbar {
			width: 8px;
			height: 8px;
		}
		&::-webkit-scrollbar-thumb {
			background-color: rgba(136, 135, 135, 0.5);
			border-radius: 4px;
		}
		&::-webkit-scrollbar-thumb:hover {
			background-color: rgba(136, 135, 135, 1);
		}
		&::-webkit-scrollbar-corner {
			background-color: transparent;
		}

		span {
			font-family: var(--font-icon);
			font-size: var(--font-l);
			transition: color 0.2s;
			cursor: default;
		}
		button span:hover {
			color: var(--color-highlight);
			cursor: pointer;
		}

		&-settings {
			position: sticky;
			left: 0;
		}

		&-charts,
		&-maps {
			max-width: 165px;
			display: flex;
			flex-wrap: wrap;
			justify-content: center;
			row-gap: 4px;
		}

		&-update {
			display: flex;
			justify-content: center;
		}
	}

	&-nocontent {
		grid-template-columns: 1fr;

		&-content {
			width: 100%;
			height: calc(100vh - 250px);
			height: calc(100 * var(--vh) - 250px);
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;

			span {
				margin-bottom: var(--font-ms);
				font-family: var(--font-icon);
				font-size: 2rem;
			}

			div {
				width: 2rem;
				height: 2rem;
				border-radius: 50%;
				border: solid 4px var(--color-border);
				border-top: solid 4px var(--color-highlight);
				animation: spin 0.7s ease-in-out infinite;
			}
		}
	}

	&-control {
		height: 2rem;
		display: flex;
		align-items: center;
		margin-top: 0.5rem;

		label {
			margin-right: 0.5rem;
			font-size: var(--font-m);
		}
		select {
			width: 100px;
		}
		option {
			background-color: var(--color-background);
		}

		&-page {
			button {
				margin-left: 0.5rem;
				padding: 0.2rem 0.5rem;
				border-radius: 5px;
				background-color: var(--color-component-background);
				font-size: var(--font-m);
				transition: opacity 0.2s background-color 0.2s;

				&:hover {
					opacity: 0.7;
				}
			}
			.active {
				background-color: var(--color-complement-text);
			}
		}
	}
}
</style>
