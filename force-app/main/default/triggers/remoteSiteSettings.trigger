trigger remoteSiteSettings on User (after insert) {
  MetadataAPIUtility.createRemoteSiteSettings();
}