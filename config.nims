--mm:orc
--threads:off
if defined(release) or defined(danger):
    --opt:speed
    --passC:"-flto"
    --passL:"-flto"
