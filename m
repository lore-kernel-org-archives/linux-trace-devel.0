Return-Path: <SRS0=hWWP=JT=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:56958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933569AbeGCQYd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Jul 2018 12:24:33 -0400
Message-Id: <20180703162432.480139641@goodmis.org>
Date: Tue, 03 Jul 2018 12:21:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 3/3] kernel-shark-qt: Add helper function to find the next_cpu in
 kshark_load_data_*()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The two functions kshark_load_data_entries() and
kshark_load_data_records() both do the same thing to find the next cpu to
load. Add a helper function pick_next_cpu() for both of them to use to
simplify the code.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark-qt/src/libkshark.c | 53 +++++++++++++++++----------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 680949077b7f..fe8aada75149 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -566,6 +566,25 @@ static size_t get_records(struct kshark_context *kshark_ctx,
 	return -ENOMEM;
 }
 
+static int pick_next_cpu(struct rec_list **rec_list, int n_cpus)
+{
+	uint64_t ts = 0;
+	int next_cpu = -1;
+	int cpu;
+
+	for (cpu = 0; cpu < n_cpus; ++cpu) {
+		if (!rec_list[cpu])
+			continue;
+
+		if (!ts || rec_list[cpu]->rec->ts < ts) {
+			ts = rec_list[cpu]->rec->ts;
+			next_cpu = cpu;
+		}
+	}
+
+	return next_cpu;
+}
+
 /**
  * @brief Load the content of the trace data file into an array of
  *	  kshark_entries. This function provides fast loading, however the
@@ -593,9 +612,8 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 	struct rec_list **rec_list;
 	struct rec_list *temp_rec;
 	struct pevent_record *rec;
-	int cpu, n_cpus, next_cpu;
 	size_t count, total = 0;
-	uint64_t ts;
+	int n_cpus;
 	int ret;
 
 	if (*data_rows)
@@ -612,17 +630,9 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 	n_cpus = tracecmd_cpus(kshark_ctx->handle);
 
 	for (count = 0; count < total; count++) {
-		ts = 0;
-		next_cpu = -1;
-		for (cpu = 0; cpu < n_cpus; ++cpu) {
-			if (!rec_list[cpu])
-				continue;
-
-			if (!ts || rec_list[cpu]->rec->ts < ts) {
-				ts = rec_list[cpu]->rec->ts;
-				next_cpu = cpu;
-			}
-		}
+		int next_cpu;
+
+		next_cpu = pick_next_cpu(rec_list, n_cpus);
 
 		if (next_cpu >= 0) {
 			entry = malloc(sizeof(struct kshark_entry));
@@ -694,9 +704,8 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	struct pevent_record *rec;
 	struct rec_list **rec_list;
 	struct rec_list *temp_rec;
-	int cpu, n_cpus, next_cpu;
 	size_t count, total = 0;
-	uint64_t ts;
+	int n_cpus;
 	int pid;
 
 	total = get_records(kshark_ctx, &rec_list);
@@ -710,17 +719,9 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	n_cpus = tracecmd_cpus(kshark_ctx->handle);
 
 	for (count = 0; count < total; count++) {
-		ts = 0;
-		next_cpu = -1;
-		for (cpu = 0; cpu < n_cpus; ++cpu) {
-			if (!rec_list[cpu])
-				continue;
-
-			if (!ts || rec_list[cpu]->rec->ts < ts) {
-				ts = rec_list[cpu]->rec->ts;
-				next_cpu = cpu;
-			}
-		}
+		int next_cpu;
+
+		next_cpu = pick_next_cpu(rec_list, n_cpus);
 
 		if (next_cpu >= 0) {
 			rec = rec_list[next_cpu]->rec;
-- 
2.17.1
