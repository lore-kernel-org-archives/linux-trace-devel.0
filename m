Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C96C43141
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 08:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EF432176D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 08:54:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qF1y0IHt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfK1IyS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 03:54:18 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33835 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbfK1IyS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 03:54:18 -0500
Received: by mail-lj1-f194.google.com with SMTP id m6so20210464ljc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 00:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fT9xQH8HUdkRlHUX669ipLmb6sWWPVwYlySY8sYag00=;
        b=qF1y0IHtoOXJ+U2beD+37wJ+TlocOqAlGNPhfHIY8ZsyjXvonFhnsvhgODsMERmalN
         yVqveNvIKFnoDD6VoqgtKyL1LwROlobdiPZ3I4MnqnjWHLrJWWleIZ11DhIZW27yV2V1
         SWhK63NH5YEEvZ+mOtQob78ApC+KIcFEMMbmmdrSRxaAQruhTz4CkKrxqn2MZCcUQ8N4
         UGpBDRjS0w+r1aPLBZut83fPpqaNAy6wjzS7mr9yHZy3caezozTvtNkLjRsI+u7hQgXw
         iXqHBTboUZ6OKFDsX4JjRqpbbkSOXNMRxZVg2+b+V7w+ULkyWiA0J7VlD76nEvdBCRAP
         d6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fT9xQH8HUdkRlHUX669ipLmb6sWWPVwYlySY8sYag00=;
        b=GWNi+gwD2xFXQJkDm1Ug2SvyaTiD0y6oOmNSaJX30QqMEHkb9U7O79fPsdJ+o1smWC
         UhzJbCNGQh1J8xX+Jr4pSTVrpxCtSBkimfydFuClj66vQzT9zoC3aW774KIsKdjUiYQs
         d1LvVc2Z4dgohaoMzOE1EuRBf20KJEyMImsC2C0VmuMNbuNyC+auosrJIu7DlRmxXYJO
         oJj/1XiPQz/xJwWYLDP3iFDPHIIjmjASRFLLiecrLqHVywnyIirL4RwclFgFjZi9e/AY
         8SOnwNbPgwEpvxaCh6HF5izyWaZ3wFXHiadWI9oAGj1dVdqMrqLasAIumr/ZmCkdrFzw
         xYDw==
X-Gm-Message-State: APjAAAX/cLX5IiE44IZfbG8XwZkZpEzrlPJT+yDtrB9+VKkB9TAAJ4vp
        qCcPWMnGBC83uhPUw08CVeyla6UoZUk=
X-Google-Smtp-Source: APXvYqyOZBz3pd7q4SjTjyortAE0PNVJeAfJYzJGvZiqbzFjgD0F/fzgi5cuE+SmCg9gMo9LaYym2Q==
X-Received: by 2002:a05:651c:38f:: with SMTP id e15mr33460035ljp.107.1574931254484;
        Thu, 28 Nov 2019 00:54:14 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id z19sm8253735ljk.66.2019.11.28.00.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 00:54:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v15 02/18] trace-cmd: Add support for negative time offsets in trace.dat file
Date:   Thu, 28 Nov 2019 10:53:53 +0200
Message-Id: <20191128085409.289684-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191128085409.289684-1-tz.stoyanov@gmail.com>
References: <20191128085409.289684-1-tz.stoyanov@gmail.com>
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
index 4958fa8..1875b75 100644
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
@@ -1453,7 +1453,7 @@ void trace_report (int argc, char **argv)
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

