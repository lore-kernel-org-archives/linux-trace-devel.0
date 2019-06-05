Return-Path: <SRS0=wZju=UE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A67C28CC5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Jun 2019 11:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E63F206DF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Jun 2019 11:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfFELuu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 07:50:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44196 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727330AbfFELut (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 07:50:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id w13so19103148wru.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 05 Jun 2019 04:50:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EDqC6lui4xVSzd+AUDRKIxsXxtHoMffTne3eK3H4hg0=;
        b=SFs695RwKElV29R116oPJPXDlr177tpCpDkK/2USFdJ36vxfFmeRy2Z0+yImk2Bzg7
         hO/22PJuj0GYX5SpIC9HrGeQy2VILlpVWGuTkFAIJs2DHvdRXNXlcTZOYZ0gXmuK8RXE
         jBoHEjj4IamV/LlTHal/hm5krx/cO4NReHAbV6pKbFcjedjiqxCkbachhn3MnbTM28QF
         Y278ghsMtNijAutBeg5wNJprSHvXKM6mPthPy4Sdw/Q26EiRxF7PkPQBfdM9kaYJvQQv
         9WAVlktLwLi2V3lhwvKbYCC/zgfXi7CLXyc/s18PiUQKtI5S9f+6tRvwroGpSZ3UB9Mr
         19WA==
X-Gm-Message-State: APjAAAUgB5tJ81BMqlbtUhY6ycbn4kGyAEmTQPWP1oIC+YkR27w587wt
        zmyjHOGPKnZxjPf0VqLWOo24hl2v
X-Google-Smtp-Source: APXvYqywKupdw9K33YZ+Ja5feMGwVsPWU9bm5Br7agfbfg9fHh6Q++mgXo0Qz2gn59hEDilxYNbdOw==
X-Received: by 2002:a5d:5586:: with SMTP id i6mr24636803wrv.299.1559735447649;
        Wed, 05 Jun 2019 04:50:47 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id z65sm27549511wme.37.2019.06.05.04.50.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 05 Jun 2019 04:50:47 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] trace-cmd: Fix crash when trace-cmd is executed with args "profile -F sleep 1"
Date:   Wed,  5 Jun 2019 14:50:46 +0300
Message-Id: <20190605115046.20444-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 v3 changes:
  - added the full Bugzilla description of the problem.
  - added tags for the Bugzilla problem and the commit which broke it.
 v2 changes:
  - reimplemented the fix, keeping the old link-list logic (before commit 62e82cc6cdc9)
]


When trace-cmd is running in "profile" mode, trace files are not generated.
Instead, pipes are used to collect trace data from recorder threads. Some
internal functions, originally designed for working with files, are reused
in pipes use case:
 init_cpu()
 allocate_page()
 get_next_page()
There was an undesired behaviour in those functions, when working with pipes,
which causes the segmentation fault.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203411
Fixes: 62e82cc6cdc9 ("trace-cmd: Use lookup table instead of link list for pages")

./trace-cmd profile -F sleep 1
Segmentation fault (core dumped)
back trace:
0  allocate_page (handle=0x4a1a10, cpu=0, offset=12288) at trace-input.c:927
1  0x000000000042d2aa in get_page (handle=0x4a1a10, cpu=0, offset=12288) at trace-input.c:1116
2  0x000000000042d40d in get_next_page (handle=0x4a1a10, cpu=0) at trace-input.c:1142
3  0x000000000042e339 in tracecmd_peek_data (handle=0x4a1a10, cpu=0) at trace-input.c:1776
4  0x000000000042e6d4 in tracecmd_read_data (handle=0x4a1a10, cpu=0) at trace-input.c:1841
5  0x0000000000424d82 in trace_stream_read (pids=0x47b7d0, nr_pids=8, tv=0x7fffffffd3c0) at trace-stream.c:105
6  0x000000000040aa1f in trace_waitpid (type=TRACE_TYPE_STREAM, pid=24759, status=0x7fffffffd408, options=1) at trace-record.c:1114
7  0x000000000040b151 in run_cmd (type=TRACE_TYPE_STREAM, argc=2, argv=0x7fffffffd600) at trace-record.c:1331
8  0x0000000000412ffd in record_trace (argc=5, argv=0x7fffffffd5e8, ctx=0x7fffffffd470) at trace-record.c:5065
9  0x000000000041338d in trace_profile (argc=5, argv=0x7fffffffd5e8) at trace-record.c:5199
10 0x0000000000408bc5 in main (argc=5, argv=0x7fffffffd5e8) at trace-cmd.c:118

The problem seems to be in the lookup table "struct page **pages" in struct cpu_data.
In case pipes are used with this tracecmd_input handler, only a single page is
allocated in this lookup table. Later, when get_page() is called, there is use
case where more pages are addressed (in the backtrace above, the page with
index 3 is addressed, cpu_data->pages[3])

trace-cmd: current (git20190424)

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

