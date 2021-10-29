import autoprefixer from 'autoprefixer'
import postCssResolveUrls from 'postcss-resolve-urls'

export default {
    postcssPlugins: [
        autoprefixer,
        postCssResolveUrls()
    ]
}
