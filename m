Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301626106
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B599C433C8;
	Wed, 11 Oct 2023 03:08:56 +0000 (UTC)
Date: Tue, 10 Oct 2023 23:08:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Fix some missing frees
Message-ID: <20231010230855.094adc42@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Free entry val_stats array for each element when freeing a traceeval.

Free the internal delta of a traceeval.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/histograms.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/histograms.c b/src/histograms.c
index ea44814b7693..e16f0e9e903e 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -485,6 +485,7 @@ static void free_entry(struct traceeval *teval, struct entry *entry)
 
 	clean_data_set(entry->keys, teval->key_types, teval->nr_key_types);
 	clean_data_set(entry->vals, teval->val_types, teval->nr_val_types);
+	free(entry->val_stats);
 
 	free(entry);
 }
@@ -527,6 +528,7 @@ void traceeval_release(struct traceeval *teval)
 	if (!teval)
 		return;
 
+	__delta_release(teval->tdelta);
 	hist_table_release(teval);
 	type_release(teval->key_types, teval->nr_key_types);
 	type_release(teval->val_types, teval->nr_val_types);
-- 
2.42.0

