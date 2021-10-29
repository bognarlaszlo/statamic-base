import dotenv from 'dotenv'
dotenv.config();

import esbuild from 'esbuild'
import postsass from 'esbuild-postsass'
import squoosh from 'esbuild-squoosh'

import esbuildConfig from './config/esbuild.config.js'
import postsassConfig from './config/postsass.config.js'
import squooshConfig from './config/squoosh.config.js'

esbuild.build({
    ...esbuildConfig,
    entryPoints: [
        'resources/css/main.scss',
        'resources/js/main.js'
    ],
    outdir: 'public',
    plugins: [
        postsass(postsassConfig),
        squoosh(squooshConfig)
    ],
    loader: {
        '.jpg': 'file',
        '.jpeg': 'file',
        '.png': 'file',
        '.svg': 'file'
    }
})
.catch(() => process.exit(1));
