Return-Path: <SRS0=DRQG=3U=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F275C35240
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27192214D8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D9q8NeVf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgAaMLS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 07:11:18 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38030 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728461AbgAaMLS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 07:11:18 -0500
Received: by mail-lf1-f65.google.com with SMTP id r14so4715256lfm.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 31 Jan 2020 04:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eIDzky6AzQtjwsJRaNkotSmjavofw+44dUh0Jag6RzU=;
        b=D9q8NeVfCDxfLZ1/vOYMsmVteEqzZvduaBfVscqbeZe1/itLfkDHfqMhvOrgK9rVoh
         3o6ALyNaC/uHIH12VbGpcDj4BGou8JOkIGzYUupNuZ9yQps1aY1A9AbN/ZgwZjqXyhv6
         VqWWz3CBATiXb/MIPfEA9pLipBsHBoGs8CmgPhza0WGAAGg3+cjUjw7PSLnih/WnmPuW
         p0BXsYp27vC9mzu1m3IDpwp6Xc62yEuc8nz0T7QCWgEr6J9bxFcgh3KPr0amewrDYp1E
         yjrvDMXpezKprtjBxytjmYA0YFFSzr3MdEBTD4iNVDgh21gy1OL8Ojq1zYAB6JE8TW/c
         bYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eIDzky6AzQtjwsJRaNkotSmjavofw+44dUh0Jag6RzU=;
        b=XOybojveG+atoGHJzCXXrP+pDwrm0/ee4MOmKFM40L4hIxKvrG8aenOhfRv/NagKms
         rY5OA82I6mHutrHqrbRIdv+XpYUfW20CMZu5rMRWWx6MpXktgRhC7PUvF/IBhfsN8Jk+
         YMyO2Mk53UL7Iz/c/gjK93XpNrd9FVv7web4UIaHHeJUa7FGhZVs3v6uHtGobekIYjv1
         HL2a0YCzQLAVkrcIZvJbQ6qIMPMhwYLelaZ1rkzyS+tWKzF+G6fasO/bkV4zF6bh9OCr
         KjBuSXJvI9BifA83DWpqdz9VPeJZpS6zdY14MkO5b5tk1+nTv5epKOpRPi3hFAJ5/tVj
         a1SA==
X-Gm-Message-State: APjAAAXiVvgj77SfFq5qQ0TfntKIzDZX4NxqbRuie0wDdYzWcprmb50p
        bbZIYh10xiArJ4eeU0DGiYO1SKszxo0=
X-Google-Smtp-Source: APXvYqwx28KQ3gaUeNndFustnPLuzngzWdCVqFlf4MQ0sIJH2HWP/TEp7AxeVYk+akwIs7qDxClyZw==
X-Received: by 2002:a19:f811:: with SMTP id a17mr5309413lff.182.1580472676031;
        Fri, 31 Jan 2020 04:11:16 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i19sm4559965lfj.17.2020.01.31.04.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:11:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v19 01/15] trace-cmd: Add support for negative time offsets in trace.dat file
Date:   Fri, 31 Jan 2020 14:10:57 +0200
Message-Id: <20200131121111.130355-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131121111.130355-1-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

When synchronizing timestamps between different machines, there are cases
when the time offset is negative. This patch changes the way time offset is
written and read from trace.dat file - as signed decimal, instead of hex.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h | 2 +-
 lib/trace-cmd/trace-input.c   | 6 +++---
 tracecmd/trace-read.c         | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index a243c25..6763715 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -161,7 +161,7 @@ const char *tracecmd_buffer_instance_name(struct tracecmd_input *handle, int ind
 struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx);
 int tracecmd_is_buffer_instance(struct tracecmd_input *handle);
 
-void tracecmd_set_ts_offset(struct tracecmd_input *handle, unsigned long long offset);
+void tracecmd_set_ts_offset(struct tracecmd_input *handle, long long offset);
 void tracecmd_set_ts2secs(struct tracecmd_input *handle, unsigned long long hz);
 
 void tracecmd_print_events(struct tracecmd_input *handle, const char *regex);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a402f68..842a4c3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -93,7 +93,7 @@ struct tracecmd_input {
 	bool			read_page;
 	bool			use_pipe;
 	struct cpu_data 	*cpu_data;
-	unsigned long long	ts_offset;
+	long long		ts_offset;
 	double			ts2secs;
 	char *			cpustats;
 	char *			uname;
@@ -2036,7 +2036,7 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
 }
 
 void tracecmd_set_ts_offset(struct tracecmd_input *handle,
-			    unsigned long long offset)
+			    long long offset)
 {
 	handle->ts_offset = offset;
 }
@@ -2215,7 +2215,7 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
 
 static int handle_options(struct tracecmd_input *handle)
 {
-	unsigned long long offset;
+	long long offset;
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 8c2b2ae..c184c62 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -58,7 +58,7 @@ static struct list_head handle_list;
 struct input_files {
 	struct list_head	list;
 	const char		*file;
-	unsigned long long	tsoffset;
+	long long		tsoffset;
 	unsigned long long	ts2secs;
 };
 static struct list_head input_files;
@@ -1466,7 +1466,7 @@ void trace_report (int argc, char **argv)
 	struct input_files *inputs;
 	struct handle_list *handles;
 	enum output_type otype;
-	unsigned long long tsoffset = 0;
+	long long tsoffset = 0;
 	unsigned long long ts2secs = 0;
 	unsigned long long ts2sc;
 	int show_stat = 0;
-- 
2.24.1

