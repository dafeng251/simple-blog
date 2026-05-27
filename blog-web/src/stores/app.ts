import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getSiteConfig } from '../api/config'

export const useAppStore = defineStore('app', () => {
  const siteTitle = ref('极简博客')
  const siteSubtitle = ref('')
  const siteDescription = ref('')
  const siteLogo = ref('')
  const siteFavicon = ref('')
  const icpNumber = ref('')
  const copyright = ref('')
  const socialLinks = ref<{ label: string; url: string }[]>([])
  const sidebarCollapsed = ref(false)

  function toggleSidebar() {
    sidebarCollapsed.value = !sidebarCollapsed.value
  }

  async function loadConfig() {
    try {
      const res: any = await getSiteConfig()
      const configs: any[] = res.data || []
      configs.forEach((c) => {
        switch (c.key) {
          case 'site_title': siteTitle.value = c.value; break
          case 'site_subtitle': siteSubtitle.value = c.value; break
          case 'site_description': siteDescription.value = c.value; break
          case 'site_logo': siteLogo.value = c.value; break
          case 'site_favicon': siteFavicon.value = c.value; break
          case 'icp_number': icpNumber.value = c.value; break
          case 'copyright': copyright.value = c.value; break
          case 'social_links':
            try { socialLinks.value = JSON.parse(c.value) } catch { socialLinks.value = [] }
            break
        }
      })
      if (siteFavicon.value) {
        const link = document.querySelector("link[rel~='icon']") as HTMLLinkElement
        if (link) link.href = siteFavicon.value
      }
    } catch {
      // use defaults
    }
  }

  return {
    siteTitle, siteSubtitle, siteDescription, siteLogo, siteFavicon,
    icpNumber, copyright, socialLinks, sidebarCollapsed,
    toggleSidebar, loadConfig,
  }
})
