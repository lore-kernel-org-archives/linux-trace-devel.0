Return-Path: <SRS0=wZju=UE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CEBC28D19
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Jun 2019 11:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5762F20874
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Jun 2019 11:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfFELTm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 07:19:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32993 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbfFELTl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 07:19:41 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so6617046wru.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 05 Jun 2019 04:19:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eNQkO71pqQ6id/igKjJctLEZz9nALUDYz5rDmSsDQoI=;
        b=BIs8fEmqeDetdWSlyv/mQ0r/gi41Jln1pT94lAzdUOrRyfS9iDjt4O2C187uvL4Mx/
         9GIhzirRO68qmXNvuIas+dMgdWoQkNrTxYAFgj5WkIxHfLMSKH2LuGBFsChQcViTQMyT
         mOUePRLjOurqkGfDL4Nj0D5GfO5GBoFPvj3K80uNZ+vdJRjEvihv+72DeLycHSEPQhM1
         KD/8IFd/dzIxRbgzhks03k6FPaIk//KlE259Qh3kBYtXgrEbxurhNUUf3YazYXyiRVhG
         ybQTmkhfAMmWaJwLf22438ifPS81rmZczpR+GLkLvg412luLcfIHbOtqk8FlBpa+pkV1
         n5SQ==
X-Gm-Message-State: APjAAAUCUElQZpbKCcSDf1EI+X0aYJns19w7yI3dCeRDyOK3YfoVB5A+
        CeNl6Z4/dKlfWRsyZ47OrQOvBVWK
X-Google-Smtp-Source: APXvYqwiY/LrKRgltSG2SnPCBSRVghscvTvY1NNn8GxYc/gjEJOAJEAs1cVzR6lLORI/EAqac6gxSQ==
X-Received: by 2002:adf:dcd1:: with SMTP id x17mr25210138wrm.98.1559733579046;
        Wed, 05 Jun 2019 04:19:39 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 16sm15583084wmx.45.2019.06.05.04.19.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 05 Jun 2019 04:19:38 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/2] trace-cmd: Fix crash when trace-cmd is executed with args "profile -F sleep 1"
Date:   Wed,  5 Jun 2019 14:19:36 +0300
Message-Id: <20190605111937.17894-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.21.0
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
 lib/trace-cmd/trace-input.c | 45 +++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ba20ef1..264e3c3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -28,8 +28,6 @@
 /* for debugging read instead of mmap */
 static int force_read = 0;
 
-#define PAGE_STOPPER		((struct page *)-1L)
-
 struct page_map {
 	struct list_head	list;
 	off64_t			offset;
@@ -65,6 +63,7 @@ struct cpu_data {
 	struct tep_record	*next;
 	struct page		*page;
 	struct kbuffer		*kbuf;
+	int			nr_pages;
 	int			page_cnt;
 	int			cpu;
 	int			pipe_fd;
@@ -146,16 +145,17 @@ static void add_record(struct page *page, struct tep_record *record)
 	record->prev = NULL;
 	page->records = record;
 }
-static const char *show_records(struct page **pages)
+static const char *show_records(struct page **pages, int nr_pages)
 {
 	static char buf[BUFSIZ + 1];
 	struct tep_record *record;
 	struct page *page;
 	int len;
+	int i;
 
 	memset(buf, 0, sizeof(buf));
 	len = 0;
-	for (i = 0; pages[i] != PAGE_STOPPER; i--) {
+	for (i = 0; i < nr_pages; i++) {
 		page = pages[i];
 		if (!page)
 			continue;
@@ -172,7 +172,7 @@ static const char *show_records(struct page **pages)
 #else
 static inline void remove_record(struct page *page, struct tep_record *record) {}
 static inline void add_record(struct page *page, struct tep_record *record) {}
-static const char *show_records(struct page **pages)
+static const char *show_records(struct page **pages, int nr_pages)
 {
 	return "";
 }
@@ -919,10 +919,20 @@ static struct page *allocate_page(struct tracecmd_input *handle,
 				  int cpu, off64_t offset)
 {
 	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
+	struct page **pages;
 	struct page *page;
 	int index;
 
 	index = (offset - cpu_data->file_offset) / handle->page_size;
+	if (index >= cpu_data->nr_pages) {
+		pages = realloc(cpu_data->pages, (index + 1) * sizeof(*cpu_data->pages));
+		if (!pages)
+			return NULL;
+		memset(pages + cpu_data->nr_pages, 0,
+		       (index + 1 - cpu_data->nr_pages) * sizeof(*cpu_data->pages));
+		cpu_data->pages = pages;
+		cpu_data->nr_pages = index + 1;
+	}
 	if (cpu_data->pages[index]) {
 		cpu_data->pages[index]->ref_count++;
 		return cpu_data->pages[index];
@@ -954,6 +964,7 @@ static struct page *allocate_page(struct tracecmd_input *handle,
 static void __free_page(struct tracecmd_input *handle, struct page *page)
 {
 	struct cpu_data *cpu_data = &handle->cpu_data[page->cpu];
+	struct page **pages;
 	int index;
 
 	if (!page->ref_count)
@@ -973,6 +984,17 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 	cpu_data->page_cnt--;
 
 	free(page);
+
+	for (index = cpu_data->nr_pages - 1; index > 0; index--)
+		if (cpu_data->pages[index])
+			break;
+	if (index < (cpu_data->nr_pages - 1)) {
+		pages = realloc(cpu_data->pages, (index + 1) * sizeof(*cpu_data->pages));
+		if (!pages)
+			return;
+		cpu_data->pages = pages;
+		cpu_data->nr_pages = index + 1;
+	}
 }
 
 static void free_page(struct tracecmd_input *handle, int cpu)
@@ -2026,7 +2048,6 @@ tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
 static int init_cpu(struct tracecmd_input *handle, int cpu)
 {
 	struct cpu_data *cpu_data = &handle->cpu_data[cpu];
-	int num_pages;
 	int i;
 
 	cpu_data->offset = cpu_data->file_offset;
@@ -2040,14 +2061,13 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
 		return 0;
 	}
 
-	num_pages = (cpu_data->size + handle->page_size - 1) / handle->page_size;
-	cpu_data->pages = calloc(num_pages + 1, sizeof(*cpu_data->pages));
+	cpu_data->nr_pages = (cpu_data->size + handle->page_size - 1) / handle->page_size;
+	if (!cpu_data->nr_pages)
+		cpu_data->nr_pages = 1;
+	cpu_data->pages = calloc(cpu_data->nr_pages, sizeof(*cpu_data->pages));
 	if (!cpu_data->pages)
 		return -1;
 
-	/* Add stopper */
-	cpu_data->pages[num_pages] = PAGE_STOPPER;
-
 	if (handle->use_pipe) {
 		/* Just make a page, it will be nuked later */
 		cpu_data->page = malloc(sizeof(*cpu_data->page));
@@ -2793,7 +2813,8 @@ void tracecmd_close(struct tracecmd_input *handle)
 			if (handle->cpu_data[cpu].page_cnt)
 				warning("%d pages still allocated on cpu %d%s",
 					handle->cpu_data[cpu].page_cnt,
-					cpu, show_records(handle->cpu_data[cpu].pages));
+					cpu, show_records(handle->cpu_data[cpu].pages,
+							  handle->cpu_data[cpu].nr_pages));
 			free(handle->cpu_data[cpu].pages);
 		}
 	}
-- 
2.21.0

