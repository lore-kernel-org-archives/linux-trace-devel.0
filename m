Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353082D9484
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Feb 2026 20:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770236396; cv=none; b=V6Tp3L0ibFtDZ1ZUFtyWIzQFL7e5SMNG/uTNKPixH4AVx0ReKAC9eNWH2uE9Wk/9EedJYL6DLJMCOFxsNPYG/hn8GdAXfc+8wdOFJt24MofV+6D+f/YecX/CMe4jyqAhq/Tyl3yS9uugLj+G2Qz8zQCY7FauvYRDOpjlb3WmK/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770236396; c=relaxed/simple;
	bh=zOmGAgpIgBpuNLOISgv5p+Vtn6Hrn49KF19XOx7LoD4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=a/we2A5EF0zZf2nzKOlQM40OVgBR59DzAInE7YrRAtMOAJXH0wvnO5fSTDwUtaHbDQTDPN+HfXD49zCOf2WnWk99OJTM7bG5ygQOPRjA66MCI7d4UN9ooP/ks9F14sz83r/HHiw0LvozSKs5ZwhrUr6i8KJWKBBBIBZAVBeUXCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BD6FC1688
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Feb 2026 20:19:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id E3DDE2000D
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Feb 2026 20:19:53 +0000 (UTC)
Date: Wed, 4 Feb 2026 15:20:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Make the minimum libtraceevent version 1.9
Message-ID: <20260204152026.3d491b55@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: E3DDE2000D
X-Stat-Signature: egzttgpsefa344sa4mp8szmff8e6s4mw
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+lecEspgvHsyc6BTOMul0AJJEIOKVKE2Q=
X-HE-Tag: 1770236393-295443
X-HE-Meta: U2FsdGVkX18P9BJyEq0wxQx4K5v8Mq+n/zXoUhfP6N6Gu/JO14obharlhcmw+ztY/om4gfPGTRw8Og6quqc/KFaRWEorWSSdGm5mpfWcvt9S+VyD8aQgoc3cshJXZKExZ3zDJW2dQrvtITa+DHbNlSejDdj/5oPNulYetOHcYYj8QRCYITb8Uf45Ze9LhQI1ZTCGip+jkOtb2OD3qNz6Ca9ndoimcxp28iOJn7/gNQif5Fu2Y7ssMyH7EDfVErz2Bg1eW7l/zS69HvBAN3+L9/PkpC2W+q4uilXnH12xBFhJiL0PU9i5DbKAKdK9p/77rFiwNhbk80aK4SflBEd4lO5jd8oUw7VE2kJs+Ly9TMaes4TMihRZWbU+whoXKpaq

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Have libtraceevent minimum version be 1.9 and remove checks to use BTF
parsing, as 1.9 now has that.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile                     | 11 +----------
 lib/trace-cmd/trace-ftrace.c | 15 ---------------
 lib/trace-cmd/trace-input.c  |  7 -------
 meson.build                  |  5 +----
 tracecmd/trace-list.c        | 20 +-------------------
 5 files changed, 3 insertions(+), 55 deletions(-)

diff --git a/Makefile b/Makefile
index aea6a1aae111..c3707ae19d83 100644
--- a/Makefile
+++ b/Makefile
@@ -22,7 +22,7 @@ export LIBTRACECMD_VERSION
 
 VERSION_FILE = ltc_version.h
 
-LIBTRACEEVENT_MIN_VERSION = 1.5
+LIBTRACEEVENT_MIN_VERSION = 1.9
 LIBTRACEFS_MIN_VERSION = 1.8
 
 MAKEFLAGS += --no-print-directory
@@ -230,8 +230,6 @@ LIBTRACEFS=libtracefs
 TEST_LIBTRACEEVENT := $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEEVENT_MIN_VERSION) $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y")
 TEST_LIBTRACEFS := $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEFS_MIN_VERSION) $(LIBTRACEFS) > /dev/null 2>&1 && echo y")
 
-TEST_LIBTRACEEVENT_BTF := $(shell sh -c "$(PKG_CONFIG) --atleast-version 1.9 $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y")
-
 ifeq ("$(TEST_LIBTRACEEVENT)", "y")
 LIBTRACEEVENT_CFLAGS := $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT)")
 LIBTRACEEVENT_LDLAGS := $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEEVENT)")
@@ -249,13 +247,6 @@ warning:
 	@echo "********************************************"
 endif
 
-ifeq ("$(TEST_LIBTRACEEVENT_BTF)", "y")
-CFLAGS += -DHAVE_KERNEL_BTF
-else
-.PHONY: warning
-$(info    Min version libtraceevent 1.9 not found. Will not use BTF for function args)
-endif
-
 export LIBTRACEEVENT_CFLAGS LIBTRACEEVENT_LDLAGS
 
 ifeq ("$(TEST_LIBTRACEFS)", "y")
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index c874113bc66e..53c958653c28 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -220,22 +220,7 @@ static bool print_args(struct trace_seq *s, struct tep_event *event,
 
 	args = record->data + field->offset;
 
-#ifdef HAVE_KERNEL_BTF
 	tep_btf_print_args(event->tep, s, args, len, long_size, func);
-#else
-	for (int i = 0; i < len; i++) {
-		void *arg;
-
-		if (i)
-			trace_seq_puts(s, ", ");
-
-		arg = args + i * long_size;
-		if (long_size == 4)
-			trace_seq_printf(s, "%x", *(unsigned int *)arg);
-		else
-			trace_seq_printf(s, "%llx", *(unsigned long long *)arg);
-	}
-#endif
 
 	return true;
 }
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 22990430f14b..0fa9d9564bd7 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1026,7 +1026,6 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 	return 0;
 }
 
-#ifdef HAVE_KERNEL_BTF
 static int read_btf(struct tracecmd_input *handle)
 {
 	void *raw_data;
@@ -1041,12 +1040,6 @@ static int read_btf(struct tracecmd_input *handle)
 	free(raw_data);
 	return 0;
 }
-#else
-static inline int read_btf(struct tracecmd_input *handle)
-{
-	return 0;
-}
-#endif
 
 static int read_modules(struct tracecmd_input *handle)
 {
diff --git a/meson.build b/meson.build
index c86d1a6b7f0b..67d4681da471 100644
--- a/meson.build
+++ b/meson.build
@@ -24,12 +24,9 @@ htmldir = join_paths(prefixdir, get_option('htmldir'))
 
 conf = configuration_data()
 
-libtraceevent_dep = dependency('libtraceevent', version: '>= 1.5.0', required: true)
-libtraceevent_btf_dep = dependency('libtraceevent', version: '>= 1.9', required: false)
+libtraceevent_dep = dependency('libtraceevent', version: '>= 1.9.0', required: true)
 libtracefs_dep = dependency('libtracefs', version: '>= 1.8.0', required: true)
 
-conf.set('HAVE_KERNEL_BTF', libtraceevent_btf_dep.found(), description: 'Is BTF parsing available?')
-
 threads_dep = dependency('threads', required: true)
 dl_dep = cc.find_library('dl', required : false)
 
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 50b6a1d99ea9..da2604ed1b2e 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -476,7 +476,6 @@ static void show_clocks(void)
 	free(clocks);
 }
 
-#ifdef HAVE_KERNEL_BTF
 static struct tep_handle *load_btf(void)
 {
 	struct tep_handle *tep;
@@ -520,23 +519,6 @@ static struct tep_handle *load_btf(void)
 	return tep;
 }
 
-static int btf_list_args(struct tep_handle *tep, struct trace_seq *s,
-			 const char *func)
-{
-	return tep_btf_list_args(tep, s, func);
-}
-#else
-static inline struct tep_handle *load_btf(void)
-{
-	return NULL;
-}
-static int btf_list_args(struct tep_handle *tep, struct trace_seq *s,
-			 const char *func)
-{
-	return 0;
-}
-#endif
-
 static void show_functions(const char *funcre, int params)
 {
 	struct tep_handle *tep = NULL;
@@ -585,7 +567,7 @@ static void show_functions(const char *funcre, int params)
 		printf("%s", list[i]);
 		if (params) {
 			trace_seq_reset(&s);
-			if (btf_list_args(tep, &s, list[i]) >= 0) {
+			if (tep_btf_list_args(tep, &s, list[i]) >= 0) {
 				printf("(");
 				trace_seq_do_printf(&s);
 				printf(")");
-- 
2.51.0

