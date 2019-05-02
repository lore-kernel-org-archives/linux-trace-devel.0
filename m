Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B85C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD0A720645
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfEBMJ5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:09:57 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34683 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfEBMJ5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:09:57 -0400
Received: by mail-wm1-f66.google.com with SMTP id b67so6487493wmg.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 05:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6XFTI+DO3Sbv3ECf89iqSkHY+C784SDGc3vukLXttxc=;
        b=aFT48mLPQHUrlsGMmDyAAaAyCb93+79/bzNlRQGBAeT4frHzXMoc8L9vVACZ44yag6
         uCsh/y4XWa9xKwjz7iQwW7JGrwGumMW1XqAo0l/i/cDsJfX1KwhtxjdYDaC6B6qthb/1
         KdvQQ6H4tA3hM4UNdwiaj2+TFPbGKQLAwPFE48mmZ4Hy9wN0Cx7/eo1nmPthepXv8oOi
         cMFeXaR8p1HEhBXrHnEGRgb5mom31msZZzc6KggxXh8jyKX7PgyhsbRrupc9R6fH7S1i
         afwAso0fFE91D1Lc++H9IhXfpnJhdWZpAkUUlJlp/WKAKRshIBdwIU7+DMSQUSkl0CSd
         kskQ==
X-Gm-Message-State: APjAAAWtDEYZVTDGp+y3qQCE6ha5oHXszNgI+X+lVBWApXFzvPeDjyVg
        TBzY+dnHEkTxLRWqXfDCrus=
X-Google-Smtp-Source: APXvYqzLYf+p2JwnxtubCInhYRuDlF5IkAVy69iStxWvx5P0R1LF4G6C0wt3wAcyNfTzo8/LZRIl3w==
X-Received: by 2002:a7b:cb11:: with SMTP id u17mr2276545wmj.144.1556798994645;
        Thu, 02 May 2019 05:09:54 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u2sm42029219wru.36.2019.05.02.05.09.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 May 2019 05:09:54 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Fix crash when trace-cmd is executed with args "profile -F sleep 1"
Date:   Thu,  2 May 2019 15:09:51 +0300
Message-Id: <20190502120952.20449-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A fix for https://bugzilla.kernel.org/show_bug.cgi?id=203411
When trace-cmd is running in "profile" mode, trace files are not generated.
Instead, pipes are used to collect trace data from recorder threads. Some
internal functions, originally designed for working with files, are reused
in pipes use case:
 init_cpu()
 allocate_page()
 get_next_page()
There was an undesired behaviour in those functions, when working with pipes,
which causes the segmentation fault, described in the bug report.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 lib/trace-cmd/trace-input.c | 69 ++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 24 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ba20ef1..8d1001a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -62,6 +62,7 @@ struct cpu_data {
 	struct list_head	page_maps;
 	struct page_map		*page_map;
 	struct page		**pages;
+	int			num_pages;
 	struct tep_record	*next;
 	struct page		*page;
 	struct kbuffer		*kbuf;
@@ -921,34 +922,50 @@ static struct page *allocate_page(struct tracecmd_input *handle,
 	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
 	struct page *page;
 	int index;
+	int ret;
 
 	index = (offset - cpu_data->file_offset) / handle->page_size;
-	if (cpu_data->pages[index]) {
-		cpu_data->pages[index]->ref_count++;
-		return cpu_data->pages[index];
-	}
-
-	page = malloc(sizeof(*page));
-	if (!page)
+	if (index >= cpu_data->num_pages)
 		return NULL;
+	page = cpu_data->pages[index];
+	if (page && !handle->read_page) {
+		page->ref_count++;
+		return page;
+	}
 
-	memset(page, 0, sizeof(*page));
-	page->offset = offset;
-	page->handle = handle;
-	page->cpu = cpu;
+	if (!page) {
+		page = malloc(sizeof(*page));
+		if (!page)
+			return NULL;
 
-	page->map = allocate_page_map(handle, page, cpu, offset);
+		memset(page, 0, sizeof(*page));
+		page->offset = offset;
+		page->handle = handle;
+		page->cpu = cpu;
+	}
 
 	if (!page->map) {
-		free(page);
-		return NULL;
+		page->map = allocate_page_map(handle, page, cpu, offset);
+		if (!page->map) {
+			free(page);
+			return NULL;
+		}
+
+		cpu_data->pages[index] = page;
+		cpu_data->page_cnt++;
+		page->ref_count = 1;
+
+		return page;
 	}
 
-	cpu_data->pages[index] = page;
-	cpu_data->page_cnt++;
-	page->ref_count = 1;
+	if (handle->read_page) {
+		ret = read_page(handle, offset, cpu, page->map);
+		if (ret < 0)
+			return NULL;
+		return page;
+	}
 
-	return page;
+	return NULL;
 }
 
 static void __free_page(struct tracecmd_input *handle, struct page *page)
@@ -960,6 +977,8 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 		die("Page ref count is zero!\n");
 
 	page->ref_count--;
+	if (cpu_data->page == page)
+		cpu_data->page = NULL;
 	if (page->ref_count)
 		return;
 
@@ -1125,7 +1144,7 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 
 static int get_next_page(struct tracecmd_input *handle, int cpu)
 {
-	off64_t offset;
+	off64_t offset = 0;
 
 	if (!handle->cpu_data[cpu].page && !handle->use_pipe)
 		return 0;
@@ -1137,7 +1156,8 @@ static int get_next_page(struct tracecmd_input *handle, int cpu)
 		return 0;
 	}
 
-	offset = handle->cpu_data[cpu].offset + handle->page_size;
+	if (!handle->use_pipe)
+		offset = handle->cpu_data[cpu].offset + handle->page_size;
 
 	return get_page(handle, cpu, offset);
 }
@@ -2026,7 +2046,6 @@ tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
 static int init_cpu(struct tracecmd_input *handle, int cpu)
 {
 	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
-	int num_pages;
 	int i;
 
 	cpu_data->offset = cpu_data->file_offset;
@@ -2040,13 +2059,13 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
 		return 0;
 	}
 
-	num_pages = (cpu_data->size + handle->page_size - 1) / handle->page_size;
-	cpu_data->pages = calloc(num_pages + 1, sizeof(*cpu_data->pages));
+	cpu_data->num_pages = (cpu_data->size + handle->page_size - 1) / handle->page_size;
+	cpu_data->pages = calloc(cpu_data->num_pages + 1, sizeof(*cpu_data->pages));
 	if (!cpu_data->pages)
 		return -1;
 
 	/* Add stopper */
-	cpu_data->pages[num_pages] = PAGE_STOPPER;
+	cpu_data->pages[cpu_data->num_pages] = PAGE_STOPPER;
 
 	if (handle->use_pipe) {
 		/* Just make a page, it will be nuked later */
@@ -2056,8 +2075,10 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
 
 		memset(cpu_data->page, 0, sizeof(*cpu_data->page));
 		cpu_data->pages[0] = cpu_data->page;
+		cpu_data->num_pages = 1;
 		cpu_data->page_cnt = 1;
 		cpu_data->page->ref_count = 1;
+		cpu_data->page->cpu = cpu;
 		return 0;
 	}
 
-- 
2.20.1

