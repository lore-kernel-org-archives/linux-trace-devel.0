Return-Path: <SRS0=PpJY=X3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A26EC35280
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Oct 2019 11:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0963421929
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Oct 2019 11:42:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QLpTM2VS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfJBLmE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Oct 2019 07:42:04 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:38883 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfJBLmE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Oct 2019 07:42:04 -0400
Received: by mail-wm1-f44.google.com with SMTP id 3so6646185wmi.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Oct 2019 04:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7jC/Qxisg2RgTzjcCIPAkCsLgEiCej9nREkzvpMcHGU=;
        b=QLpTM2VSKvlcX0EnLRwfZmopULUKoVQLt+Y2yhNSuS4oTw1IcfAAcFt6qOd2jfxeQl
         Y8t0sr6jSayiZf6Qo4HV2qzMSNtFGdnrKcTBtAoqgjivBHlnL7hOGkqVtpIFZ0QpY+7Y
         qJwSecokHnVusVCZfBqZh2TfDQL6yptxMMVYavsqbWul9yl5mq6dwlN1aP/CCMhg4/j0
         oh5Ahqta1+1Pk+Ck7fmk+VmCcWdLS7JO7rKuf1NK9WemUXhp6SrT5PQtX+gKXx/qoLiO
         stCOkY2JCuVtMFgofDM0GfsIN1Kw0FmklObDMJMwkAmp0TooVEdgP8VuB0tVHOi3TqdK
         HCXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7jC/Qxisg2RgTzjcCIPAkCsLgEiCej9nREkzvpMcHGU=;
        b=pmqsqnpm1r+5YOBDibIp8qeu06xp0OszxYpWlBhjdvm+zvZKtH5DjUFIIwwnZHIMDD
         hNOkOFmCYr2j5Ug9/3LW5VuqqrpjyMvYIGqGl0hNCJP+jGTrPNx/veqrndjNqLq6WLAa
         GAslrJP752trBMMkg92EDisIgJESdKEwBH+tXn0QN/mvi1Ods02SCE4CHuQUqwO3Awml
         mm43g9WNM1ffB7ToCmlsEUxX8RsUDMpcAFRpoQ0pNP0UzERvqBntrMeusz/3ntADcl46
         pvMLvWdiElnjrdBUwWm3/KiesHeCl9BSWJghn2W3MIp9doRO47mjrc6v9YZyJCesydTt
         dsYA==
X-Gm-Message-State: APjAAAXrGz5k2Jed349l+c7az8k5DnXkc1DpT7QbU5U0Q2PO+fg8MCCp
        SdtT59R/Os2naB99IbFFso6UvrSR
X-Google-Smtp-Source: APXvYqyS6Yrfe01byQi8cyrGd9frq3mS8c+v8hiUY8kpMBITq/EPHkXDzzrjpkhvlNjqEBh2LcvLkQ==
X-Received: by 2002:a1c:7d8e:: with SMTP id y136mr2457993wmc.83.1570016520230;
        Wed, 02 Oct 2019 04:42:00 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l4sm3004658wrw.6.2019.10.02.04.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 04:41:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 5/5] trace-cmd: Add initial infrastructure for trace-cmd specific plugins.
Date:   Wed,  2 Oct 2019 14:41:52 +0300
Message-Id: <20191002114152.30048-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002114152.30048-1-tz.stoyanov@gmail.com>
References: <20191002114152.30048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create a new directory lib/trace-cmd/plugins, where the libtracecmd
plugins will be placed. Plugins compilation is integrated in
the trace-cmd build process. New plugins are installed in
$(HOME)/.local/lib/trace-cmd/plugins or $(libdir)/trace-cmd/plugins directories.
Current python_plugin.so is part of libtraceevent plugins, so the python
plugins path is changed from
$(HOME)/.trace-cmd/python to $(HOME)/.local/lib/traceevent/python
and
$(libdir)/trace-cmd/python to $(libdir)/traceevent/python

Added initial set of APIs for working with trace-cmd plugins

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .gitignore                     |   2 +
 Makefile                       |  45 +++--
 include/trace-cmd/trace-cmd.h  |  44 ++++-
 lib/trace-cmd/Makefile         |   1 +
 lib/trace-cmd/plugins/Makefile |  58 ++++++
 lib/trace-cmd/trace-plugin.c   | 313 +++++++++++++++++++++++++++++++++
 6 files changed, 450 insertions(+), 13 deletions(-)
 create mode 100644 lib/trace-cmd/plugins/Makefile
 create mode 100644 lib/trace-cmd/trace-plugin.c

diff --git a/.gitignore b/.gitignore
index 20bb5a3..5a8800a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -20,3 +20,5 @@ TAGS
 cscope*
 traceevent_plugin_dir
 trace_python_dir
+tracecmd_plugin_dir
+python_dir
diff --git a/Makefile b/Makefile
index cb5b07b..dd7a84b 100644
--- a/Makefile
+++ b/Makefile
@@ -57,14 +57,18 @@ export DESTDIR DESTDIR_SQ
 
 ifeq ($(prefix),$(HOME))
 plugin_traceevent_dir = $(HOME)/.local/lib/traceevent/plugins
-python_dir = $(HOME)/.trace-cmd/python
+plugin_tracecmd_dir = $(HOME)/.local/lib/trace-cmd/plugins
+python_dir = $(HOME)/.local/lib/traceevent/python
 var_dir = $(HOME)/.trace-cmd/
 else
 plugin_traceevent_dir = $(libdir)/traceevent/plugins
-python_dir ?= $(libdir)/trace-cmd/python
+plugin_tracecmd_dir = $(libdir)/trace-cmd/plugins
+python_dir ?= $(libdir)/traceevent/python
 PLUGIN_DIR_TRACEEVENT = -DPLUGIN_TRACEEVENT_DIR="$(plugin_traceevent_dir)"
+PLUGIN_DIR_TRACECMD = -DPLUGIN_TRACECMD_DIR="$(plugin_tracecmd_dir)"
 PYTHON_DIR = -DPYTHON_DIR="$(python_dir)"
 PLUGIN_DIR_TRACEEVENT_SQ = '$(subst ','\'',$(PLUGIN_DIR_TRACEEVENT))'
+PLUGIN_DIR_TRACECMD_SQ = '$(subst ','\'',$(PLUGIN_DIR_TRACECMD))'
 PYTHON_DIR_SQ = '$(subst ','\'',$(PYTHON_DIR))'
 var_dir = /var
 endif
@@ -73,6 +77,7 @@ endif
 bindir_SQ = $(subst ','\'',$(bindir))
 bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
 plugin_traceevent_dir_SQ = $(subst ','\'',$(plugin_traceevent_dir))
+plugin_tracecmd_dir_SQ = $(subst ','\'',$(plugin_tracecmd_dir))
 python_dir_SQ = $(subst ','\'',$(python_dir))
 
 VAR_DIR = -DVAR_DIR="$(var_dir)"
@@ -86,9 +91,11 @@ HELP_DIR_SQ = '$(subst ','\'',$(HELP_DIR))'
 BASH_COMPLETE_DIR ?= /etc/bash_completion.d
 
 export PLUGIN_DIR_TRACEEVENT
+export PLUGIN_DIR_TRACECMD
 export PYTHON_DIR
 export PYTHON_DIR_SQ
 export plugin_traceevent_dir_SQ
+export plugin_tracecmd_dir_SQ
 export python_dir_SQ
 export var_dir
 
@@ -239,7 +246,8 @@ LIBS += -laudit
 endif
 
 # Append required CFLAGS
-override CFLAGS += $(INCLUDES) $(PLUGIN_DIR_TRACEEVENT_SQ) $(VAR_DIR)
+override CFLAGS += $(INCLUDES) $(VAR_DIR)
+override CFLAGS += $(PLUGIN_DIR_TRACEEVENT_SQ) $(PLUGIN_DIR_TRACECMD_SQ)
 override CFLAGS += $(udis86-flags) $(blk-flags)
 override LDFLAGS += $(udis86-ldflags)
 
@@ -268,13 +276,16 @@ gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 	@echo "gui build complete"
 	@echo "  kernelshark located at $(kshark-dir)/bin"
 
-trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC)
+trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC) \
+	force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
 
-$(LIBTRACEEVENT_SHARED): force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
+$(LIBTRACEEVENT_SHARED): force $(obj)/lib/traceevent/plugins/python_dir \
+			 $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
 
-$(LIBTRACEEVENT_STATIC): force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
+$(LIBTRACEEVENT_STATIC): force $(obj)/lib/traceevent/plugins/python_dir \
+			 $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
 
 $(LIBTRACECMD_STATIC): force
@@ -290,13 +301,22 @@ libtracecmd.so: $(LIBTRACECMD_SHARED)
 
 libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED)
 
-plugins: force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir $(obj)/lib/traceevent/plugins/trace_python_dir
+plugins_traceevent: force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir \
+		   $(obj)/lib/traceevent/plugins/python_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins
 
+plugins_tracecmd: force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
+	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/plugins
+
+plugins: plugins_traceevent plugins_tracecmd
+
 $(obj)/lib/traceevent/plugins/traceevent_plugin_dir: force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $@
 
-$(obj)/lib/traceevent/plugins/trace_python_dir: force
+$(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir: force
+	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/plugins $@
+
+$(obj)/lib/traceevent/plugins/python_dir: force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $@
 
 show_gui_make:
@@ -322,8 +342,12 @@ cscope: force
 	$(RM) cscope*
 	$(call find_tag_files) | cscope -b -q
 
-install_plugins: force
-	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $@
+install_plugins_traceevent: force
+	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins install_plugins
+install_plugins_tracecmd: force
+	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/plugins install_plugins
+
+install_plugins: install_plugins_traceevent install_plugins_tracecmd
 
 install_python: force
 	$(Q)$(MAKE) -C $(src)/python $@
@@ -371,6 +395,7 @@ clean:
 	$(MAKE) -C $(src)/lib/traceevent clean
 	$(MAKE) -C $(src)/lib/trace-cmd clean
 	$(MAKE) -C $(src)/lib/traceevent/plugins clean
+	$(MAKE) -C $(src)/lib/trace-cmd/plugins clean
 	$(MAKE) -C $(src)/python clean
 	$(MAKE) -C $(src)/tracecmd clean
 	if [ -f $(kshark-dir)/build/Makefile ]; then $(MAKE) -C $(kshark-dir)/build clean; fi
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 092bd89..6a182af 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -22,9 +22,6 @@ void tracecmd_parse_trace_clock(struct tep_handle *pevent, char *file, int size)
 void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent, char *file, unsigned int size);
 void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigned int size);
 
-extern int tracecmd_disable_sys_plugins;
-extern int tracecmd_disable_plugins;
-
 char **tracecmd_event_systems(const char *tracing_dir);
 char **tracecmd_system_events(const char *tracing_dir, const char *system);
 struct tep_handle *tracecmd_local_events(const char *tracing_dir);
@@ -53,6 +50,47 @@ struct tracecmd_output;
 struct tracecmd_recorder;
 struct hook_list;
 
+/* --- tracecmd plugins --- */
+
+extern int tracecmd_disable_sys_plugins;
+extern int tracecmd_disable_plugins;
+
+enum tracecmd_context {
+	TRACECMD_INPUT,
+	TRACECMD_OUTPUT,
+};
+
+enum tracecmd_plugin_flag {
+	TRACECMD_DISABLE_SYS_PLUGINS	= 1,
+	TRACECMD_DISABLE_PLUGINS	= 1 << 1,
+
+};
+
+struct trace_plugin_context;
+
+struct trace_plugin_context *
+tracecmd_plugin_context_create(enum tracecmd_context context, void *data);
+
+void tracecmd_plugin_set_flag(struct trace_plugin_context *context,
+			      enum tracecmd_plugin_flag flag);
+
+#define TRACECMD_PLUGIN_LOADER tracecmd_plugin_loader
+#define TRACECMD_PLUGIN_UNLOADER tracecmd_plugin_unloader
+#define TRACECMD_PLUGIN_ALIAS tracecmd_plugin_alias
+#define _MAKE_STR(x)	#x
+#define MAKE_STR(x)	_MAKE_STR(x)
+#define TRACECMD_PLUGIN_LOADER_NAME MAKE_STR(TRACECMD_PLUGIN_LOADER)
+#define TRACECMD_PLUGIN_UNLOADER_NAME MAKE_STR(TRACECMD_PLUGIN_UNLOADER)
+#define TRACECMD_PLUGIN_ALIAS_NAME MAKE_STR(TRACECMD_PLUGIN_ALIAS)
+
+typedef int (*tracecmd_plugin_load_func)(struct trace_plugin_context *trace);
+typedef int (*tracecmd_plugin_unload_func)(struct trace_plugin_context *trace);
+
+struct tracecmd_input *
+tracecmd_plugin_context_input(struct trace_plugin_context *trace_context);
+struct tracecmd_output *
+tracecmd_plugin_context_output(struct trace_plugin_context *trace_context);
+
 static inline int tracecmd_host_bigendian(void)
 {
 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 3b4b5aa..6f3e6b1 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -15,6 +15,7 @@ OBJS += trace-recorder.o
 OBJS += trace-util.o
 OBJS += trace-filter-hash.o
 OBJS += trace-msg.o
+OBJS += trace-plugin.o
 
 # Additional util objects
 OBJS += trace-blk-hack.o
diff --git a/lib/trace-cmd/plugins/Makefile b/lib/trace-cmd/plugins/Makefile
new file mode 100644
index 0000000..240e6be
--- /dev/null
+++ b/lib/trace-cmd/plugins/Makefile
@@ -0,0 +1,58 @@
+include $(src)/scripts/utils.mk
+
+bdir:=$(obj)/lib/trace-cmd/plugins
+
+PLUGIN_OBJS =
+
+PLUGIN_OBJS := $(PLUGIN_OBJS:%.o=$(bdir)/%.o)
+PLUGIN_BUILD := $(PLUGIN_OBJS:$(bdir)/%.o=$(bdir)/%.so)
+
+PLUGINS := $(PLUGIN_BUILD)
+
+DEPS := $(PLUGIN_OBJS:$(bdir)/%.o=$(bdir)/.%.d)
+
+all: $(PLUGINS)
+
+$(bdir):
+	@mkdir -p $(bdir)
+
+$(PLUGIN_OBJS): | $(bdir)
+$(DEPS): | $(bdir)
+
+$(PLUGIN_OBJS): $(bdir)/%.o : %.c
+	$(Q)$(do_compile_plugin_obj)
+
+$(PLUGIN_BUILD): $(bdir)/%.so: $(bdir)/%.o
+	$(Q)$(do_plugin_build)
+
+$(DEPS): $(bdir)/.%.d: %.c
+	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+
+$(PLUGIN_OBJS): $(bdir)/%.o : $(bdir)/.%.d
+
+PLUGINS_INSTALL = $(subst .so,.install,$(PLUGINS))
+
+$(PLUGINS_INSTALL): $(bdir)/%.install : $(bdir)/%.so force
+	$(Q)$(call do_install_data,$<,$(plugin_tracecmd_dir_SQ))
+
+install_plugins: $(PLUGINS_INSTALL)
+
+# The following targets are necessary to trigger a rebuild when
+# $(PLUGIN_DIR_TRACECMD) change. Without them, a full clean build would
+# necessary in order to get the binaries updated.
+
+$(bdir)/tracecmd_plugin_dir: $(bdir) force
+	$(Q)$(N)$(call update_dir, 'PLUGIN_DIR_TRACECMD=$(PLUGIN_DIR_TRACECMD)')
+
+dep_includes := $(wildcard $(DEPS))
+
+ifneq ($(dep_includes),)
+  include $(dep_includes)
+endif
+
+clean:
+	$(RM) -f $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d\
+		$(bdir)/tracecmd_plugin_dir
+
+force:
+.PHONY: clean force
diff --git a/lib/trace-cmd/trace-plugin.c b/lib/trace-cmd/trace-plugin.c
new file mode 100644
index 0000000..6bec18b
--- /dev/null
+++ b/lib/trace-cmd/trace-plugin.c
@@ -0,0 +1,313 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+#include <stdlib.h>
+#include <unistd.h>
+#include <dlfcn.h>
+#include <sys/stat.h>
+#include <libgen.h>
+#include "trace-cmd.h"
+#include "trace-local.h"
+
+#define LOCAL_PLUGIN_DIR ".local/lib/trace-cmd/plugins/"
+
+struct trace_plugin_list {
+	struct trace_plugin_list	*next;
+	char				*name;
+	void				*handle;
+};
+
+struct trace_plugin_context {
+	enum tracecmd_context context;
+	enum tracecmd_plugin_flag flags;
+	union {
+		void				*data;
+		struct tracecmd_input		*trace_input;
+		struct tracecmd_output		*trace_output;
+	};
+};
+
+/**
+ * tracecmd_plugin_context_create - Create and initialize tracecmd plugins context.
+ * @context: Context of the trace-cmd command.
+ * @data: Pointer to the context specific data, which will be passed to plugins.
+ *
+ * Returns a pointer to created tracecmd plugins context, or NULL in case memory
+ * allocation fails. The returned pointer should be freed by free ().
+ */
+struct trace_plugin_context *
+tracecmd_plugin_context_create(enum tracecmd_context context, void *data)
+{
+	struct trace_plugin_context *trace;
+
+	trace = calloc(1, sizeof(struct trace_plugin_context));
+	if (!trace)
+		return NULL;
+	trace->context = context;
+	trace->data = data;
+	return trace;
+}
+
+/**
+ * tracecmd_plugin_set_flag - Set a flag to tracecmd plugins context.
+ * @context: Context of the trace-cmd command.
+ * @flag: Flag, whil will be set.
+ *
+ */
+void tracecmd_plugin_set_flag(struct trace_plugin_context *context,
+			      enum tracecmd_plugin_flag flag)
+{
+	if (context)
+		context->flags |= flag;
+}
+
+/**
+ * tracecmd_plugin_context_input - Get a tracecmd_input plugin context.
+ * @context: Context of the trace-cmd command.
+ *
+ * Returns pointer to tracecmd_input, if such context is available or
+ * NULL otherwise.
+ */
+struct tracecmd_input *
+tracecmd_plugin_context_input(struct trace_plugin_context *context)
+{
+	if (!context || context->context != TRACECMD_INPUT)
+		return NULL;
+	return context->trace_input;
+}
+
+/**
+ * tracecmd_plugin_context_output - Get a tracecmd_output plugin context
+ * @context: Context of the trace-cmd command.
+ *
+ * Returns pointer to tracecmd_output, if such context is available or
+ * NULL otherwise.
+ */
+struct tracecmd_output *
+tracecmd_plugin_context_output(struct trace_plugin_context *context)
+{
+	if (!context || context->context != TRACECMD_OUTPUT)
+		return NULL;
+	return context->trace_output;
+}
+
+static void
+load_plugin(struct trace_plugin_context *trace, const char *path,
+	    const char *file, void *data)
+{
+	struct trace_plugin_list **plugin_list = data;
+	tracecmd_plugin_load_func func;
+	struct trace_plugin_list *list;
+	const char *alias;
+	char *plugin;
+	void *handle;
+	int ret;
+
+	ret = asprintf(&plugin, "%s/%s", path, file);
+	if (ret < 0) {
+		warning("could not allocate plugin memory\n");
+		return;
+	}
+
+	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);
+	if (!handle) {
+		warning("could not load plugin '%s'\n%s\n",
+			plugin, dlerror());
+		goto out_free;
+	}
+
+	alias = dlsym(handle, TRACECMD_PLUGIN_ALIAS_NAME);
+	if (!alias)
+		alias = file;
+
+	func = dlsym(handle, TRACECMD_PLUGIN_LOADER_NAME);
+	if (!func) {
+		warning("could not find func '%s' in plugin '%s'\n%s\n",
+			TRACECMD_PLUGIN_LOADER_NAME, plugin, dlerror());
+		goto out_free;
+	}
+
+	list = malloc(sizeof(*list));
+	if (!list) {
+		warning("could not allocate plugin memory\n");
+		goto out_free;
+	}
+
+	list->next = *plugin_list;
+	list->handle = handle;
+	list->name = plugin;
+	*plugin_list = list;
+
+	pr_stat("registering plugin: %s", plugin);
+	func(trace);
+	return;
+
+ out_free:
+	free(plugin);
+}
+
+static void
+load_plugins_dir(struct trace_plugin_context *trace, const char *suffix,
+		 const char *path,
+		 void (*load_plugin)(struct trace_plugin_context *trace,
+				     const char *path,
+				     const char *name,
+				     void *data),
+		 void *data)
+{
+	struct dirent *dent;
+	struct stat st;
+	DIR *dir;
+	int ret;
+
+	ret = stat(path, &st);
+	if (ret < 0)
+		return;
+
+	if (!S_ISDIR(st.st_mode))
+		return;
+
+	dir = opendir(path);
+	if (!dir)
+		return;
+
+	while ((dent = readdir(dir))) {
+		const char *name = dent->d_name;
+
+		if (strcmp(name, ".") == 0 ||
+		    strcmp(name, "..") == 0)
+			continue;
+
+		/* Only load plugins that end in suffix */
+		if (strcmp(name + (strlen(name) - strlen(suffix)), suffix) != 0)
+			continue;
+
+		load_plugin(trace, path, name, data);
+	}
+
+	closedir(dir);
+}
+
+static char *get_source_plugins_dir(void)
+{
+	char *p, path[PATH_MAX+1];
+	int ret;
+
+	ret = readlink("/proc/self/exe", path, PATH_MAX);
+	if (ret > PATH_MAX || ret < 0)
+		return NULL;
+
+	dirname(path);
+	p = strrchr(path, '/');
+	if (!p)
+		return NULL;
+	/* Check if we are in the the source tree */
+	if (strcmp(p, "/tracecmd") != 0)
+		return NULL;
+
+	strcpy(p, "/lib/trace-cmd/plugins");
+	return strdup(path);
+}
+
+static void
+load_plugins_hook(struct trace_plugin_context *trace, const char *suffix,
+		  void (*load_plugin)(struct trace_plugin_context *trace,
+				      const char *path,
+				      const char *name,
+				      void *data),
+		  void *data)
+{
+	char *home;
+	char *path;
+	char *envdir;
+	int ret;
+
+	if (trace && trace->flags & TRACECMD_DISABLE_PLUGINS)
+		return;
+
+	/*
+	 * If a system plugin directory was defined,
+	 * check that first.
+	 */
+#ifdef PLUGIN_TRACECMD_DIR
+	if (!trace || !(trace->flags & TRACECMD_DISABLE_SYS_PLUGINS))
+		load_plugins_dir(trace, suffix, PLUGIN_TRACECMD_DIR,
+				 load_plugin, data);
+#endif
+
+	/*
+	 * Next let the environment-set plugin directory
+	 * override the system defaults.
+	 */
+	envdir = getenv("TRACECMD_PLUGIN_DIR");
+	if (envdir)
+		load_plugins_dir(trace, suffix, envdir, load_plugin, data);
+
+	/*
+	 * Now let the home directory override the environment
+	 * or system defaults.
+	 */
+	home = getenv("HOME");
+	if (!home)
+		return;
+
+	ret = asprintf(&path, "%s/%s", home, LOCAL_PLUGIN_DIR);
+	if (ret < 0) {
+		warning("could not allocate plugin memory\n");
+		return;
+	}
+
+	load_plugins_dir(trace, suffix, path, load_plugin, data);
+
+	free(path);
+
+	path = get_source_plugins_dir();
+	if (path) {
+		load_plugins_dir(trace, suffix, path, load_plugin, data);
+		free(path);
+	}
+}
+
+/**
+ * tracecmd_load_plugins - Load trace-cmd specific plugins.
+ * @context: Context of the trace-cmd command, will be passed to the plugins
+ *	     at load time.
+ *
+ * Returns a list of loaded plugins
+ */
+struct trace_plugin_list*
+tracecmd_load_plugins(struct trace_plugin_context *trace)
+{
+	struct trace_plugin_list *list = NULL;
+
+	load_plugins_hook(trace, ".so", load_plugin, &list);
+	return list;
+}
+
+/**
+ * tracecmd_unload_plugins - Unload trace-cmd specific plugins.
+ * @plugin_list - List of plugins, previously loaded with tracecmd_load_plugins.
+ * @context: Context of the trace-cmd command, will be passed to the plugins
+ *	     at unload time.
+ *
+ */
+void
+tracecmd_unload_plugins(struct trace_plugin_list *plugin_list,
+			struct trace_plugin_context *trace)
+{
+	tracecmd_plugin_unload_func func;
+	struct trace_plugin_list *list;
+
+	while (plugin_list) {
+		list = plugin_list;
+		plugin_list = list->next;
+		func = dlsym(list->handle, TRACECMD_PLUGIN_UNLOADER_NAME);
+		if (func)
+			func(trace);
+		dlclose(list->handle);
+		free(list->name);
+		free(list);
+	}
+}
-- 
2.21.0

