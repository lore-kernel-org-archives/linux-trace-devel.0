Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983F7347CD
	for <linux-trace-devel@vger.kernel.org>; Thu, 12 Oct 2023 18:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BE0C433C8;
	Thu, 12 Oct 2023 18:17:20 +0000 (UTC)
Date: Thu, 12 Oct 2023 14:18:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Remove sizeof() checks from
 traceeval_data_create_size()
Message-ID: <20231012141845.68116b67@gandalf.local.home>
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

The first version of the traceeval_delta required the user to create the
type externally. That was cumbersome and was changed to simply use:

  traceeval_delta_create()

to create a delta element of an existing traceeval. As the original
version did not depend on an existing traceeval, it had to have the
sizeof checks on the traceeval structures in case they ever change in the
future.

Now that the code requires an existing traceeval to create a
traceeval_delta, the checks have already been done at the creation of the
traceeval itself. No need to repeat the checks in traceeval_data_create().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval.h | 15 ++++-----------
 src/delta.c         | 21 ++++++++-------------
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/include/traceeval.h b/include/traceeval.h
index 99b3f7b86915..9b723f30e1d6 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -287,17 +287,10 @@ size_t traceeval_count(struct traceeval *teval);
 				  TRACEEVAL_ARRAY_SIZE(keys),		\
 				  TRACEEVAL_ARRAY_SIZE(vals))
 
-#define traceeval_delta_create_size(teval, keys, vals, nr_keys, nr_vals) \
-	traceeval_delta_create_data_size(teval, keys, vals, nr_keys, nr_vals, \
-				       sizeof(struct traceeval_type),	\
-				       sizeof(struct traceeval_data))
-
-int traceeval_delta_create_data_size(struct traceeval *teval,
-				     struct traceeval_type *keys,
-				     struct traceeval_type *vals,
-				     size_t nr_keys, size_t nr_vals,
-				     size_t sizeof_type,
-				     size_t sizeof_data);
+int traceeval_delta_create_size(struct traceeval *teval,
+				struct traceeval_type *keys,
+				struct traceeval_type *vals,
+				size_t nr_keys, size_t nr_vals);
 
 int traceeval_delta_start_size(struct traceeval *teval,
 			       const struct traceeval_data *keys, size_t nr_keys,
diff --git a/src/delta.c b/src/delta.c
index c83aa9a39756..c802959e9d89 100644
--- a/src/delta.c
+++ b/src/delta.c
@@ -23,14 +23,12 @@ struct traceeval_delta {
 #define TEVAL_TIMESTAMP_NAME	"__TRACEEVAL_DELTA_TIMESTAMP__"
 
 /**
- * traceeval_delta_create_data_size - create a delta for a teval
+ * traceeval_delta_create_size - create a delta for a teval
  * @teval: The traceeval to create a delta query for
  * @keys: Defines the keys to differentiate traceeval delta entries
  * @vals: Defines values attached to entries differentiated by @keys.
  * @nr_keys: The number of @keys passed in
  * @nr_vals: The number of @vals passed in
- * @sizeof_type: The size of struct traceeval_type
- * @sizeof_data: The size of struct traceeval_data
  *
  * This adds a specialized internal traceeval descriptor to @teval.
  * This descriptor is used to find the start and stop timings between
@@ -44,13 +42,11 @@ struct traceeval_delta {
  *
  * Returns 0 on success and -1 on error.
  */
-int traceeval_delta_create_data_size(struct traceeval *teval,
-				     struct traceeval_type *keys,
-				     struct traceeval_type *vals,
-				     size_t nr_keys,
-				     size_t nr_vals,
-				     size_t sizeof_type,
-				     size_t sizeof_data)
+int traceeval_delta_create_size(struct traceeval *teval,
+				struct traceeval_type *keys,
+				struct traceeval_type *vals,
+				size_t nr_keys,
+				size_t nr_vals)
 {
 	struct traceeval_type *delta_vals;
 	struct traceeval_type *val;
@@ -90,9 +86,8 @@ int traceeval_delta_create_data_size(struct traceeval *teval,
 	val->name = TEVAL_TIMESTAMP_NAME;
 	val->type = TRACEEVAL_TYPE_NUMBER_64;
 
-	tdelta->teval = traceeval_init_data_size(keys, delta_vals, nr_keys,
-						 nr_vals, sizeof_type,
-						 sizeof_data);
+	tdelta->teval = traceeval_init_size(keys, delta_vals, nr_keys, nr_vals);
+
 	/* The delta_vals are no longer needed */
 	free(delta_vals);
 
-- 
2.42.0

