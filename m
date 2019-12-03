Return-Path: <SRS0=Ozv+=ZZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1354EC432C3
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE5902073B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I1ZzpfB8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfLCKfa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 05:35:30 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43903 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfLCKfa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 05:35:30 -0500
Received: by mail-lj1-f195.google.com with SMTP id a13so3145122ljm.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Dec 2019 02:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2UB+7TyCvOxtXN0b6w3H+2SysAGSr92bcpZfqsJmkPw=;
        b=I1ZzpfB83cTeq8pttGslT9FhnihpTTkkEvMB4+2A8hnvsgUcVBxrjaojQQiJCcnWM7
         5mY/Stpr82tK3X+GuG6g5PTnlUVrLbc0E6SEUCbbsavqK0ufSAqPqr/7xapr9MQNmVRK
         u7p+HOrMQEy4XO0lWqcOyBovOJmX44lyqwiDMgCKKXj0T7oBRyAvvTVBQfOEx+LsiD1B
         weVd6clEHtqmotQpNdvBjr2xQFGAKbkOXgTSkl4eeOVg5kyIyafxhw/bkKV8OsQmOYJg
         jSQKe8HRJMmujtXU2oqjCrAdjM6u9k7H0yX+P3Cy95RJeCOwsCxOv+wkSkgtBLr/KU1e
         9n3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2UB+7TyCvOxtXN0b6w3H+2SysAGSr92bcpZfqsJmkPw=;
        b=cVpmajaEiLsBB/dRl3cWBnL1w34W7+tBuRrbNc89/SFAGy8gdSgUh1Knlrh9I9Q3M2
         nUVV8xVHvLmMqjOMYGMBWvPjl1uC+NtvMw/oboXB85mId/N/MZ6MFlSrH+SHPKmpOZnc
         RS3gFWWOhtZPgAWIyqogFOEvSQqlST+EVkdetgm1VXgHsERLj8QTei47k7Dg+nHrVPPf
         Izz6IWBzn8a7u7hN+MQmYrEOOxPzjD52sNS/z0+cRFclhaMTMwlDaZWOuz03FPzhEeu4
         NXMprtFc8MDgxxkN0n7PFVYufjNHbxeLBC+lwrMQXzEOodgSe47FU2CccWlThpdW8I87
         QhiA==
X-Gm-Message-State: APjAAAUus6q4hQok3OEa8PCHOH+XHVhi+rIi8WEBl2rjXlcygKiICebI
        QP6rj9qV11F8wg6xGJFOutK6HfU1X0k=
X-Google-Smtp-Source: APXvYqxGRuvabwsugNJkz44iYqu76AzHXC67F3A71YpEYh/VnHvVSZ+FVa+Par/QdivLWuNwk/MikA==
X-Received: by 2002:a2e:8953:: with SMTP id b19mr1903890ljk.249.1575369328711;
        Tue, 03 Dec 2019 02:35:28 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t9sm1053023lfl.51.2019.12.03.02.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 02:35:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v17 02/18] trace-cmd: Add support for negative time offsets in trace.dat file
Date:   Tue,  3 Dec 2019 12:35:06 +0200
Message-Id: <20191203103522.482684-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191203103522.482684-1-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
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
index 9363a26..7f9cb73 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -138,7 +138,7 @@ const char *tracecmd_buffer_instance_name(struct tracecmd_input *handle, int ind
 struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx);
 int tracecmd_is_buffer_instance(struct tracecmd_input *handle);
 
-void tracecmd_set_ts_offset(struct tracecmd_input *handle, unsigned long long offset);
+void tracecmd_set_ts_offset(struct tracecmd_input *handle, long long offset);
 void tracecmd_set_ts2secs(struct tracecmd_input *handle, unsigned long long hz);
 
 void tracecmd_print_events(struct tracecmd_input *handle, const char *regex);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 3b187e3..91362f3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -90,7 +90,7 @@ struct tracecmd_input {
 	bool			read_page;
 	bool			use_pipe;
 	struct cpu_data 	*cpu_data;
-	unsigned long long	ts_offset;
+	long long		ts_offset;
 	double			ts2secs;
 	char *			cpustats;
 	char *			uname;
@@ -2127,7 +2127,7 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
 }
 
 void tracecmd_set_ts_offset(struct tracecmd_input *handle,
-			    unsigned long long offset)
+			    long long offset)
 {
 	handle->ts_offset = offset;
 }
@@ -2305,7 +2305,7 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
 
 static int handle_options(struct tracecmd_input *handle)
 {
-	unsigned long long offset;
+	long long offset;
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index c0d640d..4ce2e98 100644
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
2.23.0

