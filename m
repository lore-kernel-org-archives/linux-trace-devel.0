Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793031955;
	b=uxXYCM5lvvS3u6/3OgQhmJUZCozyBiR/SY/aEgW5NxxKz7Jtz6zwGBG3ZmOGP3Z1cClK
	 ZqDqmoo0H7N2DbBbNyD1viKmaxJv4Kc0BEj7AZ1dkofJWdmxbBGceGEnTgfASKUvgqtMs
	 Nxw09P2cMY87aOVvEOIWH5MWl80XBO2Em3cswy09gQhImgpcd4RFaS9MEWxgr0lTxEX+k
	 5nCTW63SdghLody7ykglQcZsHbOPoAmA62Bx8HwXNK37jJFs2dt3X4l4KDQxoALc+v5cg
	 hFEjh0TYQOvlubA973hR9j9O+TsOMIKOv74VhdamaSdDyGywszWKBmW0t3KCHIpMjVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031955;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CMAE-Envelope;
	bh=UlttmJTwA4lzEbidHt6hmOLb6eECEoSn7G3sHv6Hotk=;
	b=x6BF6vEAejcmjlD6YpgN9xYUe8mEgF+P12VXHHa/qJu9IFIpOQR62kB4QABQH9FM4N08
	 XdeEnJYnPegPEG4v5XkyxS4o3Izm4t1CJCSjWjh51qygU512+eSpTp5ddDg7nMox2N8sl
	 QkCr5ygUyeRauUQdKDgptT+j5h5sWe7q/PPIjUSFm6ZHa0vaiFYU02w/Ly4vkpeUPP5sV
	 VcpM2zKiiL3bO4PScI835Uui8amhO6NntCkErkfuE30u0qK2hPGw5jvBcOvhIpEcWZSuh
	 cTzXp1AOlD3J4odYm1qAGo+SpB7gwmrk2upURdZToI95eqcElvn+efcWxNoBb8hEvBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=benettiengineering.com;
	spf=pass smtp.mailfrom=benettiengineering.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=E+IzJNnb;
	arc=none smtp.remote-ip=62.149.156.72
Received: from smtpcmd0872.aruba.it (smtpcmd0872.aruba.it [62.149.156.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D84606A31A
	for <linux-trace-devel@vger.kernel.org>; Mon, 26 Oct 2026 16:25:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40D84606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=E+IzJNnb
Received: from localhost.localdomain ([151.95.84.63])
	by Aruba SMTP with ESMTPSA
	id LNW4xB47A6WK8LNW4xS6sz; Mon, 26 Oct 2026 17:25:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1793031944; bh=ATZWNjW9T95qlx4yIYc7T8r4AfKObyJidaNU3jL6EOY=;
	h=From:To:Subject:Date:MIME-Version;
	b=E+IzJNnbcRbahv7PENr+Twg0UyiSrDrfOkfB/kTmzGrYnqJmCgKLXTBf3QOofw/V5
	 v4Qg8nmwaI9Q1ddLJ74XPgYvl/RPih1bR9YtEL5unwge1oLA3bq97PPTcmyFhWF5mT
	 RAwxIj84lTMfu0nZrz5lPnILjTZbEzeEf+cwYgSztvXTQvsIC673BY1Eu71XK6ko9a
	 6aj4jByk684wqd5Vv6ZnGVyg7mq4ZzzdP4P3//sRHZ5NxllYjgyDFZDpgGwytxwv/e
	 r0wHHsypRo0r+0mhxHHsD4BHpLeNf2NzBqUjuzPSwKORXLVtWfFpG/gRifS1+4wRov
	 NlGx9fPAcPAWQ==
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
To: linux-trace-devel@vger.kernel.org
Cc: Giulio Benetti <giulio.benetti@benettiengineering.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3] Fix build failure due to btf on Linux < 6.0
Date: Mon, 26 Oct 2026 17:24:17 +0100
Message-ID: <20261026162417.646303-1-giulio.benetti@benettiengineering.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfJadunOGg65UeSSz+ntUw3KKNYCpzhnXlycpbJOzv+7ifN19OZEJtSgaqmHvS5fu0yTKYkJDHqFUM4vUrzaibRK6HhrLaROGpxa6f2ahET8WJfeUo8g/
 yYZsB3yM6OQMpW6hvHBfn4GB41BZ6ATaD6C7ZyLbAwT44zY3umiEpdo3A/RhuLBwtSKaGGKyh/f8mzMbflbJlqL8G4I1YS9/luF0iU1NxXEltqeY8D13+xmM
 OekDSfgJygyFdsbsT+H2QZHwNVIhUFloKpR8BHlIYGFHH4Ho405dO+zS/46Avf11w6CI8Dkx98MjQ6AE1taDI//4KKIMsaSrA3Swqxdi6CA=

With commit:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6089fb325cf737eeb2c4d236c94697112ca860da
enum BTF_KIND_ENUM64 has been firstly introduced and this is the latest
BTF_KIND_* enumaration to be added to libtraceevent. So let's check
in runtime, both in Makefile and meson, if BTF_KIND_ENUM64 does exist
as well as struct btf_enum64 members name_off, val_lo32, val_hi32 to
make sure the entire enum64 facility is defined and guard for NO_BTF
selectively in trace-btf.c.
If it's not there let's disable btf support.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Co-authored-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
---
V1->V2:
* fixed meson check and all bft C source
V2->V3:
* check struct parameters other than only BTF_KIND_ENUM64
---
 Makefile        | 30 +++++++++++++++++++++++-------
 src/meson.build | 14 ++++++++++++++
 src/trace-btf.c |  7 +++++++
 3 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 8a7a1dd..4b291c0 100644
--- a/Makefile
+++ b/Makefile
@@ -27,6 +27,13 @@ $(call allow-override,PKG_CONFIG,pkg-config)
 $(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
 $(call allow-override,LDCONFIG,ldconfig)
 
+# Set compile option CFLAGS
+ifdef EXTRA_CFLAGS
+  CFLAGS ?= $(EXTRA_CFLAGS)
+else
+  CFLAGS ?= -g -Wall
+endif
+
 EXT = -std=gnu99
 INSTALL = install
 
@@ -37,6 +44,22 @@ INSTALL = install
 DESTDIR ?=
 DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
 
+test-build = $(if $(shell sh -c 'echo "$(1)" | tee /tmp/t.c| \
+	$(CC) -o /dev/null -x c - > /dev/null 2>&1 && echo y'), $2)
+
+define BTF_LATEST_SOURCE
+#include <linux/btf.h>
+int main(void) { struct btf_enum64 e = {}; \
+		 return e.name_off + e.val_lo32 + e.val_hi32 + \
+			BTF_KIND_ENUM64; }
+endef
+
+BTF_OK := $(call test-build,$(BTF_LATEST_SOURCE),y)
+
+ifneq ($(strip $(BTF_OK)), y)
+CFLAGS += -DNO_BTF
+endif
+
 LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
 ifeq ($(LP64), 1)
   libdir_relative_temp = lib64
@@ -123,13 +146,6 @@ INCLUDES = -I. -I $(srctree)/include -I $(EP_HEADERS_DIR) $(CONFIG_INCLUDES)
 
 export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED EP_HEADERS_DIR
 
-# Set compile option CFLAGS
-ifdef EXTRA_CFLAGS
-  CFLAGS := $(EXTRA_CFLAGS)
-else
-  CFLAGS := -g -Wall
-endif
-
 LIBS ?= -ldl
 export LIBS
 
diff --git a/src/meson.build b/src/meson.build
index 3a7a082..0fa5a5f 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -17,6 +17,20 @@ sources= [
 cc = meson.get_compiler('c')
 dl_dep = cc.find_library('dl')
 
+btf_enum64_test_code = '''
+#include <linux/btf.h>
+int main(void) {
+    struct btf_enum64 e = {};
+
+    return e.name_off + e.val_lo32 + e.val_hi32 +
+           BTF_KIND_ENUM64;
+}
+'''
+
+if not cc.compiles(btf_enum64_test_code, name : 'BTF_KIND_ENUM64 check')
+    add_project_arguments('-DNO_BTF', language : 'c')
+endif
+
 libtraceevent = library(
     'traceevent',
     sources,
diff --git a/src/trace-btf.c b/src/trace-btf.c
index 2d66e01..f980d58 100644
--- a/src/trace-btf.c
+++ b/src/trace-btf.c
@@ -8,7 +8,9 @@
 #include <stdlib.h>
 #include <stdbool.h>
 
+#ifndef NO_BTF
 #include <linux/btf.h>
+#endif
 
 #include "event-parse.h"
 #include "event-utils.h"
@@ -29,6 +31,9 @@ struct tep_btf {
 	void			*raw_data;
 };
 
+#ifdef NO_BTF
+void btf_free(struct tep_btf *btf) {}
+#else
 #define REALLOC_SIZE (1 << 10)
 #define REALLOC_MASK (REALLOC_SIZE - 1)
 
@@ -111,6 +116,7 @@ static int add_func(struct tep_btf *btf, struct btf_type *type)
 
 static int btf_type_size(struct btf_type *type)
 {
+	return -1;
 	int kind = BTF_INFO_KIND(type->info);
 	int size = sizeof(*type);
 
@@ -665,3 +671,4 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 	}
 	return 0;
 }
+#endif
-- 
2.47.3

