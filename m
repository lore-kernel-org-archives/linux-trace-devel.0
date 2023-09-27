Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BBBC8E2
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 13:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DF9C433C7;
	Wed, 27 Sep 2023 13:04:21 +0000 (UTC)
Date: Wed, 27 Sep 2023 09:04:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: [PATCH] libtraceveal: Remove TRACEEVAL_TYPE_DYNAMIC
Message-ID: <20230927090417.6cd02a37@rorschach.local.home>
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

There currently is not a known use case for the traceeval_dynamic type.
Remove it until there is one.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 23 +++++------------------
 src/histograms.c         | 25 +++++++------------------
 2 files changed, 12 insertions(+), 36 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 618e67593dc0..396054e14a6f 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -29,7 +29,6 @@ enum traceeval_data_type {
 	TRACEEVAL_TYPE_NUMBER,
 	TRACEEVAL_TYPE_POINTER,
 	TRACEEVAL_TYPE_STRING,
-	TRACEEVAL_TYPE_DYNAMIC
 };
 
 /* Statistics specification flags */
@@ -41,16 +40,6 @@ enum traceeval_flags {
 	TRACEEVAL_FL_STAT		= (1 << 4),
 };
 
-/*
- * struct traceeval_dynamic - Storage for dynamic traceeval_types
- * @size: The size of the dynamic type
- * @data: The pointer to the data of the dynamic type
- */
-struct traceeval_dynamic {
-	void		*data;
-	size_t		size;
-};
-
 /*
  * Trace data entry for a traceeval histogram
  * Constitutes keys and values.
@@ -58,7 +47,6 @@ struct traceeval_dynamic {
 struct traceeval_data {
 	enum traceeval_data_type		type;
 	union {
-		struct traceeval_dynamic	dyn_data;
 		char				*string;
 		const char			*cstring;
 		void				*pointer;
@@ -140,12 +128,11 @@ typedef int (*traceeval_cmp_fn)(struct traceeval *teval,
  * describe both keys and values.
  *
  * The @id field is an optional value in case the user has multiple struct
- * traceeval_type instances with @type fields set to TRACEEVAL_TYPE_DYNAMIC,
- * which each relate to distinct user defined struct traceeval_dynamic
+ * traceeval_type instances and needs to distinguish between them into
  * 'sub-types'.
  *
  * For flexibility, @cmp() and @release() take a struct traceeval_type
- * instance. This allows the user to handle dyn_data and pointer types.
+ * instance. This allows the user to handle pointer types.
  * It may also be used for other types if the default cmp() or release()
  * need to be overridden. Note for string types, even if the release()
  * is called, the string freeing is still taken care of by the traceeval
@@ -156,9 +143,9 @@ typedef int (*traceeval_cmp_fn)(struct traceeval *teval,
  * name (could be used for switch statements).
  *
  * @cmp() is used to override the default compare of a type. This is
- * required to compare dyn_data and pointer types. It should return 0
- * on equality, 1 if the first argument is greater than the second,
- * -1 for the other way around, and -2 on error.
+ * required to pointer types. It should return 0 on equality, 1 if the first
+ * argument is greater than the second, -1 for the other way around,
+ * and -2 on error.
  *
  * @release() is called when a data element is being released (or freed).
  */
diff --git a/src/histograms.c b/src/histograms.c
index 0a3ab84d288e..1d7002b66dac 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -74,10 +74,6 @@ static int compare_traceeval_data(struct traceeval *teval,
 	case TRACEEVAL_TYPE_NUMBER_8:
 		compare_numbers_return(orig->number_8, copy->number_8);
 
-	case TRACEEVAL_TYPE_DYNAMIC:
-		/* If it didn't specify a cmp function, then punt */
-		return 0;
-
 	default:
 		print_err("%d is an invalid enum traceeval_data_type member",
 				type->type);
@@ -213,11 +209,7 @@ static int check_keys(struct traceeval_type *keys)
 
 		switch (keys[i].type) {
 		case TRACEEVAL_TYPE_POINTER:
-		case TRACEEVAL_TYPE_DYNAMIC:
-			/*
-			 * Key pointers and dynamic types must have a
-			 * cmp and hash function
-			 */
+			/* Key pointer types must have a cmp and hash function */
 			if (!keys[i].cmp || !keys[i].hash)
 				return -1;
 			break;
@@ -333,7 +325,7 @@ fail:
 }
 
 /*
- * Frees dynamic data in @data if @type specifies a dynamic data type.
+ * Free up allocated data.
  */
 static void clean_data(struct traceeval_data *data, struct traceeval_type *type)
 {
@@ -350,7 +342,7 @@ static void clean_data(struct traceeval_data *data, struct traceeval_type *type)
 }
 
 /*
- * Free any specified dynamic data in @data.
+ * Free up allocated memory from @data.
  */
 static void clean_data_set(struct traceeval_data *data, struct traceeval_type *defs,
 		       size_t size)
@@ -377,7 +369,6 @@ static void free_entry(struct traceeval *teval, struct entry *entry)
 	if (!entry)
 		return;
 
-	/* free dynamic traceeval_data */
 	clean_data_set(entry->keys, teval->key_types, teval->nr_key_types);
 	clean_data_set(entry->vals, teval->val_types, teval->nr_val_types);
 
@@ -415,8 +406,7 @@ static void hist_table_release(struct traceeval *teval)
  * it must call traceeval_release().
  *
  * This frees all internally allocated data of @teval and will call the
- * corresponding release() functions registered for keys and values of
- * type TRACEEVAL_TYPE_DYNAMIC.
+ * corresponding release() functions registered for keys and values.
  */
 void traceeval_release(struct traceeval *teval)
 {
@@ -929,8 +919,8 @@ unsigned long long traceeval_stat_count(struct traceeval_stat *stat)
  * by traceeval_init(). The same goes for @vals.
  *
  * If an entry with keys that match @keys exists, it's vals field is freed and
- * set to a copy of @vals. This process calls dyn_release() on any data of
- * type TRACEEVAL_TYPE_DYNAMIC.
+ * set to a copy of @vals. This process calls release() on any data with a
+ * type that specified it.
  * Otherwise, a new entry is created with copies of @keys and @vals.
  *
  * For all elements of @keys and @vals that correspond to a struct
@@ -1159,10 +1149,9 @@ int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_fi
 	if (!type)
 		return -1;
 
-	/* pointer and dynamic types must have a cmp function */
+	/* pointer types must have a cmp function */
 	switch (type->type) {
 	case TRACEEVAL_TYPE_POINTER:
-	case TRACEEVAL_TYPE_DYNAMIC:
 		if (!type->cmp)
 			return -1;
 		break;
-- 
2.40.1

