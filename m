Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDCA2106
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC0DC433C8;
	Wed, 11 Oct 2023 03:02:48 +0000 (UTC)
Date: Tue, 10 Oct 2023 23:02:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Do not just copy vals for delta elements
Message-ID: <20231010230246.74894849@rorschach.local.home>
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

The traceeval_delta_start() on update just copied the values that were
passed in, but these elements are part of the internal traceeval. That
means on release, the strings will be freed. If the vals are simply
copied, then what was passed in is going to be freed.

Instead, do the same thing that is done on adding a new element, and call
traceeval_insert() to handle the update.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/delta.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/src/delta.c b/src/delta.c
index 544998dff412..9f308189fe1d 100644
--- a/src/delta.c
+++ b/src/delta.c
@@ -176,6 +176,22 @@ int traceeval_delta_query_size(struct traceeval *teval,
 				    nr_keys, results);
 }
 
+static int insert_vals(struct traceeval *teval, const struct traceeval_data *keys,
+		       const struct traceeval_data *vals, unsigned long long ts)
+{
+	struct traceeval_data new_vals[teval->nr_val_types] = {};
+	int nr_vals = teval->nr_val_types - 1;
+	int i;
+
+	for (i = 0; i < nr_vals; i++)
+		new_vals[i] = vals[i];
+
+	TRACEEVAL_SET_NUMBER_64(new_vals[i], ts);
+
+	return _teval_insert(teval, keys, teval->nr_key_types,
+			     new_vals, teval->nr_val_types);
+}
+
 static int delta_start(struct traceeval *teval,
 		       const struct traceeval_data *keys, size_t nr_keys,
 		       const struct traceeval_data *vals, size_t nr_vals,
@@ -183,7 +199,6 @@ static int delta_start(struct traceeval *teval,
 {
 	struct entry *entry;
 	int ret;
-	int i;
 
 	if (!teval->tdelta) {
 		teval_print_err(TEVAL_WARN, "traceeval_delta_start/continue: traceeval does not have delta");
@@ -208,27 +223,10 @@ static int delta_start(struct traceeval *teval,
 	if (ret < 0)
 		return ret;
 
-	if (ret) {
-		if (cont && TEVAL_TIMESTAMP(teval, entry->vals))
-			return 0;
-
-		for (i = 0; i < nr_vals; i++)
-			entry->vals[i] = vals[i];
-
-		TRACEEVAL_SET_NUMBER_64(entry->vals[i], timestamp);
-
+	if (ret && cont && TEVAL_TIMESTAMP(teval, entry->vals))
 		return 0;
-	} else {
-		struct traceeval_data new_vals[teval->nr_val_types] = {};
-
-		for (i = 0; i < nr_vals; i++)
-			new_vals[i] = vals[i];
 
-		TRACEEVAL_SET_NUMBER_64(new_vals[i], timestamp);
-
-		return _teval_insert(teval, keys, teval->nr_key_types,
-				     new_vals, teval->nr_val_types);
-	}
+	return insert_vals(teval, keys, vals, timestamp);
 }
 
 /*
-- 
2.42.0

