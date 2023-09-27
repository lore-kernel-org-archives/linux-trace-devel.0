Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C129026E16
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6892AC433A9;
	Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qlTj9-0049Ts-0q;
	Wed, 27 Sep 2023 08:33:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 08/11] libtraceeval: Add size checks to insert and query functions
Date: Wed, 27 Sep 2023 08:33:11 -0400
Message-Id: <20230927123314.989589-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230927123314.989589-1-rostedt@goodmis.org>
References: <20230927123314.989589-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently, there's nothing that checks the size of the keys/values being
passed into traceeval_query() and traceeval_insert(). Make functions that
take the size of those arrays:

   traceeval_query_size()
   traceeval_insert_size()

and convert the traceeval_query() and traceeval_insert() into macros that
calculate the size of the fields to pass in:

  #define TRACEEVAL_ARRAY_SIZE(data)  \
     	(sizeof(data) / sizeof((data)[0]))

  #define traceeval_query(teval, keys, results) \
     traceeval_query_size(teval, TRACEEVAL_ARRAY_SIZE(keys), results)

and this will allow the code to check to make sure the size matches what
is expected (note, that currently is not done, but can be added).

If the keys or vals is not an array, but instead a pointer, if one of the
macros is used, the compiler will complain with:

 warning: division sizeof (const struct traceeval_data *) / sizeof (const struct traceeval_data)
          does not compute the number of array elements [-Wsizeof-pointer-div]
   20 | #define TRACEEVAL_ARRAY_SIZE(data)      (sizeof(data) / sizeof((data)[0]))
      |                                                       ^
 include/traceeval-hist.h:206:43: note: in expansion of macro TRACEEVAL_ARRAY_SIZE
  206 |         traceeval_query_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), results)
      |                                           ^~~~~~~~~~~~~~~~~~~~

Then the user would need to call the "_size()" function directly
(as is done in the sample code, where the keys received by an iterator is
 used for a query)

Now that there are size functions for traceeval_insert() and
traceveal_query(), add checks to make sure that the size being passed in
is actually the size expected.

Reviewed-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 19 ++++++++++++++-----
 src/histograms.c         | 16 +++++++++++-----
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 78cfac5982ee..7f48bb92cc96 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -17,6 +17,8 @@
 /* Field name/descriptor for number of hits */
 #define TRACEEVAL_VAL_HITS ((const char *)(-1UL))
 
+#define TRACEEVAL_ARRAY_SIZE(data)	(sizeof(data) / sizeof((data)[0]))
+
 /* Data type distinguishers */
 enum traceeval_data_type {
 	TRACEEVAL_TYPE_NONE,
@@ -186,15 +188,22 @@ struct traceeval *traceeval_init(struct traceeval_type *keys,
 
 void traceeval_release(struct traceeval *teval);
 
-int traceeval_insert(struct traceeval *teval,
-		     const struct traceeval_data *keys,
-		     const struct traceeval_data *vals);
+int traceeval_insert_size(struct traceeval *teval,
+			  const struct traceeval_data *keys, size_t nr_keys,
+			  const struct traceeval_data *vals, size_t nr_vals);
+
+#define traceeval_insert(teval, keys, vals)				\
+	traceeval_insert_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), \
+			      vals, TRACEEVAL_ARRAY_SIZE(vals))
 
 int traceeval_remove(struct traceeval *teval,
 		     const struct traceeval_data *keys);
 
-int traceeval_query(struct traceeval *teval, const struct traceeval_data *keys,
-		    const struct traceeval_data **results);
+int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *keys,
+			 size_t nr_keys, const struct traceeval_data **results);
+
+#define traceeval_query(teval, keys, results)				\
+	traceeval_query_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), results)
 
 void traceeval_results_release(struct traceeval *teval,
 			       const struct traceeval_data *results);
diff --git a/src/histograms.c b/src/histograms.c
index 954042da28e4..ab8a560fe14d 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -675,8 +675,8 @@ fail:
  *
  * Returns 1 if found, 0 if not found, and -1 on error.
  */
-int traceeval_query(struct traceeval *teval, const struct traceeval_data *keys,
-		    const struct traceeval_data **results)
+int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *keys,
+			 size_t nr_keys, const struct traceeval_data **results)
 {
 	struct entry *entry;
 	int check;
@@ -684,6 +684,9 @@ int traceeval_query(struct traceeval *teval, const struct traceeval_data *keys,
 	if (!teval || !keys || !results)
 		return -1;
 
+	if (nr_keys != teval->nr_key_types)
+		return -1;
+
 	/* find key and copy its corresponding value pair */
 	if ((check = get_entry(teval, keys, &entry)) < 1)
 		return check;
@@ -933,14 +936,17 @@ unsigned long long traceeval_stat_count(struct traceeval_stat *stat)
  *
  * Returns 0 on success, and -1 on error.
  */
-int traceeval_insert(struct traceeval *teval,
-		     const struct traceeval_data *keys,
-		     const struct traceeval_data *vals)
+int traceeval_insert_size(struct traceeval *teval,
+			  const struct traceeval_data *keys, size_t nr_keys,
+			  const struct traceeval_data *vals, size_t nr_vals)
 {
 	struct entry *entry;
 	int check;
 	int i;
 
+	if (nr_keys != teval->nr_key_types || nr_vals != teval->nr_val_types)
+		return -1;
+
 	entry = NULL;
 	check = get_entry(teval, keys, &entry);
 
-- 
2.40.1

