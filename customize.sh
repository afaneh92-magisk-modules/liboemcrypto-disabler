SKIPUNZIP=1

# Extract files
ui_print "- Extracting module files"
unzip -o "$ZIPFILE" module.prop -d $MODPATH >&2

ui_print "- Start disabling liboemcrypto..."
fatal=true
for i in /system/lib /system/lib64 \
         /system/vendor/lib /system/vendor/lib64; do
  if ! `find $i -type f -name 'liboemcrypto.so'` ; then
    fatal=false
    mkdir -p $MODPATH/$i
    touch $MODPATH/$i/liboemcrypto.so
    ui_print "- Successfully disabled $i/liboemcrypto.so!"
  fi
done

# Set executable permissions
set_perm_recursive "$MODPATH" 0 0 0755 0644

if [ "$fatal" == "true" ]; then
  ui_print "- liboemcrypto.so not found!"
  rm -rf $MODPATH
  abort
fi
