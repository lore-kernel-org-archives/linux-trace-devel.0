Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.158.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794220018;
	b=gtL4yUpcqqXyUtmdSs4sgGhtdVMuvBHtrU7/COQxMRxRhlRobu58jzuTVP1XM2Pg9HtW
	 vJFWaLO0upJSOr4nhaX7tYzGTjRltFgqcyvcANg0FvYT0l0ebDe2zx4m98+fAdCIWxlUd
	 19c1P7YnoMUnerXB0VREI4QTYrMLsJR+eR6qJDVGyrx8v+rK0zi/qot16Ovbj+dHILrhn
	 KV9XaDisO2nlvuDuBRh0nhof4LmSeE5PMvpz3tJLI5qikEHUvPx69lBQsRK7/evGxlh9j
	 KY7qRx+Bm+20H5dvxA5BqGKlnpq9Yb5dUWQziJm9ClYiJPvqbzMKKAvEHMHI+8UbV2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794220018;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=ML7PQQ94orp3PdX1iko+Fg7ycaqrATyxcY+8hmFtLo8=;
	b=V6QhEEYtLM7GFVaN69Huxto1ZO2MotifOi94E0DArs+zQUE8zJ3ccz2FWK83I2LLoJ+b
	 IP+KF4IRCRMgbi8/jmrSvRjYZTplkPt0jl4peVNDlW/LHXdXtQ0lNsqtezYx4VO/2tbRf
	 VNpTyF5kI9iOQj8l/9sZ0z+U7mP790gzYBp6TffnqbbBVBnIGUMsr4hD63/BlzA5tavDC
	 vw6+j5IJG6QzVmGmElN6yft9kqz/azxOVHsbwQfu+X347o9ZwrX86jDyO8do164THy+XP
	 sU8Z6yb6AV1LKiSE+kBjtFhIDYRF5uva1+mldLCB8M5GbjhVcTvAhboVazzBgwvlxOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=benettiengineering.com;
	spf=pass smtp.mailfrom=benettiengineering.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=hBC6lR5J;
	arc=none smtp.remote-ip=62.149.158.147
Received: from smtpweb147.aruba.it (smtpweb147.aruba.it [62.149.158.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1616D606A321
	for <linux-trace-devel@vger.kernel.org>; Mon,  9 Nov 2026 10:26:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1616D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=hBC6lR5J
Received: from localhost.localdomain ([151.95.84.63])
	by Aruba SMTP with ESMTPSA
	id QMaNxr6BsyeI3QMaOxL0CK; Mon, 09 Nov 2026 11:26:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1794220008; bh=3fkpiJsPXqeIFVQatgS2XXzGpGTe37Rde9XGBD3/LIs=;
	h=From:To:Subject:Date:MIME-Version;
	b=hBC6lR5JLmrv6kW4T7TnHAfQ6N9Brrm0PbmW6QgmYjOTpZtYRPpJLPMBxtUquM/Il
	 GjYIJr48V2s1DQuHQT40YT9C31/0NAGvBh8HBVkQK2XOxoZqDsGOAVhnXiDmgr/eLF
	 VjsuhQ6UY3dIot9O298zpDXElUtG6pW58pAgQRm1smNM73aUeA0q/CLM5LVFw12l/o
	 zCT7AnlUeXeHS2yrrZLi6vJOSn3pn0FcYFisXUaiMzU4zVrnJmF9QmDOdHly7ZOp8s
	 Ersf02bmI0KGRZszSQLmSO1nWrqSJJ+RojIIpK0WcPQ4lJwyzqABUkfPlZcyv7/lk0
	 01L1pFKLrZwMg==
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Giulio Benetti <giulio.benetti@benettiengineering.com>
Subject: [PATCH v4] libtraceevent: Fix build failure due to btf on Linux < 6.0
Date: Mon,  9 Nov 2026 11:26:47 +0100
Message-ID: <20261109102647.331565-1-giulio.benetti@benettiengineering.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107162956.3304797b@fedora>
References: <20261107162956.3304797b@fedora>
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
X-CMAE-Envelope: MS4xfN/JsH3qHobtI+pgipLFxNI5PX7SsSSvcQJncWrbJ1zPklFKcdlM24EWPqxW3Z2CdYKqZTm4rnzm0V6toEiuozUn4XsQnnMmvuCDPkkhU2jCh81wDg1C
 FjT+puai43gZZ9kDrmBOxNQrbt+BOGer5lc0VfmIf0y0qvzn9w0OaLqbmkUtgCsK+46ukcVPO5dmWemMjWuUyTxhSiYk0PMd3bjF067QPIDTxtuscQUN6D1S
 e1aWVliGbga85sVmhOKNa67zKETAPy28G6ce1TFtP+LBTLQqi6gQrbTyQL9Q/DZn4Wo0/s0uNd3ADdSOI4maXa0Q9IpcDXli56bquBzy2rU=

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
V3->V4:
* add "libtraceevent:" prefix to subject
* move #include <linux/btf.h> into the #else branch of #ifdef NO_BTF
* drop leftover debug code (tee /tmp/t.c and early return -1 in btf_type_size())
---
 Makefile        | 30 +++++++++++++++++++++++-------
 src/meson.build | 14 ++++++++++++++
 src/trace-btf.c |  8 ++++++--
 3 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 8a7a1dd..b7d9b25 100644
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
 
+test-build = $(if $(shell sh -c 'echo "$(1)" | \
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
index 2d66e01..2152f4c 100644
--- a/src/trace-btf.c
+++ b/src/trace-btf.c
@@ -8,8 +8,6 @@
 #include <stdlib.h>
 #include <stdbool.h>
 
-#include <linux/btf.h>
-
 #include "event-parse.h"
 #include "event-utils.h"
 #include "event-parse-local.h"
@@ -29,6 +27,11 @@ struct tep_btf {
 	void			*raw_data;
 };
 
+#ifdef NO_BTF
+void btf_free(struct tep_btf *btf) {}
+#else
+#include <linux/btf.h>
+
 #define REALLOC_SIZE (1 << 10)
 #define REALLOC_MASK (REALLOC_SIZE - 1)
 
@@ -665,3 +668,4 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 	}
 	return 0;
 }
+#endif
-- 
2.47.3

