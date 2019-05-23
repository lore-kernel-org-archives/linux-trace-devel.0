Return-Path: <SRS0=hb2W=TX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853B9C282DD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B82020856
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbfEWPKH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 May 2019 11:10:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34599 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730672AbfEWPKH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 May 2019 11:10:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id f8so6716359wrt.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 May 2019 08:10:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XWZrADjqmO8GGNZryUluJSS1DKCO4GWML2KP6hlMCHY=;
        b=OfoqwdZ2UZbePEuXQ5QD+X5VeVdD/Rp5hLUqZeLiHhfgNVDCf4iZeZNcyff5lnil2E
         MTmr8lQJMyPbfSkZ0lkMOAZqv7vG8n52suiML9c6IGvjbW7+o7To5iPBb/2B2BsdpArO
         E3FAlQFwgAtxGU/dZLVjUhvC8XaSqWdzGhQDXKversOXwLyxmq3BOw1ScjhthdyYfwrJ
         rj1VkQG5YRT+l8asix+IJNJUUwmXXKsqS10SyneQr4gWtzgXYcHvb9oFGOBM1ueHCjel
         ic1gGexdc3ohF9qQPD08Ly4+I0uShQSHd92yt4IjxHuycF4EIw1w5OmFNfQlglbJXRa1
         71DQ==
X-Gm-Message-State: APjAAAU8Kq3tDZAq/chz6pifDhCDc5yiIQMW3tgLbXcDrqRyAUi4InAN
        j5WStVzo6NPVLut/AAck5jm3SWuM
X-Google-Smtp-Source: APXvYqzibnotQfmhiQW3dXehmlvO7/ckV3JSqN3FzgJESMHv1kChZOSAUumvSAO+PeLR/KQGfspwjQ==
X-Received: by 2002:a05:6000:11c8:: with SMTP id i8mr3044460wrx.175.1558624205138;
        Thu, 23 May 2019 08:10:05 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id k63sm10721996wmf.35.2019.05.23.08.10.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:10:04 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/3] kernel-shark: Handle properly the negative error codes when loading data
Date:   Thu, 23 May 2019 18:09:45 +0300
Message-Id: <20190523150946.30769-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523150946.30769-1-ykaradzhov@vmware.com>
References: <20190523150946.30769-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

get_records() can return negative error codes. This means that we alway
have to use signed integer types for the "data size" variables / fields.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/examples/datafilter.c |  6 +++++-
 kernel-shark/examples/datahisto.c  |  6 +++++-
 kernel-shark/examples/dataload.c   |  6 +++++-
 kernel-shark/src/KsMainWindow.cpp  |  9 ++++-----
 kernel-shark/src/KsUtils.cpp       |  6 +++---
 kernel-shark/src/KsUtils.hpp       |  4 ++--
 kernel-shark/src/libkshark.c       | 13 +++++++------
 7 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/kernel-shark/examples/datafilter.c b/kernel-shark/examples/datafilter.c
index 688e581..bebc181 100644
--- a/kernel-shark/examples/datafilter.c
+++ b/kernel-shark/examples/datafilter.c
@@ -15,7 +15,7 @@ const char *default_file = "trace.dat";
 
 int main(int argc, char **argv)
 {
-	size_t i, n_rows, n_tasks, n_evts, count;
+	ssize_t i, n_rows, n_tasks, n_evts, count;
 	struct kshark_context *kshark_ctx;
 	struct kshark_entry **data = NULL;
 	struct tep_event_filter *adv_filter;
@@ -42,6 +42,10 @@ int main(int argc, char **argv)
 
 	/* Load the content of the file into an array of entries. */
 	n_rows = kshark_load_data_entries(kshark_ctx, &data);
+	if (n_rows < 1) {
+		kshark_free(kshark_ctx);
+		return 1;
+	}
 
 	/* Filter the trace data coming from trace-cmd. */
 	n_tasks = kshark_get_task_pids(kshark_ctx, &pids);
diff --git a/kernel-shark/examples/datahisto.c b/kernel-shark/examples/datahisto.c
index 99ac495..02c6285 100644
--- a/kernel-shark/examples/datahisto.c
+++ b/kernel-shark/examples/datahisto.c
@@ -80,7 +80,7 @@ int main(int argc, char **argv)
 	struct kshark_context *kshark_ctx;
 	struct kshark_entry **data = NULL;
 	struct kshark_trace_histo histo;
-	size_t i, n_rows, n_tasks;
+	ssize_t i, n_rows, n_tasks;
 	bool status;
 	int *pids;
 
@@ -102,6 +102,10 @@ int main(int argc, char **argv)
 
 	/* Load the content of the file into an array of entries. */
 	n_rows = kshark_load_data_entries(kshark_ctx, &data);
+	if (n_rows < 1) {
+		kshark_free(kshark_ctx);
+		return 1;
+	}
 
 	/* Get a list of all tasks. */
 	n_tasks = kshark_get_task_pids(kshark_ctx, &pids);
diff --git a/kernel-shark/examples/dataload.c b/kernel-shark/examples/dataload.c
index 0cbc0f6..15c5de0 100644
--- a/kernel-shark/examples/dataload.c
+++ b/kernel-shark/examples/dataload.c
@@ -17,7 +17,7 @@ int main(int argc, char **argv)
 {
 	struct kshark_context *kshark_ctx;
 	struct kshark_entry **data = NULL;
-	size_t r, n_rows, n_tasks;
+	ssize_t r, n_rows, n_tasks;
 	char *entry_str;
 	bool status;
 	int *pids;
@@ -40,6 +40,10 @@ int main(int argc, char **argv)
 
 	/* Load the content of the file into an array of entries. */
 	n_rows = kshark_load_data_entries(kshark_ctx, &data);
+	if (n_rows < 1) {
+		kshark_free(kshark_ctx);
+		return 1;
+	}
 
 	/* Print to the screen the list of all tasks. */
 	n_tasks = kshark_get_task_pids(kshark_ctx, &pids);
diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index c7c7f6b..1e03632 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -515,7 +515,7 @@ void KsMainWindow::_importFilter()
 	kshark_config_doc *conf;
 	QString fileName;
 
-	if (!kshark_instance(&kshark_ctx))
+	if (!kshark_instance(&kshark_ctx) || _data.size() < 1)
 		return;
 
 	fileName = KsUtils::getFile(this, "Import Filter",
@@ -995,11 +995,10 @@ void KsMainWindow::loadDataFile(const QString& fileName)
 
 	tload.join();
 
-	if (!_data.size()) {
-		QString text("File ");
+	if (_data.size() < 1) {
+		QString text("No data was loaded from file ");
 
-		text.append(fileName);
-		text.append(" contains no data.");
+		text.append(fileName + ".");
 		_error(text, "loadDataErr2", true, true);
 
 		return;
diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index dcedd7b..58ce8c1 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -306,14 +306,14 @@ void KsDataStore::loadDataFile(const QString &file)
 
 void KsDataStore::_freeData()
 {
-	if (_dataSize) {
-		for (size_t r = 0; r < _dataSize; ++r)
+	if (_dataSize > 0) {
+		for (ssize_t r = 0; r < _dataSize; ++r)
 			free(_rows[r]);
 
 		free(_rows);
-		_rows = nullptr;
 	}
 
+	_rows = nullptr;
 	_dataSize = 0;
 }
 
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index b4663da..7362c14 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -161,7 +161,7 @@ public:
 	struct kshark_entry **rows() const {return _rows;}
 
 	/** Get the size of the data array. */
-	size_t size() const {return _dataSize;}
+	ssize_t size() const {return _dataSize;}
 
 	void reload();
 
@@ -198,7 +198,7 @@ private:
 	struct kshark_entry	**_rows;
 
 	/** The size of the data array. */
-	size_t			_dataSize;
+	ssize_t			_dataSize;
 
 	void _freeData();
 	void _unregisterCPUCollections();
diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 654aaa9..b0018f8 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -680,8 +680,8 @@ static void free_rec_list(struct rec_list **rec_list, int n_cpus,
 	free(rec_list);
 }
 
-static size_t get_records(struct kshark_context *kshark_ctx,
-			  struct rec_list ***rec_list, enum rec_type type)
+static ssize_t get_records(struct kshark_context *kshark_ctx,
+			   struct rec_list ***rec_list, enum rec_type type)
 {
 	struct kshark_event_handler *evt_handler;
 	struct tep_event_filter *adv_filter;
@@ -851,12 +851,12 @@ static int pick_next_cpu(struct rec_list **rec_list, int n_cpus,
  *	    negative error code on failure.
  */
 ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
-				struct kshark_entry ***data_rows)
+				 struct kshark_entry ***data_rows)
 {
 	struct kshark_entry **rows;
 	struct rec_list **rec_list;
 	enum rec_type type = REC_ENTRY;
-	size_t count, total = 0;
+	ssize_t count, total = 0;
 	int n_cpus;
 
 	if (*data_rows)
@@ -895,6 +895,7 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 		free(rows[count]);
 	}
 	free(rows);
+
  fail:
 	fprintf(stderr, "Failed to allocate memory during data loading.\n");
 	return -ENOMEM;
@@ -913,14 +914,14 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
  *	    negative error code on failure.
  */
 ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
-				struct tep_record ***data_rows)
+				 struct tep_record ***data_rows)
 {
 	struct tep_record **rows;
 	struct tep_record *rec;
 	struct rec_list **rec_list;
 	struct rec_list *temp_rec;
 	enum rec_type type = REC_RECORD;
-	size_t count, total = 0;
+	ssize_t count, total = 0;
 	int n_cpus;
 
 	total = get_records(kshark_ctx, &rec_list, REC_RECORD);
-- 
2.20.1

