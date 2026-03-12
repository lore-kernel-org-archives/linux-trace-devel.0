Received: from smtpcmd0986.aruba.it (smtpcmd0986.aruba.it [62.149.156.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE99401A0F
	for <linux-trace-devel@vger.kernel.org>; Thu, 12 Mar 2026 20:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345647; cv=none; b=umuLlBNUfxo0SnWiqwstx8ATjVwwinet0Xd2eYxRzYzlGkM/tlBi3jjsjkTKJIGDyGIGXexwZT/hU761DHUgjNjHY+hmYX1Jv6QB5BrJxenna1m9T7mrmv0X3nB5thkw7I4IHZILdxJrxmtvEkJNvMb5LgYMA8Zodv7pYfZAAH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345647; c=relaxed/simple;
	bh=i1NuYTCLiCGr9hIRwxbDxKhVGG2kdlA/xKfnthWCskA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SWTcI/lPgYJlN4nmMY9rZf6e0GRau3O47StzkDzfFFPAw33/Odds03rJB7ISahvHdlw6378tNjYAU6nx4zkB9SjxVyHBeYxA2cUtMPEs8mjDLsP2tDunZKMyM/qLtedYtZBgRl/3Cr7S0yuMIr+Ym451+PP5pbjcpgteUnxkcMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com; spf=pass smtp.mailfrom=benettiengineering.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=AZKiJB7+; arc=none smtp.client-ip=62.149.156.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="AZKiJB7+"
Received: from localhost.localdomain ([84.33.84.190])
	by Aruba SMTP with ESMTPSA
	id 0mA2wjEm94bDk0mA2w4c0E; Thu, 12 Mar 2026 20:57:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1773345455; bh=i1NuYTCLiCGr9hIRwxbDxKhVGG2kdlA/xKfnthWCskA=;
	h=From:To:Subject:Date:MIME-Version;
	b=AZKiJB7+Vteo69zph38eWuKA8TtXxwUSHYlwpgDw06G4Ag9MzDGotyQC1QEa25dMQ
	 ILztH7LO+VxLvS1+2OLBlMIO7eZH6d4NLD32bV044BE7BfCjfzFb8Gwwgp086RRghg
	 Nijqw/YImivRsn/b/6yFxfG3D68TMfYGgXKCKeZabo6WJ7vd6Y36Sb6GF14xQlEjca
	 3X+eufRFRFwnFvzsBMnJRaTHrm8qlmFkxf3iQuo2qcGNnjahe1yEuHjuh+xC2zreUb
	 mp78EgjedLHmmlMINgQ3NoaOtnr397zOGMheGUSPPB25xqF8XSkUaWCezVZmPKoKQl
	 5kkCrLIZvRpZA==
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Giulio Benetti <giulio.benetti@benettiengineering.com>
Subject: [PATCH] Fix build failure due to btf on Linux < 6.0
Date: Thu, 12 Mar 2026 20:57:33 +0100
Message-ID: <20260312195733.3034533-1-giulio.benetti@benettiengineering.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfIURB02S0X7pPRuLm++rA7Xr4RMtrgHtH3ps9b+RkFVD+CiFcZydo7iF7UmMp1p1k2Rfh/11yViK7a/hvUgm/emL3nclV9LlD2ab59QMGvporlcrPyOo
 GkMl5yMuQhpUJzOsQ2QtIBFcYiqiKY4r0vAu2AMC8IefzlmJEqK7vy4WpvbpumP1wUYfW20cQRjXD57o+NlHageD/jhtwuzT1aXarA2mmkJ4+6R4/wZsuF33
 9I3Ni6cFgf/fSysfImnfHAmcB1j0Bgak1OAHBwZmONo2clWX+Pc8V08zJ1rnqL49T8sR2JEvOg5gaDzofOmKUZEE0ZmiKibDNOGnnlO0Iu0=

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
 Makefile        | 28 +++++++++++++++++++++-------
 src/meson.build | 12 ++++++++++++
 src/trace-btf.c | 10 ++++++++++
 3 files changed, 43 insertions(+), 7 deletions(-)

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
index 3a7a082..23b43ff 100644
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
+if cc.compiles(btf_enum64_test_code, name : 'BTF_KIND_ENUM64 check')
+    add_project_arguments('-DNO_BTF', language : 'c')
+endif
+
 libtraceevent = library(
     'traceevent',
     sources,
diff --git a/src/trace-btf.c b/src/trace-btf.c
index 859b086..4e3a853 100644
--- a/src/trace-btf.c
+++ b/src/trace-btf.c
@@ -471,6 +471,9 @@ static int init_btf_func(struct tep_btf *btf, struct trace_seq *s,
  */
 int tep_btf_list_args(struct tep_handle *tep, struct trace_seq *s, const char *func)
 {
+#ifdef NO_BTF
+	return -1;
+#else
 	struct tep_btf *btf = tep->btf;
 	struct btf_type *type = tep_btf_find_func(btf, func);
 	struct btf_param *param;
@@ -520,6 +523,7 @@ int tep_btf_list_args(struct tep_handle *tep, struct trace_seq *s, const char *f
 			trace_seq_printf(s, "%s", param_name);
 	}
 	return p;
+#endif
 }
 
 /**
@@ -543,6 +547,11 @@ int tep_btf_list_args(struct tep_handle *tep, struct trace_seq *s, const char *f
 int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 		       int nmem, int size, const char *func)
 {
+#ifdef NO_BTF
+	tep_warning("BTF not supported. Args:\n
+		    args: %08x, nmem: %d, size: %d, func: %08x\n");
+	return -1;
+#else
 	struct tep_btf *btf = tep->btf;
 	struct btf_type *type = tep_btf_find_func(btf, func);
 	struct btf_param *param;
@@ -646,4 +655,5 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 		}
 	}
 	return 0;
+#endif
 }
-- 
2.47.3

