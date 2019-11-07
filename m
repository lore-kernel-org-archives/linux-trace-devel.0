Return-Path: <SRS0=IVdt=Y7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B192C5DF60
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Nov 2019 11:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E46D21882
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Nov 2019 11:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfKGLfj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Nov 2019 06:35:39 -0500
Received: from foss.arm.com ([217.140.110.172]:54578 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfKGLfj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Nov 2019 06:35:39 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9F247CD;
        Thu,  7 Nov 2019 03:35:38 -0800 (PST)
Received: from e120877-lin.cambridge.arm.com (unknown [10.1.195.69])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2999C3F6C4;
        Thu,  7 Nov 2019 03:35:38 -0800 (PST)
From:   vincent.donnefort@arm.com
To:     linux-trace-devel@vger.kernel.org
Cc:     Vincent Donnefort <vincent.donnefort@arm.com>
Subject: [PATCH] trace-cmd: Add support for built-in plugins
Date:   Thu,  7 Nov 2019 11:35:32 +0000
Message-Id: <1573126532-373130-1-git-send-email-vincent.donnefort@arm.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

When building trace-cmd with the -static option, plugins might not work, if
the shared version for the Glibc is not available on the system. To still
give a chance to have plugins, a new built-in mechanism is introduced.

The built-in build support for a plugin can be easily enabled with the
declaration:

 TEP_PLUGIN(plugin_name)
 {
         plugin_init()
 }

 /* optional */
 TEP_PLUGIN(plugin_name)
 {
         plugin_exit()
 }

Enabling as a first step, blk and sched_switch plugins as built-in.

Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>

diff --git a/Makefile b/Makefile
index 48d88e7..4376907 100644
--- a/Makefile
+++ b/Makefile
@@ -277,7 +277,7 @@ gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 	@echo "gui build complete"
 	@echo "  kernelshark located at $(kshark-dir)/bin"
 
-trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC)
+trace-cmd: force plugins_builtin $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC)
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
 
 $(LIBTRACEEVENT_SHARED): force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
@@ -308,6 +308,14 @@ $(obj)/lib/traceevent/plugins/traceevent_plugin_dir: force
 $(obj)/lib/traceevent/plugins/trace_python_dir: force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $@
 
+ifneq (,$(is_static_build))
+export USE_BUILTIN_PLUGINS=1
+override CFLAGS += -DUSE_BUILTIN_PLUGINS
+plugins_builtin: plugins
+endif
+
+PHONY += plugins_builtin
+
 show_gui_make:
 	@echo "Note: to build the gui, type \"make gui\""
 	@echo "      to build man pages, type \"make doc\""
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index a77af4c..58277d3 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -65,6 +65,11 @@ struct tep_plugin_option {
 	int				set;
 };
 
+struct tep_plugin_builtin {
+	char *name;
+	int (*init)(struct tep_handle *tep);
+};
+
 /*
  * Plugin hooks that can be called:
  *
@@ -116,6 +121,26 @@ struct tep_plugin_option {
 #define TEP_PLUGIN_OPTIONS_NAME MAKE_STR(TEP_PLUGIN_OPTIONS)
 #define TEP_PLUGIN_ALIAS_NAME MAKE_STR(TEP_PLUGIN_ALIAS)
 
+#ifdef USE_BUILTIN_PLUGINS
+extern const struct tep_plugin_builtin __start_builtin_plugins[];
+extern const struct tep_plugin_builtin __stop_builtin_plugins[];
+
+#define TEP_PLUGIN(plugin)						\
+	int plugin##_init(struct tep_handle *pevent);			\
+	static struct tep_plugin_builtin __builtin_plugin_##plugin	\
+	__attribute__((unused))						\
+	__attribute__((__section__("builtin_plugins"))) = {		\
+		.name = "builtin:"#plugin,				\
+		.init = plugin##_init,					\
+	};								\
+	int plugin##_init(struct tep_handle *tep)
+#define TEP_PLUGIN_EXIT(plugin) \
+	void plugin##_exit(struct tep_handle *tep)
+#else
+#define TEP_PLUGIN(x) int TEP_PLUGIN_LOADER(struct tep_handle *tep)
+#define TEP_PLUGIN_EXIT(x) void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
+#endif
+
 enum tep_format_flags {
 	TEP_FIELD_IS_ARRAY	= 1,
 	TEP_FIELD_IS_POINTER	= 2,
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 6ea4ac0..6cd6aa7 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -590,12 +590,44 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 	free(path);
 }
 
+#ifdef USE_BUILTIN_PLUGINS
+static void tep_load_builtin_plugins(struct tep_handle *tep,
+				     struct tep_plugin_list **list)
+{
+	const struct tep_plugin_builtin *plugin;
+	struct tep_plugin_list *l;
+	int ret;
+
+	for (plugin = __start_builtin_plugins; plugin < __stop_builtin_plugins;
+	     plugin++) {
+		ret = plugin->init(tep);
+		pr_stat("built-in plugin \"%s\" registration: %s\n",
+			plugin->name, ret ? "Fail" : "Success");
+		if (ret)
+			continue;
+
+		l = malloc(sizeof(*l));
+		if (l) {
+			l->next = *list;
+			l->handle = NULL;
+			l->name = plugin->name;
+			*list = l;
+		}
+	}
+}
+#else
+void tep_load_builtin_plugins(struct tep_handle *tep,
+			      struct tep_plugin_list **list)
+{}
+#endif
+
 struct tep_plugin_list*
 tep_load_plugins(struct tep_handle *tep)
 {
 	struct tep_plugin_list *list = NULL;
 
 	tep_load_plugins_hook(tep, ".so", load_plugin, &list);
+	tep_load_builtin_plugins(tep, &list);
 	return list;
 }
 
@@ -608,11 +640,15 @@ tep_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *tep)
 	while (plugin_list) {
 		list = plugin_list;
 		plugin_list = list->next;
-		func = dlsym(list->handle, TEP_PLUGIN_UNLOADER_NAME);
-		if (func)
-			func(tep);
-		dlclose(list->handle);
-		free(list->name);
+
+		/* !handle == builtin plugin */
+		if (list->handle) {
+			func = dlsym(list->handle, TEP_PLUGIN_UNLOADER_NAME);
+			if (func)
+				func(tep);
+			dlclose(list->handle);
+			free(list->name);
+		}
 		free(list);
 	}
 }
diff --git a/lib/traceevent/plugins/Makefile b/lib/traceevent/plugins/Makefile
index 4050019..1bc6298 100644
--- a/lib/traceevent/plugins/Makefile
+++ b/lib/traceevent/plugins/Makefile
@@ -25,7 +25,11 @@ PLUGINS += $(bdir)/plugin_python_loader.so
 endif
 DEPS := $(PLUGIN_OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
+ifndef USE_BUILTIN_PLUGINS
 all: $(PLUGINS)
+else
+all: $(PLUGIN_OBJS)
+endif
 
 $(bdir):
 	@mkdir -p $(bdir)
diff --git a/lib/traceevent/plugins/plugin_blk.c b/lib/traceevent/plugins/plugin_blk.c
index ea3a9cf..df9dd80 100644
--- a/lib/traceevent/plugins/plugin_blk.c
+++ b/lib/traceevent/plugins/plugin_blk.c
@@ -363,9 +363,9 @@ static int blktrace_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+TEP_PLUGIN(blk)
 {
-	tep_register_event_handler(pevent, -1, "ftrace", "blktrace",
+	tep_register_event_handler(tep, -1, "ftrace", "blktrace",
 				   blktrace_handler, NULL);
 	return 0;
 }
diff --git a/lib/traceevent/plugins/plugin_sched_switch.c b/lib/traceevent/plugins/plugin_sched_switch.c
index 566f166..7b645fb 100644
--- a/lib/traceevent/plugins/plugin_sched_switch.c
+++ b/lib/traceevent/plugins/plugin_sched_switch.c
@@ -118,7 +118,7 @@ static int sched_switch_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *tep)
+TEP_PLUGIN(sched_switch)
 {
 	tep_register_event_handler(tep, -1, "sched", "sched_switch",
 				   sched_switch_handler, NULL);
@@ -132,7 +132,7 @@ int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
+TEP_PLUGIN_EXIT(sched_switch)
 {
 	tep_unregister_event_handler(tep, -1, "sched", "sched_switch",
 				     sched_switch_handler, NULL);
diff --git a/scripts/utils.mk b/scripts/utils.mk
index d1d5135..d03315b 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -79,6 +79,16 @@ do_python_plugin_build =			\
 	($(print_plugin_build)			\
 	$(CC) $< -shared $(LDFLAGS) $(PYTHON_LDFLAGS) -o $@)
 
+builtin_plugins = \
+	$(foreach plugin,$(wildcard $(src)/lib/traceevent/plugins/*.o),$(is_builtin_plugin))
+
+is_builtin_plugin = \
+	$(shell $(CROSS_COMPILE)objdump -h -j builtin_plugins $(plugin) \
+		>/dev/null 2>&1 && echo $(plugin))
+
+is_static_build = \
+	$(findstring -static,$(LDFLAGS))
+
 define make_version.h
 	(echo '/* This file is automatically generated. Do not modify. */';		\
 	echo \#define VERSION_CODE $(shell						\
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 29a623b..7fa3974 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -62,7 +62,7 @@ $(all_objs): | $(bdir)
 $(bdir)/trace-cmd: $(ALL_OBJS)
 	$(Q)$(do_app_build)
 
-$(bdir)/trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
+$(bdir)/trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC) $(builtin_plugins)
 
 $(bdir)/%.o: %.c
 	$(Q)$(call do_compile)
-- 
2.7.4

