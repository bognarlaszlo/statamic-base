const watch = process.argv.includes('--watch');
const production = process.env.APP_ENV === 'production';

export default {
    bundle: true,
    logLevel: 'info',
    minify: production,
    sourcemap: !production,
    watch: watch,
    assetNames: '[dir]/[name]-[hash]'
}
