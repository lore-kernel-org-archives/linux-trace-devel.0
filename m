Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9E9C341B8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3CAA2479D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G9vjoRA0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfLMPah (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:37 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37079 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfLMPag (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:36 -0500
Received: by mail-lf1-f67.google.com with SMTP id b15so2262228lfc.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2UB+7TyCvOxtXN0b6w3H+2SysAGSr92bcpZfqsJmkPw=;
        b=G9vjoRA0JSMDV1ywZe7D+F0HL331LSZhEZC2EWIN9nkqyRQuVKFWf60OoPJDC+W+7L
         alTqVPZofjx1Z+Hj0WRl7WYVf9qXRlCLUuBRAIynfABp6q6DVpfnHtiulCXdPoaCmjFi
         KyUVTiVVxQeU4cqrmr/nTsfmp62oKFWfaRwjcV8MVUizM4e1skyJjCuX56Zgsdy7T7gA
         shXFq5sjgpauO2xDaxJqKuH3ihNqJJlQQsJbaVUQTQoEIu/0o9T8sorqZuW9abbH2t2O
         YwKoxS4Dgg/46ElFY+bf2K5ChfkODa1QQjGBaqQ9AgMguGkkhXE3C9BRB2+lcXNTkvpg
         LtDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2UB+7TyCvOxtXN0b6w3H+2SysAGSr92bcpZfqsJmkPw=;
        b=r74WbgWmtvZ5mkKpFrmtwM8adSqIwGisyRQw/MrP4lkoOpkBVeP/8iSd3J3DOG8kZu
         KNGSmAkUzbr9N0S6oUTwYoUV4nycYJJ89gVxZyvlc1KZa8MOWEEJ0tfJUzIfAAjo3Veg
         f8Pw6NeQHmjEZ9irhTkoqgLS8baCB8XuJhZccks/GJ5ynkA3pyEQqhKfPPO8PmbzAmzu
         Ky4phwnklweJ9vYYqDPGvzbPc7XtKjcicox9MIjT2UNHL6ez/Mdt3uAHkwuzfujwLtLz
         u+OXpK+E2sLFnsvsjY3TWbvt43wI2uHh49Rv0e8dYegCY1gLSEj9wOM/FUATqFUJHAqt
         VqrA==
X-Gm-Message-State: APjAAAUfAlcU0fOW5rjhyNc8hTNYtzeIxq08yrLXqGLXc599AyED2ZEz
        gd1uDGbSPM1DGgetdyIek9KV0kKoIOU=
X-Google-Smtp-Source: APXvYqxl0U/wYljTuaiAvPEp6I6nMKGBl8vfzd2nW8ZFHYkXXfvxCCLgu7ABy7GX2eWPT6jV567iIw==
X-Received: by 2002:ac2:53a8:: with SMTP id j8mr9616127lfh.28.1576251034871;
        Fri, 13 Dec 2019 07:30:34 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:34 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 02/18] trace-cmd: Add support for negative time offsets in trace.dat file
Date:   Fri, 13 Dec 2019 17:30:13 +0200
Message-Id: <20191213153029.133570-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213153029.133570-1-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
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

