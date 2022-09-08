Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C4DC54EE9
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Sep 2022 22:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiIHWIF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 18:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIHWIF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 18:08:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9072CE42E0
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 15:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45849B82280
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 22:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2C3C433D6
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 22:08:00 +0000 (UTC)
Date:   Thu, 8 Sep 2022 18:07:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracevent: Have kvm_exit/enter be able to show guest
 function
Message-ID: <20220908180758.50c94238@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add two weak functions tep_plugin_kvm_get_func() and
tep_plugin_kvm_put_func() to allow applications that are processing both
the host data as well as the guest data, and knows how to map the exit IP
address from the guest to an actual function name of the guest.

Instead of showing:

  kvm_exit:     reason EPT_VIOLATION rip 0xffffffffc01b1f39 info 181 0

show:

  kvm_exit:     reason EPT_VIOLATION rip 0xffffffffc01b1f39 ipt_do_table+0xe9 info 181 0

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceevent/event-parse.h | 29 +++++++++++++
 plugins/plugin_kvm.c             | 74 +++++++++++++++++++++++++++++---
 2 files changed, 98 insertions(+), 5 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 0b911e1caa7c..474586930bae 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -778,4 +778,33 @@ void tep_set_loglevel(enum tep_loglevel level);
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
 
+
+/*
+ * Part of the KVM plugin. Will pass the current @event and @record
+ * as well as a pointer to the address to a guest kernel function.
+ * This is currently a weak function defined in the KVM plugin and
+ * should never be called. But a tool can override it, and this will
+ * be called when the kvm plugin has an address it needs the function
+ * name of.
+ *
+ * This function should return the function name for the given address
+ * and optionally, it can update @paddr to include the start of the function
+ * such that the kvm plugin can include an offset.
+ *
+ * For an application to be able to override the weak version in the
+ * plugin, it must be compiled with the gcc -rdynamic option that will
+ * allow the dynamic linker to use the application's function to
+ * override this callback.
+ */
+const char *tep_plugin_kvm_get_func(struct tep_event *event,
+				    struct tep_record *record,
+				    unsigned long long *paddr);
+
+/*
+ * tep_plugin_kvm_put_func() is another weak function that can be used
+ * to call back into the application if the function name returned by
+ * tep_plugin_kvm_get_func() needs to be freed.
+ */
+void tep_plugin_kvm_put_func(const char *func);
+
 #endif /* _PARSE_EVENTS_H */
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index 51ceeb9147eb..9852c35f4901 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -10,6 +10,8 @@
 #include "event-parse.h"
 #include "trace-seq.h"
 
+#define __weak __attribute__((weak))
+
 #ifdef HAVE_UDIS86
 
 #include <udis86.h>
@@ -273,15 +275,49 @@ static int print_exit_reason(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
+__weak const char *tep_plugin_kvm_get_func(struct tep_event *event,
+					   struct tep_record *record,
+					   unsigned long long *val)
+{
+	return NULL;
+}
+
+__weak void tep_plugin_kvm_put_func(const char *func)
+{
+}
+
+
+static void add_rip_function(struct trace_seq *s, struct tep_record *record,
+			     struct tep_event *event, unsigned long long rip)
+{
+	unsigned long long ip = rip;
+	const char *func;
+
+	func = tep_plugin_kvm_get_func(event, record, &ip);
+	if (func) {
+		trace_seq_printf(s, " %s", func);
+		/* The application may upate ip to the start of the function */
+		if (ip != rip)
+			trace_seq_printf(s, "+0x%0llx", rip - ip);
+		tep_plugin_kvm_put_func(func);
+	}
+}
+
 static int kvm_exit_handler(struct trace_seq *s, struct tep_record *record,
 			    struct tep_event *event, void *context)
 {
 	unsigned long long info1 = 0, info2 = 0;
+	unsigned long long rip;
 
 	if (print_exit_reason(s, record, event, "exit_reason") < 0)
 		return -1;
 
-	tep_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1);
+	if (tep_get_field_val(s, event, "guest_rip", record, &rip, 1) < 0)
+		return -1;
+
+	trace_seq_printf(s, " rip 0x%llx", rip);
+
+	add_rip_function(s, record, event, rip);
 
 	if (tep_get_field_val(s, event, "info1", record, &info1, 0) >= 0
 	    && tep_get_field_val(s, event, "info2", record, &info2, 0) >= 0)
@@ -290,6 +326,22 @@ static int kvm_exit_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
+static int kvm_entry_handler(struct trace_seq *s, struct tep_record *record,
+			    struct tep_event *event, void *context)
+{
+	unsigned long long rip;
+
+	tep_print_num_field(s, " vcpu %u", event, "vcpu_id", record, 1);
+
+	if (tep_get_field_val(s, event, "rip", record, &rip, 1) < 0)
+		return -1;
+
+	trace_seq_printf(s, " rip 0x%llx", rip);
+	add_rip_function(s, record, event, rip);
+
+	return 0;
+}
+
 #define KVM_EMUL_INSN_F_CR0_PE (1 << 0)
 #define KVM_EMUL_INSN_F_EFL_VM (1 << 1)
 #define KVM_EMUL_INSN_F_CS_D   (1 << 2)
@@ -329,12 +381,12 @@ static int kvm_emulate_insn_handler(struct trace_seq *s,
 			     flags & KVM_EMUL_INSN_F_CS_D,
 			     flags & KVM_EMUL_INSN_F_CS_L);
 
-	trace_seq_printf(s, "%llx:%llx: %s%s", csbase, rip, disasm,
-			 failed ? " FAIL" : "");
+	trace_seq_printf(s, "%llx:%llx", csbase, rip);
+	add_rip_function(s, record, event, rip);
+	trace_seq_printf(s, ": %s%s", disasm, failed ? " FAIL" : "");
 	return 0;
 }
 
-
 static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct tep_record *record,
 					    struct tep_event *event, void *context)
 {
@@ -352,7 +404,13 @@ static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct tep_reco
 static int kvm_nested_vmexit_handler(struct trace_seq *s, struct tep_record *record,
 				     struct tep_event *event, void *context)
 {
-	tep_print_num_field(s, "rip %llx ", event, "rip", record, 1);
+	unsigned long long rip;
+
+	if (tep_get_field_val(s, event, "rip", record, &rip, 1) < 0)
+		return -1;
+
+	trace_seq_printf(s, " rip %llx", rip);
+	add_rip_function(s, record, event, rip);
 
 	return kvm_nested_vmexit_inject_handler(s, record, event, context);
 }
@@ -456,6 +514,9 @@ int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 	tep_register_event_handler(tep, -1, "kvm", "kvm_exit",
 				   kvm_exit_handler, NULL);
 
+	tep_register_event_handler(tep, -1, "kvm", "kvm_entry",
+				   kvm_entry_handler, NULL);
+
 	tep_register_event_handler(tep, -1, "kvm", "kvm_emulate_insn",
 				   kvm_emulate_insn_handler, NULL);
 
@@ -496,6 +557,9 @@ void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 	tep_unregister_event_handler(tep, -1, "kvm", "kvm_exit",
 				     kvm_exit_handler, NULL);
 
+	tep_unregister_event_handler(tep, -1, "kvm", "kvm_entry",
+				     kvm_entry_handler, NULL);
+
 	tep_unregister_event_handler(tep, -1, "kvm", "kvm_emulate_insn",
 				     kvm_emulate_insn_handler, NULL);
 
-- 
2.35.1

