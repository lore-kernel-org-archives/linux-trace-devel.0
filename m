Received: from smtpdh18-1.aruba.it (smtpdh18-1.aruba.it [62.149.155.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CB337B013
	for <linux-trace-devel@vger.kernel.org>; Thu, 12 Mar 2026 20:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347954; cv=none; b=D0kKVUeS1UO365mE+BpQ5fr35w98TpRgA7NuvOm9fMBCL738W32l/k+iMngZYEVNiI6F/bY7rN/0wwm2fIQ4mIRRof1m1KbqVu81tIFQBGoA5iGw7m3IZqGGEZGgP2wFvnmuJlX6HKj90z3uSmAaC5iU6tkgozBqwUv/yUoHvHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347954; c=relaxed/simple;
	bh=u5KMHmyUQxR1Z6q61Hwtq9f0MZ5lWpDyAHWmkrvkL2M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N4cAW7qSNbjGFwgiD+gGD6pKhjpmxpEUFY4loLf7Jx4qh1uXjMpShfvGWSKAp+r7aFPF/fvHBmGLLsBRBzHcjFAE+i059oaTLPjWSz+w9/q4aWIsoMmAnfwMAlhsRp3GQG2gRIxDs5bHU6xmmqXBfEBaqb0Cgbb4ef8Pi2u0Qi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com; spf=pass smtp.mailfrom=benettiengineering.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=Wh0Ah/rb; arc=none smtp.client-ip=62.149.155.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="Wh0Ah/rb"
Received: from localhost.localdomain ([84.33.84.190])
	by Aruba SMTP with ESMTPSA
	id 0mlGwvAaA5Ste0mlHw9crn; Thu, 12 Mar 2026 21:36:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1773347763; bh=u5KMHmyUQxR1Z6q61Hwtq9f0MZ5lWpDyAHWmkrvkL2M=;
	h=From:To:Subject:Date:MIME-Version;
	b=Wh0Ah/rbKIapJOAWpET+2RL+PUW3XMQ4sP6sD38SkjLSzJ8VQTfvCxyDknRnv39ah
	 S7d83unzESRDNjao4UhZm0jB7A1tfSY53LvayyC453JdJqy7iEZB85R0wfdfIzhbPr
	 tWMTXZORw9iRaMdkA2No5YRxDV2WJxU7BDOD+nva8AkTwifg09iO9EZTCCl+Vpa1Ds
	 1EdFKP+DDInxFyDLZ4zknNMxETcHJVxORhEPqrY40BRAUqPKkx3z2LYRNpSv7LK35O
	 toJhg8BLj357JqWHa3PINOYC5uO0/A7u4TQU6dK5+Qlo/Rgyk38/s+INFwYrrI+2vs
	 HV8PJ+oQ3ELkg==
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Giulio Benetti <giulio.benetti@benettiengineering.com>
Subject: [PATCH v2] Fix build failure due to btf on Linux < 6.0
Date: Thu, 12 Mar 2026 21:36:01 +0100
Message-ID: <20260312203601.3088494-1-giulio.benetti@benettiengineering.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfIgybXafw3L18wlwPymJbw8Vz/10VWuMNirU9j+9Vnz6ElE2P0LvOw7yKFpfSJb1DVWivaQWoEywssxe3iJxM3DOAEkSQEKZZ7r5JOvZcm+ya6eyR4dp
 azVGjj9DWsbrxq4TXGeXK8dsaGoGr6qrdxT4YDtpFFyhsHejS7p04Xsw2PHg4YIL2Gax0wqyib19r+LoFwNHKxu205Hy6uoZNaEkBm9N/Xqzul9Dziy2xMXx
 P9r2X/loyawdNEJaasBGCQBUbh8jGm/KaeoPeaUKlm81BZggwAfVgfLTge19r5jqSdJLy85zKxPCJnUaeyaXkDPgGfcEyeUvOu4LGS6seUs=

With commit:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6089fb325cf737eeb2c4d236c94697112ca860da
enum BTF_KIND_ENUM64 has been firstly introduced and this is the latest
BTF_KIND_* enumaration to be added to libtraceevent. So let's check
in runtime, both in Makefile and meson, if BTF_KIND_ENUM64 does exist.
If it's not there let's disable btf support.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Co-authored-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
---
V1->V2:
* fixed meson check and all bft C source
---
 Makefile        | 28 +++++++++++++++++++++-------
 src/meson.build | 12 ++++++++++++
 src/trace-btf.c | 31 +++++++++++++++++++++++++++++--
 3 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index e1a10a0..bd88a98 100644
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
 
@@ -37,6 +44,20 @@ INSTALL = install
 DESTDIR ?=
 DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
 
+test-build = $(if $(shell sh -c 'echo "$(1)" | tee /tmp/t.c| \
+	$(CC) -o /dev/null -x c - > /dev/null 2>&1 && echo y'), $2)
+
+define BTF_LATEST_SOURCE
+#include <linux/btf.h>
+int main(void) { return BTF_KIND_ENUM64; }
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
@@ -123,13 +144,6 @@ INCLUDES = -I. -I $(srctree)/include -I $(EP_HEADERS_DIR) $(CONFIG_INCLUDES)
 
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
index 3a7a082..2432dd8 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -17,6 +17,18 @@ sources= [
 cc = meson.get_compiler('c')
 dl_dep = cc.find_library('dl')
 
+btf_enum64_test_code = '''
+#include <linux/btf.h>
+int main(void) {
+    int x = BTF_KIND_ENUM64;
+    return 0;
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
index 859b086..52e933c 100644
--- a/src/trace-btf.c
+++ b/src/trace-btf.c
@@ -8,12 +8,13 @@
 #include <stdlib.h>
 #include <stdbool.h>
 
-#include <linux/btf.h>
-
 #include "event-parse.h"
 #include "event-utils.h"
 #include "event-parse-local.h"
 
+#ifndef NO_BTF
+#include <linux/btf.h>
+
 struct btf_header;
 struct btf_type;
 
@@ -210,17 +211,24 @@ static int load_types(struct tep_btf *btf)
 	qsort_r(btf->funcs, btf->nr_funcs, sizeof(btf->funcs[0]), cmp_funcs, btf);
 	return 0;
 }
+#endif
 
 __hidden void btf_free(struct tep_btf *btf)
 {
+#ifdef NO_BTF
+	tep_warning("BTF not supported.\n");
+	return;
+#else
 	if (!btf)
 		return;
 
 	free(btf->types);
 	free(btf->funcs);
 	free(btf->raw_data);
+#endif
 }
 
+#ifndef NO_BTF
 static struct tep_btf *btf_init(void *raw_data, size_t data_size)
 {
 	struct tep_btf *btf;
@@ -271,6 +279,7 @@ static struct tep_btf *btf_init(void *raw_data, size_t data_size)
 	btf_free(btf);
 	return NULL;
 }
+#endif
 
 /**
  * tep_load_btf - Load BTF information into a tep handle
@@ -285,6 +294,10 @@ static struct tep_btf *btf_init(void *raw_data, size_t data_size)
  */
 int tep_load_btf(struct tep_handle *tep, void *raw_data, size_t data_size)
 {
+#ifdef NO_BTF
+	tep_warning("BTF not supported.\n");
+	return -1;
+#else
 	/* If btf was already loaded, free it */
 	btf_free(tep->btf);
 
@@ -292,8 +305,10 @@ int tep_load_btf(struct tep_handle *tep, void *raw_data, size_t data_size)
 	if (!tep->btf)
 		return -1;
 	return 0;
+#endif
 }
 
+#ifndef NO_BTF
 static struct btf_type *btf_get_type(struct tep_btf *btf, int id)
 {
 	if (!id || id > btf->nr_types)
@@ -457,6 +472,7 @@ static int init_btf_func(struct tep_btf *btf, struct trace_seq *s,
 
 	return 0;
 }
+#endif
 
 /**
  * tep_btf_list_args - List the arguments (type and name) for a function
@@ -471,6 +487,10 @@ static int init_btf_func(struct tep_btf *btf, struct trace_seq *s,
  */
 int tep_btf_list_args(struct tep_handle *tep, struct trace_seq *s, const char *func)
 {
+#ifdef NO_BTF
+	tep_warning("BTF not supported.\n");
+	return -1;
+#else
 	struct tep_btf *btf = tep->btf;
 	struct btf_type *type = tep_btf_find_func(btf, func);
 	struct btf_param *param;
@@ -520,6 +540,7 @@ int tep_btf_list_args(struct tep_handle *tep, struct trace_seq *s, const char *f
 			trace_seq_printf(s, "%s", param_name);
 	}
 	return p;
+#endif
 }
 
 /**
@@ -543,6 +564,11 @@ int tep_btf_list_args(struct tep_handle *tep, struct trace_seq *s, const char *f
 int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 		       int nmem, int size, const char *func)
 {
+#ifdef NO_BTF
+	tep_warning("BTF not supported. Args:\n"
+		    "args: %08x, nmem: %d, size: %d, func: %08x\n");
+	return -1;
+#else
 	struct tep_btf *btf = tep->btf;
 	struct btf_type *type = tep_btf_find_func(btf, func);
 	struct btf_param *param;
@@ -646,4 +672,5 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 		}
 	}
 	return 0;
+#endif
 }
-- 
2.47.3

