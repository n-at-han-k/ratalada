/**
 * What webpack's DefinePlugin used to inline as a bare `buildInfo` global
 * (webpack/_config-builder.js). A magic global is a build system's trick; a
 * module is just code, and this fork is read by people, not by webpack.
 */
const buildInfo = {
  PACKAGE_VERSION: "6.0.7",
  GIT_COMMIT: "c7aafd2",
  GIT_DIRTY: false,
  BUILD_TIME: "forked",
}

export default buildInfo
