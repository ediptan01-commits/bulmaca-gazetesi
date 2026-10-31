from pathlib import Path
import re

# Apply visible branding after flutter create; preserve the technical application ID.
manifest = Path('android/app/src/main/AndroidManifest.xml')
s = manifest.read_text()
s = re.sub(r'android:label="[^"]*"', 'android:label="Bulmaca Dünyası"', s)
s = s.replace('@mipmap/ic_launcher', '@drawable/bulmaca_dunyasi')
manifest.write_text(s)
icons = Path('android/app/src/main/res/drawable')
icons.mkdir(parents=True, exist_ok=True)
(icons / 'bulmaca_dunyasi.xml').write_text('''<vector xmlns:android="http://schemas.android.com/apk/res/android" android:width="108dp" android:height="108dp" android:viewportWidth="108" android:viewportHeight="108">
<path android:fillColor="#173E32" android:pathData="M0,0h108v108h-108z"/>
<path android:fillColor="#F7F2E8" android:pathData="M54,16a38,38 0,1 0,0 76a38,38 0,1 0,0 -76"/>
<path android:strokeColor="#173E32" android:strokeWidth="3.5" android:fillColor="#00000000" android:pathData="M16,54H45C40,45 47,40 52,45C57,50 51,54 50,54H92M54,16V43C64,38 70,47 64,52C60,57 54,54 54,52V92"/>
</vector>''')
