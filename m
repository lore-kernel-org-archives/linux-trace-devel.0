Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C34FC43217
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Oct 2022 10:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiJLKPg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 06:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiJLKPF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 06:15:05 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71574A0324
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Oct 2022 03:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=xOY7ardw+2e0LZpcB97/UTXG6xemDQe4kefe2mXotOg=; t=1665569607; x=1666779207; 
        b=MiZOfItS0aktYO9CLi4fwHCQJB3nQjzAbKEpHkzCGZ1s/29Kvq17m+aBIghi8R22ej8GVmN26Vn
        Kp0QhwnTI+238W9BcGbZ+hBXGyMQWIGWtEFmfcnbxsMn1sZP3rwH2BmAhMU94ogdU9k7bTCNXpbau
        o7uINJy7VzdhUes122lG4cUl5XwHDKyjCGVdfhqQGKmBXBvlbF7mHGNJyX3OvQ/j6ArcbR6coRJDE
        vP3LQKshdZWKrE10FEcperDmyEmIco10tVEr6gpj6v7QJOn20dVYZxcyUzHES9T19wIxHFgFu8PCS
        ZJynDtzJUxRdwkm923chyxHUz8pR0sPwlqhg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <benjamin@sipsolutions.net>)
        id 1oiYjj-004lcr-2A;
        Wed, 12 Oct 2022 12:13:15 +0200
From:   Benjamin Berg <benjamin@sipsolutions.net>
To:     linux-trace-devel@vger.kernel.org
Cc:     johannes@sipsolutions.net,
        Benjamin Berg <benjamin@sipsolutions.net>
Subject: [RFC PATCH 1/2] tracecmd library: Use libtraceevent record refcounting
Date:   Wed, 12 Oct 2022 12:13:06 +0200
Message-Id: <20221012101307.784747-1-benjamin@sipsolutions.net>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Moving this into libtraceevent has the advantage that a python plugin
loader can be implemented that does not need access to trace-cmd API.
---
 .../include/private/trace-cmd-private.h       |  2 +-
 lib/trace-cmd/trace-input.c                   | 94 +++++++++----------
 2 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index d73a5191..b08ebcee 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -235,7 +235,7 @@ tracecmd_peek_data_ref(struct tracecmd_input *handle, int cpu)
 {
 	struct tep_record *rec = tracecmd_peek_data(handle, cpu);
 	if (rec)
-		rec->ref_count++;
+		tep_record_ref(rec);
 	return rec;
 }
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index cdaa17bd..157e2d97 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -35,6 +35,16 @@
 /* for debugging read instead of mmap */
 static int force_read = 0;
 
+#define REC_PRIV(rec) ((struct record_priv*) (rec)->priv)
+struct record_priv {
+	struct page		*page;
+	int			locked;
+#if DEBUG_RECORD
+	struct tep_record	*prev;
+	struct tep_record	*next;
+#endif
+};
+
 struct page_map {
 	struct list_head	list;
 	off64_t			offset;
@@ -261,19 +271,23 @@ void *tracecmd_get_private(struct tracecmd_input *handle)
 #if DEBUG_RECORD
 static void remove_record(struct page *page, struct tep_record *record)
 {
-	if (record->prev)
-		record->prev->next = record->next;
+	struct record_priv *priv = REC_PRIV(record);
+
+	if (priv->prev)
+		REC_PRIV(priv->prev)->next = priv->next;
 	else
-		page->records = record->next;
-	if (record->next)
-		record->next->prev = record->prev;
+		page->records = priv->next;
+	if (priv->next)
+		REC_PRIV(priv->next)->prev = priv->prev;
 }
 static void add_record(struct page *page, struct tep_record *record)
 {
+	struct record_priv *priv = REC_PRIV(record);
+
 	if (page->records)
-		page->records->prev = record;
-	record->next = page->records;
-	record->prev = NULL;
+		REC_PRIV(page->records)->prev = record;
+	priv->next = page->records;
+	priv->prev = NULL;
 	page->records = record;
 }
 static const char *show_records(struct page **pages, int nr_pages)
@@ -290,7 +304,7 @@ static const char *show_records(struct page **pages, int nr_pages)
 		page = pages[i];
 		if (!page)
 			continue;
-		for (record = page->records; record; record = record->next) {
+		for (record = page->records; record; record = REC_PRIV(record)->next) {
 			int n;
 			n = snprintf(buf+len, BUFSIZ - len, " 0x%lx", record->alloc_addr);
 			len += n;
@@ -1601,13 +1615,20 @@ static void free_page(struct tracecmd_input *handle, int cpu)
 
 static void __free_record(struct tep_record *record)
 {
-	if (record->priv) {
-		struct page *page = record->priv;
+	struct record_priv *priv = record->priv;
+
+	if (priv->locked) {
+		tracecmd_critical("freeing record when it is locked!");
+		return;
+	}
+
+	record->data = NULL;
+
+	if (priv->page) {
+		struct page *page = priv->page;
 		remove_record(page, record);
 		__free_page(page->handle, page);
 	}
-
-	free(record);
 }
 
 void tracecmd_free_record(struct tep_record *record)
@@ -1615,29 +1636,12 @@ void tracecmd_free_record(struct tep_record *record)
 	if (!record)
 		return;
 
-	if (!record->ref_count) {
-		tracecmd_critical("record ref count is zero!");
-		return;
-	}
-
-	record->ref_count--;
-
-	if (record->ref_count)
-		return;
-
-	if (record->locked) {
-		tracecmd_critical("freeing record when it is locked!");
-		return;
-	}
-
-	record->data = NULL;
-
-	__free_record(record);
+	tep_record_unref(record);
 }
 
 void tracecmd_record_ref(struct tep_record *record)
 {
-	record->ref_count++;
+	tep_record_ref(record);
 #if DEBUG_RECORD
 	/* Update locating of last reference */
 	record->alloc_addr = (unsigned long)__builtin_return_address(0);
@@ -1657,7 +1661,7 @@ static void free_next(struct tracecmd_input *handle, int cpu)
 
 	handle->cpu_data[cpu].next = NULL;
 
-	record->locked = 0;
+	REC_PRIV(record)->locked = 0;
 	tracecmd_free_record(record);
 }
 
@@ -2353,12 +2357,10 @@ tracecmd_translate_data(struct tracecmd_input *handle,
 	if (size < 8)
 		return NULL;
 
-	record = malloc(sizeof(*record));
+	record = tep_record_alloc(sizeof(struct record_priv), __free_record);
 	if (!record)
 		return NULL;
-	memset(record, 0, sizeof(*record));
 
-	record->ref_count = 1;
 	if (tep_is_local_bigendian(pevent) == tep_is_file_bigendian(pevent))
 		swap = 0;
 	record->data = kbuffer_translate_data(swap, ptr, &length);
@@ -2437,10 +2439,9 @@ read_again:
 
 	index = kbuffer_curr_offset(kbuf);
 
-	record = malloc(sizeof(*record));
+	record = tep_record_alloc(sizeof(struct record_priv), __free_record);
 	if (!record)
 		return NULL;
-	memset(record, 0, sizeof(*record));
 
 	record->ts = handle->cpu_data[cpu].timestamp;
 	record->size = kbuffer_event_size(kbuf);
@@ -2448,13 +2449,12 @@ read_again:
 	record->data = data;
 	record->offset = handle->cpu_data[cpu].offset + index;
 	record->missed_events = kbuffer_missed_events(kbuf);
-	record->ref_count = 1;
-	record->locked = 1;
+	REC_PRIV(record)->locked = 1;
 
 	handle->cpu_data[cpu].next = record;
 
 	record->record_size = kbuffer_curr_size(kbuf);
-	record->priv = page;
+	REC_PRIV(record)->page = page;
 	add_record(page, record);
 	page->ref_count++;
 
@@ -2484,7 +2484,7 @@ tracecmd_read_data(struct tracecmd_input *handle, int cpu)
 	record = tracecmd_peek_data(handle, cpu);
 	handle->cpu_data[cpu].next = NULL;
 	if (record) {
-		record->locked = 0;
+		REC_PRIV(record)->locked = 0;
 #if DEBUG_RECORD
 		record->alloc_addr = (unsigned long)__builtin_return_address(0);
 #endif
@@ -5619,7 +5619,7 @@ __hidden int tracecmd_copy_trace_data(struct tracecmd_input *in_handle,
 int tracecmd_record_at_buffer_start(struct tracecmd_input *handle,
 				    struct tep_record *record)
 {
-	struct page *page = record->priv;
+	struct page *page = REC_PRIV(record)->page;
 	struct kbuffer *kbuf = handle->cpu_data[record->cpu].kbuf;
 	int offset;
 
@@ -5633,7 +5633,7 @@ int tracecmd_record_at_buffer_start(struct tracecmd_input *handle,
 unsigned long long tracecmd_page_ts(struct tracecmd_input *handle,
 				    struct tep_record *record)
 {
-	struct page *page = record->priv;
+	struct page *page = REC_PRIV(record)->page;
 	struct kbuffer *kbuf = handle->cpu_data[record->cpu].kbuf;
 
 	if (!page || !kbuf)
@@ -5646,7 +5646,7 @@ unsigned int tracecmd_record_ts_delta(struct tracecmd_input *handle,
 				      struct tep_record *record)
 {
 	struct kbuffer *kbuf = handle->cpu_data[record->cpu].kbuf;
-	struct page *page = record->priv;
+	struct page *page = REC_PRIV(record)->page;
 	int offset;
 
 	if (!page || !kbuf)
@@ -5666,7 +5666,7 @@ struct kbuffer *tracecmd_record_kbuf(struct tracecmd_input *handle,
 void *tracecmd_record_page(struct tracecmd_input *handle,
 			   struct tep_record *record)
 {
-	struct page *page = record->priv;
+	struct page *page = REC_PRIV(record)->page;
 
 	return page ? page->map : NULL;
 }
@@ -5674,7 +5674,7 @@ void *tracecmd_record_page(struct tracecmd_input *handle,
 void *tracecmd_record_offset(struct tracecmd_input *handle,
 			     struct tep_record *record)
 {
-	struct page *page = record->priv;
+	struct page *page = REC_PRIV(record)->page;
 	int offset;
 
 	if (!page)
-- 
2.37.3

