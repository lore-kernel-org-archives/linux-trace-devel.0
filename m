Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD6EFC433E1
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9061720702
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:49:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QYIpNg3w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgGBRt5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 13:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgGBRt4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 13:49:56 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F29C08C5C1
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Jul 2020 10:49:56 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id w3so16803763wmi.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Jul 2020 10:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IAJGrIiwrGdPe5uu6UlxZxveQSOvY5WVqqNsVFw3e7c=;
        b=QYIpNg3whzBhQYa/eXSfsjapiMqJkdw06Uc/4n39ykRUQblAWWp6E5Kf22ZYjvkU46
         iEUqvkBC0rmeCn0edA35BCyH3f3RkZzY9TYcper/ojhHBw+VkDxgan1pxn53QP8JM9sn
         Ax+uDFuRL6M1zR5OlaTsVZUk4prdsxUo9Yux3rth5vulJV8GJDoxI3mbMSacBF0uhefj
         2d1HhXwUI90cpfccYMtABvABCKfw1W6YjXR/r3mT56sHPt367aVNN6CY7EIXg2jqn5U2
         smqbg3UTod6UNpOzNLrOI3dvDl81wYA267/8dz+rnmEy02XNNC967aBuZoFv9eOEKxJK
         pFRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IAJGrIiwrGdPe5uu6UlxZxveQSOvY5WVqqNsVFw3e7c=;
        b=qAa/OgYkbPiS2oj8JycK7gU7wHd7k2AhpkjQFs0IFEKJVOU+JTkBE3gJEsXb4P6qfX
         9QxY76utHYLFLiQKoC1NyYxJKFXochXfUyvt/sIV+g8P2oXo7vcE4wbKxsPmvfkxxt0R
         JTWTdj0JZIxqLqot5Fqb65JdLe+VrPzyMMjFE3GwSbEf9NN4Dz+WAqfpF37BuB4Sxw9r
         La5b9UW7nkAKhC3vPEOy68GjbmcbR37JSzUPQLyb4KsMvP6CMuNgc1PsKn5+6KrJseL+
         1nw6HoKMhzXKNoG8Sv3/qbAIj2NwEiE2yEq1tTYuB97ez7ygn1Zir684xFxtxPa5xi90
         5qmg==
X-Gm-Message-State: AOAM5334JMpCDYBzDme0pG2rVTWpza+mAbQ+cBuc1IceEHlRt2+p46oJ
        lW/SJOD5p/NWgLKev0JbIQE=
X-Google-Smtp-Source: ABdhPJyMqEZogM8sCCM+NBDQjV6X6nTJjomOw3sW/fbF0nklO46VQOFVxQ76d1bDPYg8CciiUBnVZA==
X-Received: by 2002:a7b:c3d0:: with SMTP id t16mr35526793wmj.117.1593712195123;
        Thu, 02 Jul 2020 10:49:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g82sm9289319wma.37.2020.07.02.10.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:49:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 10/15] tools lib traceevent: Add -O offset for function plugin
Date:   Thu,  2 Jul 2020 20:49:45 +0300
Message-Id: <20200702174950.123454-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702174950.123454-1-tz.stoyanov@gmail.com>
References: <20200702174950.123454-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

When -O offset is added to trace-cmd report with the function plugin
enabled, it will display the offset of the functions along with their names.
This helps in finding exactly where a function was called by its parent.

 trace-cmd report -O parent -O offset
[..]
        rcuc/163-1330  [163]   740.653251: function: _raw_spin_lock+0x0  <-- rcu_cpu_kthread+0x4d8

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../lib/traceevent/plugins/plugin_function.c  | 24 +++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/plugins/plugin_function.c b/tools/lib/traceevent/plugins/plugin_function.c
index 7770fcb78e0f..cafddd6be983 100644
--- a/tools/lib/traceevent/plugins/plugin_function.c
+++ b/tools/lib/traceevent/plugins/plugin_function.c
@@ -49,6 +49,13 @@ struct tep_plugin_option plugin_options[] =
 		"Try to show function call indents, based on parents",
 		.set = 1,
 	},
+	{
+		.name = "offset",
+		.plugin_alias = "ftrace",
+		.description =
+		"Show function names as well as their offsets",
+		.set = 0,
+	},
 	{
 		.name = NULL,
 	}
@@ -56,6 +63,7 @@ struct tep_plugin_option plugin_options[] =
 
 static struct tep_plugin_option *ftrace_parent = &plugin_options[0];
 static struct tep_plugin_option *ftrace_indent = &plugin_options[1];
+static struct tep_plugin_option *ftrace_offset = &plugin_options[2];
 
 static void add_child(struct func_stack *stack, const char *child, int pos)
 {
@@ -123,6 +131,18 @@ static int add_and_get_index(const char *parent, const char *child, int cpu)
 	return 0;
 }
 
+static void show_function(struct trace_seq *s, struct tep_handle *tep,
+			  const char *func, unsigned long long function)
+{
+	unsigned long long offset;
+
+	trace_seq_printf(s, "%s", func);
+	if (ftrace_offset->set) {
+		offset = tep_find_function_address(tep, function);
+		trace_seq_printf(s, "+0x%x ", (int)(function - offset));
+	}
+}
+
 static int function_handler(struct trace_seq *s, struct tep_record *record,
 			    struct tep_event *event, void *context)
 {
@@ -149,14 +169,14 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	trace_seq_printf(s, "%*s", index*3, "");
 
 	if (func)
-		trace_seq_printf(s, "%s", func);
+		show_function(s, tep, func, function);
 	else
 		trace_seq_printf(s, "0x%llx", function);
 
 	if (ftrace_parent->set) {
 		trace_seq_printf(s, " <-- ");
 		if (parent)
-			trace_seq_printf(s, "%s", parent);
+			show_function(s, tep, parent, pfunction);
 		else
 			trace_seq_printf(s, "0x%llx", pfunction);
 	}
-- 
2.26.2

