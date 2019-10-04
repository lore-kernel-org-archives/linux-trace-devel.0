Return-Path: <SRS0=JRVv=X5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA63C47404
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 13:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EE1B222C0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 13:37:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VsB6rL6G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388197AbfJDNhC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:37:02 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:45568 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388333AbfJDNhB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Oct 2019 09:37:01 -0400
Received: by mail-wr1-f52.google.com with SMTP id r5so7196098wrm.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Oct 2019 06:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QkfLSyXFPZJXluLNkve4m5RmMQ8kWYbgpv/uGqbviBU=;
        b=VsB6rL6GcldV2+9BXnNWthm1LzeKLsycWSs80J7cMB+EiKUB9VpepzHe3wiHzmF5ei
         4osQrCSeE+kR3GcHaXjt7dlbkdxSWANd2/UIvTN+RRgFUULMqSIzfJHbCzorSNanJYPT
         xl6FOJg/daluuENwf7OW1g6Ph4DhQV/NbOzStnFj6uGosbHhg1h6Yxk3Xar26o+w3MxL
         4ptJ+M7s0A7br/6Ude1xEtC+/IFzeLXGTy4DxwZoPcdWNjhtuESNq18KA+OWmHMsXLo/
         ypRGwQ8Fh06GGdiHqY9MEO87aFAbxWaUiSnvO+NnipM6Vdzk6iApMmlGNGnuAj9aQq+4
         9LYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QkfLSyXFPZJXluLNkve4m5RmMQ8kWYbgpv/uGqbviBU=;
        b=PaUZs/GhanAQPHEgMDFPJeSYCrcHa2XUUiWf0butMol+6+eh/jyYUS0wBP8tWNpyXM
         kTR4B2VgVJypR93qnI/ZB2ZNi+XVifgEi+iIGXB9mUHa67uB+MtI3pR2skMYFtSReX6J
         D3jxe8kFhzkLKK0WGWj+iVicNf4nDRW5atQ2vDbMioWe8XeNl+SUqnB9Dk5X9FxXSXzt
         +jOaWO9sq042s/gU9KG+aZN7x6JroNBNYT91ri5w0yw73jBwbWN+UoM2ByUoWvt0Z7ib
         vlS13nAypPqwQ1Jpu95V4CKl5H5GP8okux8HDXjY76O3SMbS/jW/xDN8xLpJQQs5YXe7
         jmpg==
X-Gm-Message-State: APjAAAX+eo1ZMWipDbeT6i92/IWkU9y0gCErSVVgHbEb1bUYelDv2GHW
        Ht+iA/NDmtUXuEoH/7Rn+J4=
X-Google-Smtp-Source: APXvYqyIaARv/xblhhLkgMIezbBjqaxXKZhA06GUgC/ojonvAAAkbXUsorOdqIKGiWvZ98XoGMBq2w==
X-Received: by 2002:adf:ea0d:: with SMTP id q13mr1395524wrm.111.1570196216653;
        Fri, 04 Oct 2019 06:36:56 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a10sm7029988wrm.52.2019.10.04.06.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 06:36:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 5/5] trace-cmd: Add initial infrastructure for trace-cmd specific plugins.
Date:   Fri,  4 Oct 2019 16:36:47 +0300
Message-Id: <20191004133647.27759-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191004133647.27759-1-tz.stoyanov@gmail.com>
References: <20191004133647.27759-1-tz.stoyanov@gmail.com>
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

Added an initial set of APIs for working with trace-cmd plugins.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .gitignore                     |   1 +
 Makefile                       |  43 ++++-
 include/trace-cmd/trace-cmd.h  |  41 +++++
 lib/trace-cmd/Makefile         |   1 +
 lib/trace-cmd/plugins/Makefile |  58 ++++++
 lib/trace-cmd/trace-plugin.c   | 313 +++++++++++++++++++++++++++++++++
 6 files changed, 448 insertions(+), 9 deletions(-)
 create mode 100644 lib/trace-cmd/plugins/Makefile
 create mode 100644 lib/trace-cmd/trace-plugin.c

diff --git a/.gitignore b/.gitignore
index 20bb5a3..6759e51 100644
--- a/.gitignore
+++ b/.gitignore
@@ -20,3 +20,4 @@ TAGS
 cscope*
 traceevent_plugin_dir
 trace_python_dir
+tracecmd_plugin_dir
diff --git a/Makefile b/Makefile
index cb5b07b..078b642 100644
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
+$(LIBTRACEEVENT_SHARED): force $(obj)/lib/traceevent/plugins/trace_python_dir \
+			 $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
 
-$(LIBTRACEEVENT_STATIC): force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
+$(LIBTRACEEVENT_STATIC): force $(obj)/lib/traceevent/plugins/trace_python_dir \
+			 $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
 
 $(LIBTRACECMD_STATIC): force
@@ -290,12 +301,21 @@ libtracecmd.so: $(LIBTRACECMD_SHARED)
 
 libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED)
 
-plugins: force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir $(obj)/lib/traceevent/plugins/trace_python_dir
+plugins_traceevent: force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir \
+		   $(obj)/lib/traceevent/plugins/trace_python_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins
 
+plugins_tracecmd: force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
+	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/plugins
+
+plugins: plugins_traceevent plugins_tracecmd
+
 $(obj)/lib/traceevent/plugins/traceevent_plugin_dir: force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $@
 
+$(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir: force
+	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/plugins $@
+
 $(obj)/lib/traceevent/plugins/trace_python_dir: force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $@
 
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
index 0593463..f3d80ac 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -55,6 +55,47 @@ struct tracecmd_output;
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

