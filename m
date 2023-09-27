Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE1315AFA
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 13:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B145CC433C7;
	Wed, 27 Sep 2023 13:09:07 +0000 (UTC)
Date: Wed, 27 Sep 2023 09:09:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: [PATCH] libtraceeval: Add traceeval_init_data_size()
Message-ID: <20230927090904.396273fa@rorschach.local.home>
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

In the future, the traceeval_type and traceeval_data may need to include
more information and be expanded. If that happens, it will break backward
compatibility for older applications using the newer library.

To be able to handle backward compatibility in this situation, have the
traceeval_init() turn into traceeval_init_data_size() which takes the
sizeof struct traceeval_type and struct traceeval_data. Make
traceeval_init() into a macro that calls this function passing in the
sizeof(struct traceeval_type) and sizeof(struct traceeval_data). This way
if the sizes change for either one, the new code will know if the
application is using the new interface or the older one, and can
can keep the older one still functioning properly.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |  9 +++++++--
 src/eval-local.h         |  2 ++
 src/histograms.c         | 16 +++++++++++++---
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 396054e14a6f..eefa48d5d772 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -171,8 +171,13 @@ struct traceeval;
 
 /* Histogram interfaces */
 
-struct traceeval *traceeval_init(struct traceeval_type *keys,
-				 struct traceeval_type *vals);
+#define traceeval_init(keys, vals) \
+	traceeval_init_data_size(keys, vals, sizeof(struct traceeval_type), \
+				 sizeof(struct traceeval_data))
+
+struct traceeval *traceeval_init_data_size(struct traceeval_type *keys,
+					   struct traceeval_type *vals,
+					   size_t sizeof_type, size_t sizeof_data);
 
 void traceeval_release(struct traceeval *teval);
 
diff --git a/src/eval-local.h b/src/eval-local.h
index 26b3c9b29929..f0917b6a45e9 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -69,6 +69,8 @@ struct traceeval {
 	size_t				nr_key_types;
 	size_t				nr_val_types;
 	size_t				update_counter;
+	size_t				sizeof_type;
+	size_t				sizeof_data;
 };
 
 struct traceeval_iterator {
diff --git a/src/histograms.c b/src/histograms.c
index 1d7002b66dac..24563423ab99 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -233,9 +233,11 @@ static int check_vals(struct traceeval_type *vals)
 }
 
 /*
- * traceeval_init - create a traceeval descriptor
+ * traceeval_init_data_size - create a traceeval descriptor
  * @keys: Defines the keys to differentiate traceeval entries
  * @vals: Defines values attached to entries differentiated by @keys.
+ * @sizeof_type: The size of struct traceeval_type
+ * @sizeof_data: The size of struct traceeval_data
  *
  * The @keys and @vals define how the traceeval instance will be populated.
  * The @keys will be used by traceeval_query() to find an instance within
@@ -259,10 +261,15 @@ static int check_vals(struct traceeval_type *vals)
  * @keys must be populated with at least one element that is not of type
  * TRACEEVAL_TYPE_NONE.
  *
+ * The @sizeof_type and @sizeof_data are used to handle backward compatibility
+ * in the event that items are added to them. All the existing functions
+ * will still need to work with the older sizes.
+ *
  * Returns the descriptor on success, or NULL on error.
  */
-struct traceeval *traceeval_init(struct traceeval_type *keys,
-				 struct traceeval_type *vals)
+struct traceeval *traceeval_init_data_size(struct traceeval_type *keys,
+					   struct traceeval_type *vals,
+					   size_t sizeof_type, size_t sizeof_data)
 {
 	struct traceeval *teval;
 	char *err_msg;
@@ -314,6 +321,9 @@ struct traceeval *traceeval_init(struct traceeval_type *keys,
 		goto fail_release;
 	}
 
+	teval->sizeof_type = sizeof_type;
+	teval->sizeof_data = sizeof_data;
+
 	return teval;
 
 fail_release:
-- 
2.40.1

