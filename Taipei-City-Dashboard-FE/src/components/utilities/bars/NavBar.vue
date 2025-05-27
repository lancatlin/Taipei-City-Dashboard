<!-- Developed by Taipei Urban Intelligence Center 2023-2024-->

<!-- Navigation will be hidden from the navbar in mobile mode and moved to the settingsbar -->

<script setup>
import { computed, ref } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useFullscreen } from "@vueuse/core";
import { useAuthStore } from "../../../store/authStore";
import { useDialogStore } from "../../../store/dialogStore";
import LanguagePicker from "../../LanguagePicker.vue";

import UserSettings from "../../dialogs/UserSettings.vue";
import ContributorsList from "../../dialogs/ContributorsList.vue";

const { VITE_APP_TITLE } = import.meta.env;
const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();
const dialogStore = useDialogStore();
const { isFullscreen, toggle } = useFullscreen();

const showUserMenu = ref(false);

const currentPath = computed(() => route.path);

const linkQuery = computed(() => {
	const { query } = route;
	const indexQuery = `?index=${query.index}`;
	const cityQuery = query.city ? `&city=${query.city}` : '';
	return `${indexQuery}${cityQuery}`;
});

const publicNavItems = [
	{ name: "navigation.home", path: "/" },
	{ name: "navigation.components", path: "/component" },
];

const privateNavItems = [
	{ name: "navigation.favorites", path: "/dashboard" },
	{ name: "navigation.publicDashboards", path: "/dashboard/public" },
	{ name: "navigation.personalDashboards", path: "/dashboard/personal" },
];

function toggleUserMenu() {
	showUserMenu.value = !showUserMenu.value;
}
</script>

<template>
	<nav>
		<div class="navbar-logo">
			<router-link to="/">
				<h2>{{ $t('navigation.dashboard') }}</h2>
			</router-link>
		</div>
		<div class="navbar-links">
			<router-link
				v-for="item in publicNavItems"
				:key="`${item.name}-${item.path}`"
				:to="item.path"
				:class="{ active: item.path === currentPath }"
			>
				{{ $t(item.name) }}
			</router-link>
			<div
				v-if="authStore.token && authStore.user.is_whitelist"
				class="navbar-user"
			>
				<button @click="toggleUserMenu">
					<span>{{ authStore.user.user_name }}</span>
					<span :class="{ active: showUserMenu }">expand_more</span>
				</button>
				<div v-if="showUserMenu" class="navbar-user-menu">
					<router-link
						v-for="item in privateNavItems"
						:key="`${item.name}-${item.path}`"
						:to="item.path"
						:class="{ active: item.path === currentPath }"
						@click="showUserMenu = false"
					>
						{{ $t(item.name) }}
					</router-link>
					<button
						v-if="authStore.user.is_admin"
						@click="
							() => {
								showUserMenu = false;
								router.push('/admin');
							}
						"
					>
						{{ $t('navigation.admin') }}
					</button>
					<button
						@click="
							() => {
								showUserMenu = false;
								authStore.logOut();
							}
						"
					>
						{{ $t('navigation.logout') }}
					</button>
				</div>
			</div>
			<button
				v-else-if="!authStore.token"
				@click="authStore.showLoginForm"
				class="navbar-login"
			>
				{{ $t('navigation.login') }}
			</button>
			<!-- Add Language Picker -->
			<LanguagePicker />
		</div>
	</nav>
</template>

<style scoped lang="scss">
.navbar {
	height: 60px;
	width: 100vw;
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-bottom: 1px solid var(--color-border);
	background-color: var(--color-component-background);
	user-select: none;

	&-logo {
		display: flex;

		h1 {
			font-weight: 500;
		}

		h2 {
			font-size: var(--font-s);
			font-weight: 400;
		}

		&-image {
			width: 22.94px;
			height: 45px;
			margin: 0 var(--font-m);

			img {
				height: 45px;
				filter: invert(1);
			}
		}
	}

	&-tabs {
		display: flex;

		a {
			height: 59px;
			display: flex;
			align-items: center;
			margin-left: var(--font-s);
			transition: opacity 0.2s, border-bottom 0.2s;
			border-bottom: solid 3px transparent;

			&:hover {
				opacity: 0.8;
			}
		}

		.router-link-active {
			border-bottom: solid 3px var(--color-highlight);
			color: var(--color-highlight);

			&:hover {
				opacity: 1;
			}
		}

		@media screen and (max-width: 750px) {
			display: none;
		}
		@media screen and (max-height: 500px) {
			display: none;
		}
	}

	&-user {
		display: flex;
		align-items: center;

		li a,
		button {
			display: flex;
			align-items: center;
			margin-right: var(--font-m);
			padding: 2px 4px;
			border-radius: 4px;
			font-size: var(--font-m);
			transition: background-color 0.25s;
		}

		span {
			font-family: var(--font-icon);
			font-size: calc(var(--font-l) * var(--font-to-icon));
		}

		&-user:hover ul,
		&-info:hover ul {
			display: block;
			opacity: 1;
		}

		&-user,
		&-info {
			height: 60px;
			min-width: 100px;
			display: flex;
			align-items: center;
			justify-content: center;

			@media screen and (max-width: 750px) {
				display: none;
			}
			@media screen and (max-height: 500px) {
				display: none;
			}

			ul {
				min-width: 100px;
				display: none;
				position: absolute;
				right: 20px;
				top: 55px;
				padding: 8px;
				border-radius: 5px;
				background-color: rgb(85, 85, 85);
				opacity: 0;
				transition: opacity 0.25s;
				z-index: 10;

				li {
					border-radius: 5px;
					transition: background-color 0.25s;

					a,
					button {
						padding: 8px 6px;
						width: 100%;
						height: 100%;
					}
				}

				li:hover {
					background-color: var(--color-complement-text);
				}
			}
		}

		&-info {
			min-width: 0;

			ul {
				right: 120px;
				top: 55px;
			}

			@media screen and (max-width: 750px) {
				display: flex;

				ul {
					right: 20px;
					top: 55px;
				}
			}
			@media screen and (max-height: 500px) {
				display: flex;
			}
		}
	}

	.navbar-links {
		// ...existing styles...

		// Add styling for language picker in navbar
		:deep(.language-picker) {
			margin-left: 1rem;

			.language-select {
				background: var(--color-border);
				border: 1px solid var(--color-border-complement);
				color: var(--color-complement-text);
				padding: 0.25rem 0.5rem;
				border-radius: 5px;
				font-size: 0.9rem;

				&:focus {
					outline: none;
					border-color: var(--color-highlight);
				}
			}
		}
	}
}
</style>
