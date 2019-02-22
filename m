Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42927C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12BE620818
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfBVO2l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:28:41 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33959 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVO2l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 09:28:41 -0500
Received: by mail-wm1-f68.google.com with SMTP id y185so9026384wmd.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 06:28:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Akwbj/kBryCNHRJuSYOiQOEQ7urlKUyQpryXh2sI2c=;
        b=iIAfwHu56mNHhJLybwhj6hK06l6LTdIJWLHclo4F5ItKU0zK22WjfSygbpUeS5xOa6
         EVEXb8gRu5mZVAfxp58OPmAyQc0OnPMWbIv1G61Aiija9ZTwotpXbn5gzLPe0IaYeqNE
         VmrA7wqMQekGJvk6XExw1c6XUW7unAcG9Z/OGUmDkzzZyKJufz0k8xmeRsqHLUPGNnlR
         yWaUB+Dhu23TQVcG+g/0oq3yOhYmaRcQeHO6xWU+Uj5/VF0ExCoojQirJLG1ySz+W7Rs
         v3FqpzCOTwHIZEccs92226ATFkpSqlZOuc71TtLEBfheL8UHQ8IQSbxDqnKx+LO6O7G9
         TYeA==
X-Gm-Message-State: AHQUAubM7fOBq8mweGeq0rCj/c8baSjTNeYKdh20E2u+oE+v9lYlbI7M
        FHe8a5l2eMWG2Cj7y2uFViL3jX7D
X-Google-Smtp-Source: AHgI3IZRkbrYatZv5uXexipEn3AtEgONjT+FVEhaN6Uh6JTVKLeXHbBnzMobmKsSakQKeJ/YNNzbkg==
X-Received: by 2002:a1c:7008:: with SMTP id l8mr2604110wmc.63.1550845719970;
        Fri, 22 Feb 2019 06:28:39 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q9sm848987wrv.26.2019.02.22.06.28.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Feb 2019 06:28:39 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 2/7] trace-cmd: Added support for negative time offsets in trace.dat file
Date:   Fri, 22 Feb 2019 16:28:31 +0200
Message-Id: <20190222142836.12596-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222142836.12596-1-tstoyanov@vmware.com>
References: <20190222142836.12596-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

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
index 0067882..3f0ab4f 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -126,7 +126,7 @@ int tracecmd_is_buffer_instance(struct tracecmd_input *handle);
 void tracecmd_create_top_instance(char *name);
 void tracecmd_remove_instances(void);
 
-void tracecmd_set_ts_offset(struct tracecmd_input *handle, unsigned long long offset);
+void tracecmd_set_ts_offset(struct tracecmd_input *handle, long long offset);
 void tracecmd_set_ts2secs(struct tracecmd_input *handle, unsigned long long hz);
 
 void tracecmd_print_events(struct tracecmd_input *handle, const char *regex);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 34a8301..be6720c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -91,7 +91,7 @@ struct tracecmd_input {
 	bool			read_page;
 	bool			use_pipe;
 	struct cpu_data 	*cpu_data;
-	unsigned long long	ts_offset;
+	long long		ts_offset;
 	double			ts2secs;
 	char *			cpustats;
 	char *			uname;
@@ -2082,7 +2082,7 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
 }
 
 void tracecmd_set_ts_offset(struct tracecmd_input *handle,
-			    unsigned long long offset)
+			    long long offset)
 {
 	handle->ts_offset = offset;
 }
@@ -2099,7 +2099,7 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
 
 static int handle_options(struct tracecmd_input *handle)
 {
-	unsigned long long offset;
+	long long offset;
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 804022a..e309672 100644
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
@@ -1413,7 +1413,7 @@ void trace_report (int argc, char **argv)
 	struct input_files *inputs;
 	struct handle_list *handles;
 	enum output_type otype;
-	unsigned long long tsoffset = 0;
+	long long tsoffset = 0;
 	unsigned long long ts2secs = 0;
 	unsigned long long ts2sc;
 	int show_stat = 0;
-- 
2.20.1

