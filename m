Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A8739922
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 22:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4308AC433C8;
	Wed, 11 Oct 2023 22:05:57 +0000 (UTC)
Date: Wed, 11 Oct 2023 18:07:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Add generic message about bad nr_keys/vals
Message-ID: <20231011180719.663ac16a@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the helper function teval_print_failed_count() that will warn about a
mismatch of nr_keys vs teval->nr_key_types as well as nr_vals vs
teval->nr_val_types.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/delta.c      |  8 ++++----
 src/eval-local.h |  3 +++
 src/histograms.c | 30 ++++++++++++++++++++----------
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/src/delta.c b/src/delta.c
index 9f308189fe1d..c83aa9a39756 100644
--- a/src/delta.c
+++ b/src/delta.c
@@ -208,14 +208,14 @@ static int delta_start(struct traceeval *teval,
 	teval = teval->tdelta->teval;
 
 	if (nr_keys != teval->nr_key_types) {
-		teval_print_err(TEVAL_WARN, "traceeval_delta_start/continue: Received %zd keys but expected %zd",
-				nr_keys, teval->nr_key_types);
+		teval_print_failed_count("traceeval_delta_start/continue", "keys",
+					 nr_keys, teval->nr_key_types);
 		return -1;
 	}
 
 	if (nr_vals != teval->nr_val_types - 1) {
-		teval_print_err(TEVAL_WARN, "traceeval_delta_start/continue: Received %zd vals but expected %zd",
-				nr_vals, teval->nr_val_types - 1);
+		teval_print_failed_count("traceeval_delta_start/continue", "vals",
+					 nr_vals, teval->nr_val_types - 1);
 		return -1;
 	}
 
diff --git a/src/eval-local.h b/src/eval-local.h
index 5ae63841f39f..6ae61cf41922 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -108,6 +108,9 @@ extern void teval_print_failed_type(const char *type,
 				    const struct traceeval_type *expect,
 				    const struct traceeval_data *got);
 
+extern void teval_print_failed_count(const char *func, const char *type,
+				     size_t cnt, size_t expect);
+
 extern int _teval_get_entry(struct traceeval *teval, const struct traceeval_data *keys,
 			    struct entry **result);
 
diff --git a/src/histograms.c b/src/histograms.c
index 3323fcacae4a..572f33eb3ac6 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -90,6 +90,13 @@ __hidden void teval_print_failed_type(const char *type,
 			get_type_name(expect->type));
 }
 
+__hidden void teval_print_failed_count(const char *func, const char *type,
+				       size_t cnt, size_t expect)
+{
+	teval_print_err(TEVAL_WARN, "%s: %s array size is %zd but expected %zd",
+				func, type, cnt, expect);
+}
+
 /*
  * Compare traceeval_data instances.
  *
@@ -871,8 +878,8 @@ int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *k
 	}
 
 	if (nr_keys != teval->nr_key_types) {
-		teval_print_err(TEVAL_WARN, "traceeval_query: key array size is %zd but expected %zd",
-				nr_keys, teval->nr_key_types);
+		teval_print_failed_count("traceeval_query", "key",
+					 nr_keys, teval->nr_key_types);
 		return -1;
 	}
 
@@ -1057,8 +1064,11 @@ struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
 	struct entry *entry;
 	int ret;
 
-	if (teval->nr_key_types != nr_keys)
+	if (nr_keys != teval->nr_key_types) {
+		teval_print_failed_count("traceeval_stat", "key",
+					 nr_keys, teval->nr_key_types);
 		return NULL;
+	}
 
 	type = find_val_type(teval, val_name);
 	if (!type)
@@ -1248,14 +1258,14 @@ int traceeval_insert_size(struct traceeval *teval,
 			  const struct traceeval_data *vals, size_t nr_vals)
 {
 	if (nr_keys != teval->nr_key_types) {
-		teval_print_err(TEVAL_WARN, "traceeval_insert: received %zd keys but expected %zd",
-				nr_keys, teval->nr_key_types);
+		teval_print_failed_count("traceeval_insert", "key",
+					 nr_keys, teval->nr_key_types);
 		return -1;
 	}
 
 	if (nr_vals != teval->nr_val_types) {
-		teval_print_err(TEVAL_WARN, "traceeval_insert: received %zd vals but expected %zd",
-				nr_vals, teval->nr_val_types);
+		teval_print_failed_count("traceeval_insert", "vals",
+					 nr_vals, teval->nr_val_types);
 		return -1;
 	}
 
@@ -1282,9 +1292,9 @@ int traceeval_remove_size(struct traceeval *teval,
 	struct entry *entry;
 	int check;
 
-	if (teval->nr_key_types != nr_keys) {
-		teval_print_err(TEVAL_WARN, "traceeval_remove: received %zd keys but expected %zd",
-				nr_keys, teval->nr_key_types);
+	if (nr_keys != teval->nr_key_types) {
+		teval_print_failed_count("traceeval_remove", "keys",
+					 nr_keys, teval->nr_key_types);
 		return -1;
 	}
 
-- 
2.42.0

