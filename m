Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8956154AE
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Sep 2023 09:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A605C433C8;
	Fri, 29 Sep 2023 09:59:32 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qmAIO-004Gu2-1Q;
	Fri, 29 Sep 2023 06:00:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtraceeval: Remove need to use TRACEEVAL_TYPE_NONE in keys and vals
Date: Fri, 29 Sep 2023 06:00:24 -0400
Message-Id: <20230929100025.1018258-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230929100025.1018258-1-rostedt@goodmis.org>
References: <20230929100025.1018258-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently, the size of the keys and vals are determined by the
requirement that the traceeval_type array end with an empty element of
type TRACEEVAL_TYPE_NONE.

To make the API be able to handle changes of the size of that structure,
the traceeval_init() was converted to a macro to pass in the sizeof of
that structure. This also means it can calculate the size of the array
with the TRACEEVAL_ARRAY_SIZE() macro.

Remove the need to have the initialization of traceeval keys and vals
have to add the NONE element at the end. It can still do so and this
will work just the same (the size will be determined by either the size
passed in or the first NONE element, which ever is smaller).

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 11 +++++++++--
 src/histograms.c         | 11 +++++++----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 65a905034773..cd089b28b852 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -171,12 +171,19 @@ struct traceeval;
 
 /* Histogram interfaces */
 
-#define traceeval_init(keys, vals) \
-	traceeval_init_data_size(keys, vals, sizeof(struct traceeval_type), \
+#define traceeval_init(keys, vals)					\
+	traceeval_init_size(keys, vals,					\
+			    TRACEEVAL_ARRAY_SIZE(keys),			\
+			    (void *)vals == NULL ?  0 : TRACEEVAL_ARRAY_SIZE(vals))
+
+#define traceeval_init_size(keys, vals, nr_keys, nr_vals)		\
+	traceeval_init_data_size(keys, vals, nr_keys, nr_vals,		\
+				 sizeof(struct traceeval_type),		\
 				 sizeof(struct traceeval_data))
 
 struct traceeval *traceeval_init_data_size(struct traceeval_type *keys,
 					   struct traceeval_type *vals,
+					   size_t nr_keys, size_t nr_vals,
 					   size_t sizeof_type, size_t sizeof_data);
 
 void traceeval_release(struct traceeval *teval);
diff --git a/src/histograms.c b/src/histograms.c
index ac3f7f7c76cc..5a98473c91c6 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -151,7 +151,8 @@ static void type_release(struct traceeval_type *defs, size_t len)
  * Returns the size of the array pointed to by @copy, or -1 on error.
  */
 static size_t type_alloc(const struct traceeval_type *defs,
-			 struct traceeval_type **copy)
+			 struct traceeval_type **copy,
+			 size_t cnt)
 {
 	struct traceeval_type *new_defs = NULL;
 	size_t size;
@@ -162,7 +163,8 @@ static size_t type_alloc(const struct traceeval_type *defs,
 	if (!defs)
 		return 0;
 
-	for (size = 0; defs && defs[size].type != TRACEEVAL_TYPE_NONE; size++)
+	for (size = 0; defs && size < cnt &&
+		     defs[size].type != TRACEEVAL_TYPE_NONE; size++)
 		;
 
 	if (!size)
@@ -269,6 +271,7 @@ static int check_vals(struct traceeval_type *vals)
  */
 struct traceeval *traceeval_init_data_size(struct traceeval_type *keys,
 					   struct traceeval_type *vals,
+					   size_t nr_keys, size_t nr_vals,
 					   size_t sizeof_type, size_t sizeof_data)
 {
 	struct traceeval *teval;
@@ -301,14 +304,14 @@ struct traceeval *traceeval_init_data_size(struct traceeval_type *keys,
 	}
 
 	/* alloc key types */
-	teval->nr_key_types = type_alloc(keys, &teval->key_types);
+	teval->nr_key_types = type_alloc(keys, &teval->key_types, nr_keys);
 	if ((ssize_t)teval->nr_key_types <= 0) {
 		err_msg = "Failed to allocate user defined keys";
 		goto fail_release;
 	}
 
 	/* alloc val types */
-	teval->nr_val_types = type_alloc(vals, &teval->val_types);
+	teval->nr_val_types = type_alloc(vals, &teval->val_types, nr_vals);
 	if ((ssize_t)teval->nr_val_types < 0) {
 		err_msg = "Failed to allocate user defined values";
 		goto fail_release;
-- 
2.40.1

