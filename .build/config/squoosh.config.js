export default {
    disabled: process.env.APP_ENV !== 'production',
    extensions: /\.(jpg|jpeg|png)$/,
    encodeOptions: {
        mozjpeg: {},
        oxipng: {}
    }
}
