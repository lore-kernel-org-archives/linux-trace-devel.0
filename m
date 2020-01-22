Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C41C33CAF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46DBC24673
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dDCM7L7W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgAVPAP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 10:00:15 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38088 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgAVPAO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 10:00:14 -0500
Received: by mail-lj1-f196.google.com with SMTP id w1so7170650ljh.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 07:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1xQUBg5WrZ2jESDNqyPC/7RGV6Ngua84tifpzpayVs8=;
        b=dDCM7L7W1WzxrOEimtoa8+jNiyhkUhNpXZnPUjQUHF0S2jDTKsfh/5Ofzs3XzlUZZX
         SsYyUE+/A2k3Iiooh+9kYSBIVhxa4CpUqFYdlFr3gca/3ck/+re2ICp5YTgvdNasvQ8+
         ZpueKTbEQEDp7Ru+/Q6y6YPwMU2mdfNONcCYR1BzqXHlM/jtQ//6rJ+6xE+W4+KayqCg
         uea5mnyxQZAFowZOhbCDlAyDDVvZbbsEIcB1iaqymX7a21SKa0qwOLdFePjh1Y8o/m24
         ThzSwPrZPDYsVaUnTGW0CEhpkVeVpPu8o28mrfcaOf7JVHQLpVUVYN6ugNxpfd1m06+8
         a0Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1xQUBg5WrZ2jESDNqyPC/7RGV6Ngua84tifpzpayVs8=;
        b=j7WrOcTNyfUGz1JOFu1Hn6Wj/RSNdQJDEzYPX1FzpsM2UvoirfnQmpgc1K5aThYNnb
         MXLYa04LEAqmNnLnyjAWEyetSHfcM4i9TXlw7fQS1hubpm6nfgsIKJzKXLD2mos6bqDh
         9y95xr/sgSrDRl37MPht/tff8Yfpps7vu/35Cm3uEiedpEqmONrMZ20jE5OMB7JTWeVg
         tasZEE48jRIVn2q2kE2x28XTlDF+A1r2Q7qHO6vgKMh30FSoqFknVqkgPDijdY05WWmX
         nu2hl45+u9wtM1re31XAUgFsBqJXijzLANjAlvwS+Ae11Zco/L3q79sfVXmh4B7jXl05
         3UmA==
X-Gm-Message-State: APjAAAVUHHwXtF5wnVWm+Yq/PIf9s3PzFvAQnHyuiCPRBcgvNxMa2wRa
        x20z6bDUZasK+Ojuzq9cfHTsqS56
X-Google-Smtp-Source: APXvYqx0KUIDUS9M5YFblbSulwheE7qiTo144uDYTZ1+1iAP9q5CNv0vw7ru+wCcIRK8JcYf8c/yvA==
X-Received: by 2002:a2e:b68c:: with SMTP id l12mr20191719ljo.36.1579705212974;
        Wed, 22 Jan 2020 07:00:12 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l7sm20722803lfc.80.2020.01.22.07.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 07:00:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 6/7] trace-cmd,libtraceevent: Remove API for plugin print
Date:   Wed, 22 Jan 2020 17:00:01 +0200
Message-Id: <20200122150002.763233-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122150002.763233-1-tz.stoyanov@gmail.com>
References: <20200122150002.763233-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The functionality for printing registered plugins
is moved from libtraceevent to the application.
A more generic walk API is introduced.

Removed
	tep_print_plugins()

Added
	tep_walk_plugins()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h |  8 ++++----
 lib/traceevent/event-plugin.c    | 23 +++++++++++------------
 tracecmd/trace-list.c            | 12 +++++++++---
 3 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 3b4f3a5..a64482d 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -362,6 +362,10 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 					       const char *name,
 					       void *data),
 			   void *data);
+void tep_walk_plugins(const struct tep_plugin_list *list,
+		      int (*callback)(char *plugin_file, void *context),
+		      void *context);
+
 int tep_plugin_add_options(const char *name,
 			   struct tep_plugin_option *options);
 int tep_plugin_add_option(const char *name, const char *val);
@@ -370,10 +374,6 @@ void tep_plugin_walk_options(int (*callback)(struct tep_plugin_option *op,
 					     void *context),
 			     void *context);
 
-void tep_print_plugins(struct trace_seq *s,
-			const char *prefix, const char *suffix,
-			const struct tep_plugin_list *list);
-
 /* tep_handle */
 typedef char *(tep_func_resolver_t)(void *priv,
 				    unsigned long long *addrp, char **modp);
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 191b27b..1ea02e6 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -338,22 +338,21 @@ void tep_plugin_walk_options(int (*callback)(struct tep_plugin_option *op,
 }
 
 /**
- * tep_print_plugins - print out the list of plugins loaded
- * @s: the trace_seq descripter to write to
- * @prefix: The prefix string to add before listing the option name
- * @suffix: The suffix string ot append after the option name
- * @list: The list of plugins (usually returned by tep_load_plugins()
+ * tep_walk_plugins - walk through all plugins from the list
+ * @list: plugin list, returned by tep_load_plugins()
+ * @callback: a user function, called on each plugin from the list
+ * @context: user data, passed to @callback function
  *
- * Writes to the trace_seq @s the list of plugins (files) that is
- * returned by tep_load_plugins(). Use @prefix and @suffix for formating:
- * @prefix = "  ", @suffix = "\n".
+ * If the @callback returns non zero, the iteration stops.
  */
-void tep_print_plugins(struct trace_seq *s,
-		       const char *prefix, const char *suffix,
-		       const struct tep_plugin_list *list)
+void tep_walk_plugins(const struct tep_plugin_list *list,
+		      int (*callback)(char *plugin_file, void *context),
+		      void *context)
 {
+	if (!list || !callback)
+		return;
 	while (list) {
-		trace_seq_printf(s, "%s%s%s", prefix, list->name, suffix);
+		callback(list->name, context);
 		list = list->next;
 	}
 }
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 496a83b..f7bef45 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -373,6 +373,14 @@ void trace_option(int argc, char **argv)
 	show_plugin_options();
 }
 
+static int plugins_walk(char *plugin_file, void *context)
+{
+	struct trace_seq *s = (struct trace_seq *)context;
+
+	if (plugin_file)
+		trace_seq_printf(s, "  %s\n", plugin_file);
+	return 0;
+}
 
 static void show_plugins(void)
 {
@@ -387,14 +395,12 @@ static void show_plugins(void)
 	trace_seq_init(&s);
 
 	list = trace_load_plugins(pevent);
-	tep_print_plugins(&s, "  ", "\n", list);
-
+	tep_walk_plugins(list, plugins_walk, &s);
 	trace_seq_do_printf(&s);
 	tep_unload_plugins(list, pevent);
 	tep_free(pevent);
 }
 
-
 void trace_list(int argc, char **argv)
 {
 	int events = 0;
-- 
2.24.1

