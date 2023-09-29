Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118C9F9CC
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Sep 2023 12:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F870C433C9;
	Fri, 29 Sep 2023 12:22:46 +0000 (UTC)
Date: Fri, 29 Sep 2023 08:22:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>, Stevie Alvarez 
 <stevie.6strings@gmail.com>
Subject: [PATCH v2] libtraceeval: Move traceeval-hist.h to traceeval.h
Message-ID: <20230929082240.21420a2a@rorschach.local.home>
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

Now that the API of the new histogram logic of libtraceeval is rather
stable, we can now remove the old version and replace it with the new
version. The traceeval-hist.h was just a tempory header until it was to
a point that it should be the default. It now is at that point. Remove
the old code of the histogram and use the new code.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/all/20230929081059.47c45ea8@rorschach.local.home/

 - Committed the changes to src/Makefile to remove trace-analysis.o compilation.
 - Forgot to replace traceeval-hist.h to traceeval.h in histograms.c.

 include/traceeval-hist.h | 245 ------------
 include/traceeval.h      | 327 +++++++++++-----
 src/Makefile             |   1 -
 src/histograms.c         |   2 +-
 src/trace-analysis.c     | 805 ---------------------------------------
 5 files changed, 227 insertions(+), 1153 deletions(-)
 delete mode 100644 include/traceeval-hist.h
 delete mode 100644 src/trace-analysis.c

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
deleted file mode 100644
index cd089b2..0000000
--- a/include/traceeval-hist.h
+++ /dev/null
@@ -1,245 +0,0 @@
-/* SPDX-License-Identifier: MIT */
-/*
- * libtraceeval histogram interface.
- *
- * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
- * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
- */
-#ifndef __LIBTRACEEVAL_HIST_H__
-#define __LIBTRACEEVAL_HIST_H__
-
-#include <stdlib.h>
-#include <stddef.h>
-#include <stdbool.h>
-
-/* Data definition interfaces */
-
-/* Field name/descriptor for number of hits */
-#define TRACEEVAL_VAL_HITS ((const char *)(-1UL))
-
-#define TRACEEVAL_ARRAY_SIZE(data)	(sizeof(data) / sizeof((data)[0]))
-
-/* Data type distinguishers */
-enum traceeval_data_type {
-	TRACEEVAL_TYPE_NONE,
-	TRACEEVAL_TYPE_NUMBER_8,
-	TRACEEVAL_TYPE_NUMBER_16,
-	TRACEEVAL_TYPE_NUMBER_32,
-	TRACEEVAL_TYPE_NUMBER_64,
-	TRACEEVAL_TYPE_NUMBER,
-	TRACEEVAL_TYPE_POINTER,
-	TRACEEVAL_TYPE_STRING,
-};
-
-/* Statistics specification flags */
-enum traceeval_flags {
-	TRACEEVAL_FL_KEY		= (1 << 0),
-	TRACEEVAL_FL_VALUE		= (1 << 1),
-	TRACEEVAL_FL_SIGNED		= (1 << 2),
-	TRACEEVAL_FL_TIMESTAMP		= (1 << 3),
-	TRACEEVAL_FL_STAT		= (1 << 4),
-};
-
-/*
- * Trace data entry for a traceeval histogram
- * Constitutes keys and values.
- */
-struct traceeval_data {
-	enum traceeval_data_type		type;
-	union {
-		char				*string;
-		const char			*cstring;
-		void				*pointer;
-		unsigned long			number;
-		unsigned long long		number_64;
-		unsigned int			number_32;
-		unsigned short			number_16;
-		unsigned char			number_8;
-	};
-};
-
-#define __TRACEEVAL_DATA(data_type, member, data)			\
-	{  .type = TRACEEVAL_TYPE_##data_type, .member = (data) }
-
-#define DEFINE_TRACEEVAL_NUMBER(data)	   __TRACEEVAL_DATA(NUMBER, number, data)
-#define DEFINE_TRACEEVAL_NUMBER_8(data)	   __TRACEEVAL_DATA(NUMBER_8, number_8, data)
-#define DEFINE_TRACEEVAL_NUMBER_16(data)   __TRACEEVAL_DATA(NUMBER_16, number_16, data)
-#define DEFINE_TRACEEVAL_NUMBER_32(data)   __TRACEEVAL_DATA(NUMBER_32, number_32, data)
-#define DEFINE_TRACEEVAL_NUMBER_64(data)   __TRACEEVAL_DATA(NUMBER_64, number_64, data)
-#define DEFINE_TRACEEVAL_STRING(data)	   __TRACEEVAL_DATA(STRING, string, data)
-#define DEFINE_TRACEEVAL_CSTRING(data)	   __TRACEEVAL_DATA(STRING, cstring, data)
-#define DEFINE_TRACEEVAL_POINTER(data)	   __TRACEEVAL_DATA(POINTER, pointer, data)
-
-#define __TRACEEVAL_SET(data, data_type, member, val)		\
-	do {							\
-		(data).type = TRACEEVAL_TYPE_##data_type;	\
-		(data).member = (val);				\
-	} while (0)
-
-#define TRACEEVAL_SET_NUMBER(data, val)	     __TRACEEVAL_SET(data, NUMBER, number, val)
-#define TRACEEVAL_SET_NUMBER_8(data, val)    __TRACEEVAL_SET(data, NUMBER_8, number_8, val)
-#define TRACEEVAL_SET_NUMBER_16(data, val)   __TRACEEVAL_SET(data, NUMBER_16, number_16, val)
-#define TRACEEVAL_SET_NUMBER_32(data, val)   __TRACEEVAL_SET(data, NUMBER_32, number_32, val)
-#define TRACEEVAL_SET_NUMBER_64(data, val)   __TRACEEVAL_SET(data, NUMBER_64, number_64, val)
-#define TRACEEVAL_SET_STRING(data, val)	     __TRACEEVAL_SET(data, STRING, string, val)
-#define TRACEEVAL_SET_CSTRING(data, val)     __TRACEEVAL_SET(data, STRING, cstring, val)
-#define TRACEEVAL_SET_POINTER(data, val)     __TRACEEVAL_SET(data, POINTER, pointer, val)
-
-struct traceeval_type;
-struct traceeval;
-
-/* release function callback on traceeval_data */
-typedef void (*traceeval_data_release_fn)(const struct traceeval_type *type,
-					  struct traceeval_data *data);
-
-/* compare function callback to compare traceeval_data */
-typedef int (*traceeval_data_cmp_fn)(struct traceeval *teval,
-				     const struct traceeval_type *type,
-				     const struct traceeval_data *A,
-				     const struct traceeval_data *B);
-
-/* make a unique value */
-typedef int (*traceeval_data_hash_fn)(struct traceeval *teval,
-				      const struct traceeval_type *type,
-				      const struct traceeval_data *data);
-
-typedef int (*traceeval_data_copy_fn)(const struct traceeval_type *type,
-				      struct traceeval_data *dst,
-				      const struct traceeval_data *src);
-
-typedef int (*traceeval_cmp_fn)(struct traceeval *teval,
-				const struct traceeval_data *Akeys,
-				const struct traceeval_data *Avals,
-				const struct traceeval_data *Bkeys,
-				const struct traceeval_data *Bvals,
-				void *data);
-
-/*
- * struct traceeval_type - Describes the type of a traceevent_data instance
- * @type: The enum type that describes the traceeval_data
- * @name: The string name of the traceeval_data
- * @flags: flags to describe the traceeval_data
- * @id: User specified identifier
- * @release: An optional callback for when the data is being released
- * @cmp: An optional callback to specify a way to compare the type
- *
- * The traceeval_type structure defines expectations for a corresponding
- * traceeval_data instance for a traceeval histogram instance. Used to
- * describe both keys and values.
- *
- * The @id field is an optional value in case the user has multiple struct
- * traceeval_type instances and needs to distinguish between them into
- * 'sub-types'.
- *
- * For flexibility, @cmp() and @release() take a struct traceeval_type
- * instance. This allows the user to handle pointer types.
- * It may also be used for other types if the default cmp() or release()
- * need to be overridden. Note for string types, even if the release()
- * is called, the string freeing is still taken care of by the traceeval
- * infrastructure.
- *
- * The @id field is a user specified field that may allow the same callback
- * to be used by multiple types and not needing to do a strcmp() against the
- * name (could be used for switch statements).
- *
- * @cmp() is used to override the default compare of a type. This is
- * required to pointer types. It should return 0 on equality, 1 if the first
- * argument is greater than the second, -1 for the other way around,
- * and -2 on error.
- *
- * @release() is called when a data element is being released (or freed).
- */
-struct traceeval_type {
-	char				*name;
-	enum traceeval_data_type	type;
-	size_t				flags;
-	size_t				index;
-	size_t				id;
-	traceeval_data_release_fn	release;
-	traceeval_data_cmp_fn		cmp;
-	traceeval_data_copy_fn		copy;
-	traceeval_data_hash_fn		hash;
-};
-
-/* Statistics about a given entry element */
-struct traceeval_stat;
-
-/* Iterator over aggregated data */
-struct traceeval_iterator;
-
-struct traceeval;
-
-/* Histogram interfaces */
-
-#define traceeval_init(keys, vals)					\
-	traceeval_init_size(keys, vals,					\
-			    TRACEEVAL_ARRAY_SIZE(keys),			\
-			    (void *)vals == NULL ?  0 : TRACEEVAL_ARRAY_SIZE(vals))
-
-#define traceeval_init_size(keys, vals, nr_keys, nr_vals)		\
-	traceeval_init_data_size(keys, vals, nr_keys, nr_vals,		\
-				 sizeof(struct traceeval_type),		\
-				 sizeof(struct traceeval_data))
-
-struct traceeval *traceeval_init_data_size(struct traceeval_type *keys,
-					   struct traceeval_type *vals,
-					   size_t nr_keys, size_t nr_vals,
-					   size_t sizeof_type, size_t sizeof_data);
-
-void traceeval_release(struct traceeval *teval);
-
-int traceeval_insert_size(struct traceeval *teval,
-			  const struct traceeval_data *keys, size_t nr_keys,
-			  const struct traceeval_data *vals, size_t nr_vals);
-
-#define traceeval_insert(teval, keys, vals)				\
-	traceeval_insert_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), \
-			      vals, (void *)vals == NULL ? 0 : TRACEEVAL_ARRAY_SIZE(vals))
-
-int traceeval_remove_size(struct traceeval *teval,
-			  const struct traceeval_data *keys, size_t nr_keys);
-
-#define traceeval_remove(teval, keys)					\
-	traceeval_remove_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys))
-
-int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *keys,
-			 size_t nr_keys, const struct traceeval_data **results);
-
-#define traceeval_query(teval, keys, results)				\
-	traceeval_query_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), results)
-
-void traceeval_results_release(struct traceeval *teval,
-			       const struct traceeval_data *results);
-
-size_t traceeval_count(struct traceeval *teval);
-
-#define traceeval_stat(teval, keys, type)				\
-	traceeval_stat_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), type)
-
-struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
-					   const struct traceeval_data *keys,
-					   size_t nr_keys,
-					   struct traceeval_type *type);
-
-unsigned long long traceeval_stat_max(struct traceeval_stat *stat);
-unsigned long long traceeval_stat_min(struct traceeval_stat *stat);
-unsigned long long traceeval_stat_total(struct traceeval_stat *stat);
-unsigned long long traceeval_stat_count(struct traceeval_stat *stat);
-
-struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval);
-void traceeval_iterator_put(struct traceeval_iterator *iter);
-int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_field,
-			    int level, bool ascending);
-int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
-				   traceeval_cmp_fn sort_fn, void *data);
-int traceeval_iterator_next(struct traceeval_iterator *iter,
-			    const struct traceeval_data **keys);
-int traceeval_iterator_query(struct traceeval_iterator *iter,
-			     const struct traceeval_data **results);
-void traceeval_iterator_results_release(struct traceeval_iterator *iter,
-					const struct traceeval_data *results);
-struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
-					       struct traceeval_type *type);
-int traceeval_iterator_remove(struct traceeval_iterator *iter);
-
-#endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/include/traceeval.h b/include/traceeval.h
index 24415ca..48c28df 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -1,120 +1,245 @@
 /* SPDX-License-Identifier: MIT */
 /*
- * Copyright (C) 2022 Google Inc, Steven Rostedt <rostedt@goodmis.org>
+ * libtraceeval histogram interface.
+ *
+ * Copyright (C) 2022-2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
+ * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
  */
-#ifndef __LIBTRACEEVAL_H__
-#define __LIBTRACEEVAL_H__
+#ifndef __LIBTRACEEVAL_HIST_H__
+#define __LIBTRACEEVAL_HIST_H__
 
 #include <stdlib.h>
+#include <stddef.h>
 #include <stdbool.h>
 
-typedef unsigned long long u64;
-typedef unsigned int u32;
+/* Data definition interfaces */
 
-struct traceeval;
-struct traceeval_key_array;
-struct traceeval_key_info_array;
-struct traceeval_outliers;
+/* Field name/descriptor for number of hits */
+#define TRACEEVAL_VAL_HITS ((const char *)(-1UL))
+
+#define TRACEEVAL_ARRAY_SIZE(data)	(sizeof(data) / sizeof((data)[0]))
 
-enum traceeval_type {
+/* Data type distinguishers */
+enum traceeval_data_type {
 	TRACEEVAL_TYPE_NONE,
-	TRACEEVAL_TYPE_STRING,
-	TRACEEVAL_TYPE_POINTER,
-	TRACEEVAL_TYPE_NUMBER,
-	TRACEEVAL_TYPE_NUMBER_64,
-	TRACEEVAL_TYPE_NUMBER_32,
-	TRACEEVAL_TYPE_NUMBER_16,
 	TRACEEVAL_TYPE_NUMBER_8,
-	TRACEEVAL_TYPE_ARRAY,
-	TRACEEVAL_TYPE_MAX
+	TRACEEVAL_TYPE_NUMBER_16,
+	TRACEEVAL_TYPE_NUMBER_32,
+	TRACEEVAL_TYPE_NUMBER_64,
+	TRACEEVAL_TYPE_NUMBER,
+	TRACEEVAL_TYPE_POINTER,
+	TRACEEVAL_TYPE_STRING,
 };
 
-struct traceeval_key_info {
-	enum traceeval_type	type;
-	size_t			size;
-	ssize_t			count;
-	const char		*name;
+/* Statistics specification flags */
+enum traceeval_flags {
+	TRACEEVAL_FL_KEY		= (1 << 0),
+	TRACEEVAL_FL_VALUE		= (1 << 1),
+	TRACEEVAL_FL_SIGNED		= (1 << 2),
+	TRACEEVAL_FL_TIMESTAMP		= (1 << 3),
+	TRACEEVAL_FL_STAT		= (1 << 4),
 };
 
-struct traceeval_key {
-	enum traceeval_type	type;
-	ssize_t			count;
+/*
+ * Trace data entry for a traceeval histogram
+ * Constitutes keys and values.
+ */
+struct traceeval_data {
+	enum traceeval_data_type		type;
 	union {
-		const char	*string;
-		void   		*pointer;
-		long		number;
-		u64		number_64;
-		u32		number_32;
-		unsigned short	number_16;
-		unsigned char	number_8;
-		void		*array;
+		char				*string;
+		const char			*cstring;
+		void				*pointer;
+		unsigned long			number;
+		unsigned long long		number_64;
+		unsigned int			number_32;
+		unsigned short			number_16;
+		unsigned char			number_8;
 	};
 };
 
-struct traceeval_key_info_array *traceeval_key_info_array_alloc(void);
-void traceeval_key_info_array_free(struct traceeval_key_info_array *iarray);
-int traceeval_key_info_array_add(struct traceeval_key_info_array *iarray,
-					 const struct traceeval_key_info *key);
-
-	struct traceeval *traceeval_n_alloc(const char *name,
-					    const struct traceeval_key_info_array *iarray);
-	void traceeval_free(struct traceeval *teval);
-
-	int traceeval_n_start(struct traceeval *teval, const struct traceeval_key *keys,
-			      unsigned long long start);
-	int traceeval_n_stop(struct traceeval *teval, const struct traceeval_key *keys,
-			     unsigned long long stop);
-	int traceeval_n_continue(struct traceeval *teval, const struct traceeval_key *keys,
-				 unsigned long long start);
-
-	int traceeval_n_set_private(struct traceeval *teval, const struct traceeval_key *keys,
-				    void *data);
-
-	void *traceeval_n_get_private(struct traceeval *teval, const struct traceeval_key *keys);
-
-	struct traceeval_result_array *traceeval_results(struct traceeval *teval);
-
-	size_t traceeval_result_nr(struct traceeval *teval);
-
-	size_t traceeval_key_array_nr(struct traceeval_key_array *karray);
-	const struct traceeval_key *traceeval_key_array_indx(const struct traceeval_key_array *karray,
-							     size_t index);
-	struct traceeval_key_array *traceeval_result_indx_key_array(struct traceeval *teval,
-								    size_t index);
-	ssize_t traceeval_result_indx_cnt(struct traceeval *teval, size_t index);
-	ssize_t traceeval_result_indx_total(struct traceeval *teval, size_t index);
-	ssize_t traceeval_result_indx_max(struct traceeval *teval, size_t index);
-	ssize_t traceeval_result_indx_min(struct traceeval *teval, size_t index);
-
-	ssize_t traceeval_result_keys_cnt(struct traceeval *teval, const struct traceeval_key *keys);
-	ssize_t traceeval_result_keys_total(struct traceeval *teval, const struct traceeval_key *keys);
-	ssize_t traceeval_result_keys_max(struct traceeval *teval, const struct traceeval_key *keys);
-	ssize_t traceeval_result_keys_min(struct traceeval *teval, const struct traceeval_key *keys);
-
-	struct traceeval *traceeval_1_alloc(const char *name, const struct traceeval_key_info info[1]);
-int traceeval_1_start(struct traceeval *teval, struct traceeval_key key,
-		      unsigned long long start);
-int traceeval_1_set_private(struct traceeval *teval, struct traceeval_key key,
-			    void *data);
-void *traceeval_1_get_private(struct traceeval *teval, struct traceeval_key key);
-int traceeval_1_stop(struct traceeval *teval, struct traceeval_key key,
-		     unsigned long long stop);
-int traceeval_1_continue(struct traceeval *teval, struct traceeval_key key,
-			 unsigned long long start);
-
-struct traceeval *traceeval_2_alloc(const char *name, const struct traceeval_key_info kinfo[2]);
-
-int traceeval_sort_totals(struct traceeval *teval, bool ascending);
-int traceeval_sort_max(struct traceeval *teval, bool ascending);
-int traceeval_sort_min(struct traceeval *teval, bool ascending);
-int traceeval_sort_cnt(struct traceeval *teval, bool ascending);
-int traceeval_sort_keys(struct traceeval *teval, bool ascending);
-
-typedef int (*traceeval_cmp_func)(struct traceeval *teval,
-				  const struct traceeval_key_array *A,
-				  const struct traceeval_key_array *B,
-				  void *data);
-
-int traceeval_sort_custom(struct traceeval *teval, traceeval_cmp_func cmp, void *data);
-
-#endif /* __LIBTRACEEVAL_H__ */
+#define __TRACEEVAL_DATA(data_type, member, data)			\
+	{  .type = TRACEEVAL_TYPE_##data_type, .member = (data) }
+
+#define DEFINE_TRACEEVAL_NUMBER(data)	   __TRACEEVAL_DATA(NUMBER, number, data)
+#define DEFINE_TRACEEVAL_NUMBER_8(data)	   __TRACEEVAL_DATA(NUMBER_8, number_8, data)
+#define DEFINE_TRACEEVAL_NUMBER_16(data)   __TRACEEVAL_DATA(NUMBER_16, number_16, data)
+#define DEFINE_TRACEEVAL_NUMBER_32(data)   __TRACEEVAL_DATA(NUMBER_32, number_32, data)
+#define DEFINE_TRACEEVAL_NUMBER_64(data)   __TRACEEVAL_DATA(NUMBER_64, number_64, data)
+#define DEFINE_TRACEEVAL_STRING(data)	   __TRACEEVAL_DATA(STRING, string, data)
+#define DEFINE_TRACEEVAL_CSTRING(data)	   __TRACEEVAL_DATA(STRING, cstring, data)
+#define DEFINE_TRACEEVAL_POINTER(data)	   __TRACEEVAL_DATA(POINTER, pointer, data)
+
+#define __TRACEEVAL_SET(data, data_type, member, val)		\
+	do {							\
+		(data).type = TRACEEVAL_TYPE_##data_type;	\
+		(data).member = (val);				\
+	} while (0)
+
+#define TRACEEVAL_SET_NUMBER(data, val)	     __TRACEEVAL_SET(data, NUMBER, number, val)
+#define TRACEEVAL_SET_NUMBER_8(data, val)    __TRACEEVAL_SET(data, NUMBER_8, number_8, val)
+#define TRACEEVAL_SET_NUMBER_16(data, val)   __TRACEEVAL_SET(data, NUMBER_16, number_16, val)
+#define TRACEEVAL_SET_NUMBER_32(data, val)   __TRACEEVAL_SET(data, NUMBER_32, number_32, val)
+#define TRACEEVAL_SET_NUMBER_64(data, val)   __TRACEEVAL_SET(data, NUMBER_64, number_64, val)
+#define TRACEEVAL_SET_STRING(data, val)	     __TRACEEVAL_SET(data, STRING, string, val)
+#define TRACEEVAL_SET_CSTRING(data, val)     __TRACEEVAL_SET(data, STRING, cstring, val)
+#define TRACEEVAL_SET_POINTER(data, val)     __TRACEEVAL_SET(data, POINTER, pointer, val)
+
+struct traceeval_type;
+struct traceeval;
+
+/* release function callback on traceeval_data */
+typedef void (*traceeval_data_release_fn)(const struct traceeval_type *type,
+					  struct traceeval_data *data);
+
+/* compare function callback to compare traceeval_data */
+typedef int (*traceeval_data_cmp_fn)(struct traceeval *teval,
+				     const struct traceeval_type *type,
+				     const struct traceeval_data *A,
+				     const struct traceeval_data *B);
+
+/* make a unique value */
+typedef int (*traceeval_data_hash_fn)(struct traceeval *teval,
+				      const struct traceeval_type *type,
+				      const struct traceeval_data *data);
+
+typedef int (*traceeval_data_copy_fn)(const struct traceeval_type *type,
+				      struct traceeval_data *dst,
+				      const struct traceeval_data *src);
+
+typedef int (*traceeval_cmp_fn)(struct traceeval *teval,
+				const struct traceeval_data *Akeys,
+				const struct traceeval_data *Avals,
+				const struct traceeval_data *Bkeys,
+				const struct traceeval_data *Bvals,
+				void *data);
+
+/*
+ * struct traceeval_type - Describes the type of a traceevent_data instance
+ * @type: The enum type that describes the traceeval_data
+ * @name: The string name of the traceeval_data
+ * @flags: flags to describe the traceeval_data
+ * @id: User specified identifier
+ * @release: An optional callback for when the data is being released
+ * @cmp: An optional callback to specify a way to compare the type
+ *
+ * The traceeval_type structure defines expectations for a corresponding
+ * traceeval_data instance for a traceeval histogram instance. Used to
+ * describe both keys and values.
+ *
+ * The @id field is an optional value in case the user has multiple struct
+ * traceeval_type instances and needs to distinguish between them into
+ * 'sub-types'.
+ *
+ * For flexibility, @cmp() and @release() take a struct traceeval_type
+ * instance. This allows the user to handle pointer types.
+ * It may also be used for other types if the default cmp() or release()
+ * need to be overridden. Note for string types, even if the release()
+ * is called, the string freeing is still taken care of by the traceeval
+ * infrastructure.
+ *
+ * The @id field is a user specified field that may allow the same callback
+ * to be used by multiple types and not needing to do a strcmp() against the
+ * name (could be used for switch statements).
+ *
+ * @cmp() is used to override the default compare of a type. This is
+ * required to pointer types. It should return 0 on equality, 1 if the first
+ * argument is greater than the second, -1 for the other way around,
+ * and -2 on error.
+ *
+ * @release() is called when a data element is being released (or freed).
+ */
+struct traceeval_type {
+	char				*name;
+	enum traceeval_data_type	type;
+	size_t				flags;
+	size_t				index;
+	size_t				id;
+	traceeval_data_release_fn	release;
+	traceeval_data_cmp_fn		cmp;
+	traceeval_data_copy_fn		copy;
+	traceeval_data_hash_fn		hash;
+};
+
+/* Statistics about a given entry element */
+struct traceeval_stat;
+
+/* Iterator over aggregated data */
+struct traceeval_iterator;
+
+struct traceeval;
+
+/* Histogram interfaces */
+
+#define traceeval_init(keys, vals)					\
+	traceeval_init_size(keys, vals,					\
+			    TRACEEVAL_ARRAY_SIZE(keys),			\
+			    (void *)vals == NULL ?  0 : TRACEEVAL_ARRAY_SIZE(vals))
+
+#define traceeval_init_size(keys, vals, nr_keys, nr_vals)		\
+	traceeval_init_data_size(keys, vals, nr_keys, nr_vals,		\
+				 sizeof(struct traceeval_type),		\
+				 sizeof(struct traceeval_data))
+
+struct traceeval *traceeval_init_data_size(struct traceeval_type *keys,
+					   struct traceeval_type *vals,
+					   size_t nr_keys, size_t nr_vals,
+					   size_t sizeof_type, size_t sizeof_data);
+
+void traceeval_release(struct traceeval *teval);
+
+int traceeval_insert_size(struct traceeval *teval,
+			  const struct traceeval_data *keys, size_t nr_keys,
+			  const struct traceeval_data *vals, size_t nr_vals);
+
+#define traceeval_insert(teval, keys, vals)				\
+	traceeval_insert_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), \
+			      vals, (void *)vals == NULL ? 0 : TRACEEVAL_ARRAY_SIZE(vals))
+
+int traceeval_remove_size(struct traceeval *teval,
+			  const struct traceeval_data *keys, size_t nr_keys);
+
+#define traceeval_remove(teval, keys)					\
+	traceeval_remove_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys))
+
+int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *keys,
+			 size_t nr_keys, const struct traceeval_data **results);
+
+#define traceeval_query(teval, keys, results)				\
+	traceeval_query_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), results)
+
+void traceeval_results_release(struct traceeval *teval,
+			       const struct traceeval_data *results);
+
+size_t traceeval_count(struct traceeval *teval);
+
+#define traceeval_stat(teval, keys, type)				\
+	traceeval_stat_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), type)
+
+struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
+					   const struct traceeval_data *keys,
+					   size_t nr_keys,
+					   struct traceeval_type *type);
+
+unsigned long long traceeval_stat_max(struct traceeval_stat *stat);
+unsigned long long traceeval_stat_min(struct traceeval_stat *stat);
+unsigned long long traceeval_stat_total(struct traceeval_stat *stat);
+unsigned long long traceeval_stat_count(struct traceeval_stat *stat);
+
+struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval);
+void traceeval_iterator_put(struct traceeval_iterator *iter);
+int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_field,
+			    int level, bool ascending);
+int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
+				   traceeval_cmp_fn sort_fn, void *data);
+int traceeval_iterator_next(struct traceeval_iterator *iter,
+			    const struct traceeval_data **keys);
+int traceeval_iterator_query(struct traceeval_iterator *iter,
+			     const struct traceeval_data **results);
+void traceeval_iterator_results_release(struct traceeval_iterator *iter,
+					const struct traceeval_data *results);
+struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
+					       struct traceeval_type *type);
+int traceeval_iterator_remove(struct traceeval_iterator *iter);
+
+#endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/src/Makefile b/src/Makefile
index 4b7b305..168d90a 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -3,7 +3,6 @@
 include $(src)/scripts/utils.mk
 
 OBJS =
-OBJS += trace-analysis.o
 OBJS += histograms.o
 OBJS += hash.o
 
diff --git a/src/histograms.c b/src/histograms.c
index 5a98473..c562605 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -11,7 +11,7 @@
 #include <stdarg.h>
 #include <stdio.h>
 
-#include <traceeval-hist.h>
+#include <traceeval.h>
 #include "eval-local.h"
 
 /*
diff --git a/src/trace-analysis.c b/src/trace-analysis.c
deleted file mode 100644
index ba4e1c7..0000000
--- a/src/trace-analysis.c
+++ /dev/null
@@ -1,805 +0,0 @@
-// SPDX-License-Identifier: MIT
-/*
- * Copyright (C) 2022 Google Inc, Steven Rostedt <rostedt@goodmis.org>
- */
-#include <string.h>
-#include <errno.h>
-#include <traceeval.h>
-
-#define HASH_BITS 10
-#define HASH_SIZE (1 << HASH_BITS)
-#define HASH_MASK (HASH_SIZE - 1)
-
-enum sort_type {
-	NONE,
-	KEYS,
-	TOTALS,
-	MAX,
-	MIN,
-	CNT,
-};
-
-struct traceeval_key_info_array {
-	size_t				nr_keys;
-	struct traceeval_key_info	*keys;
-};
-
-struct eval_instance {
-	unsigned long long	total;
-	unsigned long long	last;
-	unsigned long long	max;
-	unsigned long long	min;
-	unsigned long long	cnt;
-	size_t			nr_keys;
-	struct traceeval_key	*keys;
-	void			*private;
-};
-
-struct eval_hash {
-	struct eval_hash		*next;
-	struct eval_instance		eval;
-};
-
-struct traceeval {
-	struct traceeval_key_info_array		array;
-	struct eval_instance			*evals;
-	struct eval_hash			*eval_hash[HASH_SIZE];
-	size_t					nr_evals;
-	struct eval_instance			*results;
-	enum sort_type				sort_type;
-};
-
-struct traceeval_result_array {
-	int				nr_results;
-	struct traceeval_result		*results;
-};
-
-struct traceeval_key_info_array *traceeval_key_info_array_alloc(void)
-{
-	struct traceeval_key_info_array *tarray;
-
-	tarray = calloc(1, sizeof(*tarray));
-	return tarray;
-}
-
-void traceeval_key_info_array_free(struct traceeval_key_info_array *tarray)
-{
-	if (!tarray)
-		return;
-
-	free(tarray->keys);
-	free(tarray);
-}
-
-int traceeval_key_info_array_add(struct traceeval_key_info_array *tarray,
-				 const struct traceeval_key_info *key)
-{
-	size_t nr = tarray->nr_keys;
-	struct traceeval_key_info *kinfo;
-
-	kinfo = realloc(tarray->keys, sizeof(*kinfo) * (nr + 1));
-	if (!kinfo)
-		return -1;
-
-	tarray->keys = kinfo;
-	tarray->nr_keys++;
-	tarray->keys[nr] = *key;
-
-	return 0;
-}
-
-struct traceeval *
-traceeval_n_alloc(const char *name, const struct traceeval_key_info_array *keys)
-{
-	struct traceeval *teval;
-	int i;
-
-	teval = calloc(1, sizeof(*teval));
-	if (!teval)
-		return NULL;
-
-	teval->array.keys = calloc(keys->nr_keys, sizeof(*keys->keys));
-	if (!teval->array.keys)
-		goto fail;
-
-	teval->array.nr_keys = keys->nr_keys;
-
-	for (i = 0; i < keys->nr_keys; i++)
-		teval->array.keys[i] = keys->keys[i];
-
-	return teval;
- fail:
-	free(teval);
-	return NULL;
-}
-
-void traceeval_free(struct traceeval *teval)
-{
-	struct eval_hash *ehash;
-	int i;
-	if (!teval)
-		return;
-
-	for (i = 0; i < HASH_SIZE; i++) {
-		for (ehash = teval->eval_hash[i]; ehash; ) {
-			struct eval_hash *tmp = ehash;
-			ehash = ehash->next;
-			free(tmp);
-		}
-	}
-
-	free(teval->array.keys);
-	free(teval->evals);
-	free(teval);
-}
-
-static int cmp_keys(struct traceeval_key_info_array *tarray,
-		    const struct traceeval_key *A, const struct traceeval_key *B,
-		    int *err)
-{
-	const struct traceeval_key_info *kinfo;
-	unsigned long long A_val, B_val;
-	int ret;
-	int i;
-
-	for (i = 0; i < tarray->nr_keys; i++) {
-		kinfo = &tarray->keys[i];
-
-		/* TBD arrays */
-		if (kinfo->count) {
-			*err = 1;
-			return -1;
-		}
-
-		if (A[i].type != kinfo->type ||
-		    B[i].type != kinfo->type) {
-			*err = 1;
-			return -1;
-		}
-
-		switch (kinfo->type) {
-		case TRACEEVAL_TYPE_STRING:
-			ret = strcmp(A[i].string, B[i].string);
-			if (ret)
-				return ret;
-			continue;
-
-		case TRACEEVAL_TYPE_NUMBER:
-			A_val = A[i].number;
-			B_val = B[i].number;
-			break;
-		case TRACEEVAL_TYPE_NUMBER_64:
-			A_val = A[i].number_64;
-			B_val = B[i].number_64;
-			break;
-		case TRACEEVAL_TYPE_NUMBER_32:
-			A_val = A[i].number_32;
-			B_val = B[i].number_32;
-			break;
-		case TRACEEVAL_TYPE_NUMBER_16:
-			A_val = A[i].number_16;
-			B_val = B[i].number_16;
-			break;
-		case TRACEEVAL_TYPE_NUMBER_8:
-			A_val = A[i].number_8;
-			B_val = B[i].number_8;
-			break;
-		case TRACEEVAL_TYPE_ARRAY:
-		default:
-			*err = 1;
-			return -1;
-		}
-		if (A_val > B_val)
-			return 1;
-		if (A_val < B_val)
-			return -1;
-	}
-	return 0;
-}
-
-static int make_key(struct traceeval *teval, const struct traceeval_key *keys, int *err)
-{
-	struct traceeval_key_info *kinfo;
-	bool calc;
-	int len, l;
-	int ret = 0;
-	int i;
-
-	for (i = 0; i < teval->array.nr_keys; i++) {
-		kinfo = &teval->array.keys[i];
-
-		/* TBD arrays */
-		if (kinfo->count) {
-			*err = 1;
-			return -1;
-		}
-
-		if (keys[i].type != kinfo->type) {
-			*err = 1;
-			return -1;
-		}
-
-		calc = false;
-
-		switch (kinfo->type) {
-		case TRACEEVAL_TYPE_STRING:
-			len = strlen(keys[i].string);
-
-			for (l = 0; l < len; l++) {
-				unsigned int c = keys[i].string[l];
-
-				ret += c << ((l & 3) * 8);
-			}
-
-			continue;
-
-		case TRACEEVAL_TYPE_NUMBER_32:
-			calc = true;
-			/* fall though */
-		case TRACEEVAL_TYPE_NUMBER:
-			if (calc || sizeof(keys[i].number) == 4) {
-				ret += keys[i].number;
-				continue;
-			}
-			/* fall through */
-		case TRACEEVAL_TYPE_NUMBER_64:
-			ret += keys[i].number_64 >> 32;
-			ret += keys[i].number_64 & ((1ULL << 32) - 1);
-			break;
-			break;
-		case TRACEEVAL_TYPE_NUMBER_16:
-			ret += keys[i].number_16;
-			break;
-		case TRACEEVAL_TYPE_NUMBER_8:
-			ret += keys[i].number_8;
-			break;
-		case TRACEEVAL_TYPE_ARRAY:
-		default:
-			*err = 1;
-			return -1;
-		}
-	}
-	return ret & HASH_MASK;
-}
-
-static struct eval_hash *find_eval(struct traceeval *teval, const struct traceeval_key *keys,
-				   int *err, int *pkey)
-{
-	struct eval_hash *ehash;
-	int key = make_key(teval, keys, err);
-
-	if (key < 0)
-		return NULL;
-
-	if (pkey)
-		*pkey = key;
-
-	for (ehash = teval->eval_hash[key]; ehash; ehash = ehash->next) {
-		if (cmp_keys(&teval->array, keys, ehash->eval.keys, err) == 0)
-			return ehash;
-	}
-	return NULL;
-}
-
-static struct eval_hash *
-insert_eval(struct traceeval *teval, const struct traceeval_key *keys, int key)
-{
-	struct eval_instance *eval;
-	struct eval_hash *ehash;
-	int i;
-
-	ehash = calloc(1, sizeof(*ehash));
-	if (!ehash)
-		return NULL;
-
-	eval = &ehash->eval;
-
-	eval->keys = calloc(teval->array.nr_keys, sizeof(*eval->keys));
-	if (!eval->keys)
-		return NULL;
-	for (i = 0; i < teval->array.nr_keys; i++)
-		eval->keys[i] = keys[i];
-	eval->nr_keys = teval->array.nr_keys;
-	teval->nr_evals++;
-
-	ehash->next = teval->eval_hash[key];
-	teval->eval_hash[key] = ehash;
-
-	return ehash;
-}
-
-static struct eval_instance *
-get_eval_instance(struct traceeval *teval, const struct traceeval_key *keys)
-{
-	struct eval_hash *ehash;
-	int err = 0;
-	int key = -1;
-
-	ehash = find_eval(teval, keys, &err, &key);
-	if (!ehash) {
-		ehash = insert_eval(teval, keys, key);
-		if (!ehash)
-			return NULL;
-	}
-	return &ehash->eval;
-}
-
-int traceeval_n_start(struct traceeval *teval, const struct traceeval_key *keys,
-		      unsigned long long start)
-{
-	struct eval_instance *eval;
-
-	eval = get_eval_instance(teval, keys);
-	if (!eval)
-		return -1;
-
-	eval->last = start;
-	return 0;
-}
-
-int traceeval_n_continue(struct traceeval *teval, const struct traceeval_key *keys,
-			 unsigned long long start)
-{
-	struct eval_instance *eval;
-
-	eval = get_eval_instance(teval, keys);
-	if (!eval)
-		return -1;
-
-	if (eval->last)
-		return 0;
-
-	eval->last = start;
-	return 0;
-}
-
-int traceeval_n_set_private(struct traceeval *teval, const struct traceeval_key *keys,
-			    void *data)
-{
-	struct eval_instance *eval;
-
-	/* Setting an instance forces a creation of it */
-	eval = get_eval_instance(teval, keys);
-	if (!eval)
-		return -1;
-
-	eval->private = data;
-	return 0;
-}
-
-void *traceeval_n_get_private(struct traceeval *teval, const struct traceeval_key *keys)
-{
-	struct eval_hash *ehash;
-	int err = 0;
-
-	ehash = find_eval(teval, keys, &err, NULL);
-	if (!ehash)
-		return NULL;
-	return ehash->eval.private;
-}
-
-int traceeval_n_stop(struct traceeval *teval, const struct traceeval_key *keys,
-		     unsigned long long stop)
-{
-	struct eval_instance *eval;
-	unsigned long long delta;
-
-	eval = get_eval_instance(teval, keys);
-	if (!eval)
-		return -1;
-
-	if (!eval->last)
-		return 1;
-
-	delta = stop - eval->last;
-	eval->total += delta;
-	if (!eval->min || eval->min > delta)
-		eval->min = delta;
-	if (eval->max < delta)
-		eval->max = delta;
-	eval->cnt++;
-
-	eval->last = 0;
-
-	return 0;
-}
-
-size_t traceeval_result_nr(struct traceeval *teval)
-{
-	return teval->nr_evals;
-}
-
-size_t traceeval_key_array_nr(struct traceeval_key_array *karray)
-{
-	struct eval_instance *eval = (struct eval_instance *)karray;
-
-	if (!karray)
-		return 0;
-
-	return eval->nr_keys;
-}
-
-const struct traceeval_key *
-traceeval_key_array_indx(const struct traceeval_key_array *karray, size_t index)
-{
-	struct eval_instance *eval = (struct eval_instance *)karray;
-
-	if (!karray || index >= eval->nr_keys)
-		return NULL;
-
-	return &eval->keys[index];
-}
-
-static int create_results(struct traceeval *teval)
-{
-	struct eval_hash *ehash;
-	int r = 0;
-	int i;
-
-	if (teval->results)
-		return 0;
-
-	teval->results = calloc(teval->nr_evals, sizeof(*teval->results));
-	if (!teval->results)
-		return -1;
-
-	for (i = 0; i < HASH_SIZE; i++) {
-		for (ehash = teval->eval_hash[i]; ehash; ehash = ehash->next) {
-			teval->results[r++] = ehash->eval;
-		}
-	}
-	return 0;
-}
-
-static int eval_sort(struct traceeval *teval, enum sort_type sort_type, bool ascending);
-
-static struct eval_instance *get_result(struct traceeval *teval, size_t index)
-{
-	if (index >= teval->nr_evals)
-		return NULL;
-
-	if (!teval->results) {
-		create_results(teval);
-		if (!teval->results)
-			return NULL;
-		eval_sort(teval, KEYS, true);
-	}
-
-	if (teval->results)
-		return &teval->results[index];
-
-	return &teval->evals[index];
-}
-
-struct traceeval_key_array *
-traceeval_result_indx_key_array(struct traceeval *teval, size_t index)
-{
-	struct eval_instance *eval = get_result(teval, index);
-
-	if (!eval)
-		return NULL;
-
-	return (struct traceeval_key_array *)eval;
-}
-
-ssize_t
-traceeval_result_indx_cnt(struct traceeval *teval, size_t index)
-{
-	struct eval_instance *eval = get_result(teval, index);
-
-	if (!eval)
-		return -1;
-
-	return eval->cnt;
-}
-
-ssize_t
-traceeval_result_indx_total(struct traceeval *teval, size_t index)
-{
-	struct eval_instance *eval = get_result(teval, index);
-
-	if (!eval)
-		return -1;
-
-	return eval->total;
-}
-
-ssize_t
-traceeval_result_indx_max(struct traceeval *teval, size_t index)
-{
-	struct eval_instance *eval = get_result(teval, index);
-
-	if (!eval)
-		return -1;
-
-	return eval->max;
-}
-
-ssize_t
-traceeval_result_indx_min(struct traceeval *teval, size_t index)
-{
-	struct eval_instance *eval = get_result(teval, index);
-
-	if (!eval)
-		return -1;
-
-	return eval->min;
-}
-
-
-ssize_t
-traceeval_result_keys_cnt(struct traceeval *teval, const struct traceeval_key *keys)
-{
-	struct eval_hash *ehash;
-	int err = 0;
-
-	ehash = find_eval(teval, keys, &err, NULL);
-	if (!ehash)
-		return -1;
-	return ehash->eval.cnt;
-}
-
-ssize_t
-traceeval_result_keys_total(struct traceeval *teval, const struct traceeval_key *keys)
-{
-	struct eval_hash *ehash;
-	int err = 0;
-
-	ehash = find_eval(teval, keys, &err, NULL);
-	if (!ehash)
-		return -1;
-	return ehash->eval.total;
-}
-
-ssize_t
-traceeval_result_keys_max(struct traceeval *teval, const struct traceeval_key *keys)
-{
-	struct eval_hash *ehash;
-	int err = 0;
-
-	ehash = find_eval(teval, keys, &err, NULL);
-	if (!ehash)
-		return -1;
-	return ehash->eval.max;
-}
-
-ssize_t
-traceeval_result_keys_min(struct traceeval *teval, const struct traceeval_key *keys)
-{
-	struct eval_hash *ehash;
-	int err = 0;
-
-	ehash = find_eval(teval, keys, &err, NULL);
-	if (!ehash)
-		return -1;
-	return ehash->eval.min;
-}
-
-struct traceeval *
-traceeval_1_alloc(const char *name, const struct traceeval_key_info kinfo[1])
-{
-	struct traceeval_key_info key[1] = { kinfo[0] };
-	struct traceeval_key_info_array karray = {
-		.nr_keys = 1,
-		.keys = key,
-	};
-
-	return traceeval_n_alloc(name, &karray);
-}
-
-int traceeval_1_start(struct traceeval *teval, struct traceeval_key key,
-		      unsigned long long start)
-{
-	struct traceeval_key keys[1] = { key };
-
-	return traceeval_n_start(teval, keys, start);
-}
-
-int traceeval_1_continue(struct traceeval *teval, struct traceeval_key key,
-			 unsigned long long start)
-{
-	struct traceeval_key keys[1] = { key };
-
-	return traceeval_n_continue(teval, keys, start);
-}
-
-int traceeval_1_set_private(struct traceeval *teval, struct traceeval_key key,
-			    void *data)
-{
-	struct traceeval_key keys[1] = { key };
-
-	return traceeval_n_set_private(teval, keys, data);
-}
-
-void *traceeval_1_get_private(struct traceeval *teval, struct traceeval_key key)
-{
-	struct traceeval_key keys[1] = { key };
-
-	return traceeval_n_get_private(teval, keys);
-}
-
-int traceeval_1_stop(struct traceeval *teval, struct traceeval_key key,
-		     unsigned long long stop)
-{
-	struct traceeval_key keys[1] = { key };
-
-	return traceeval_n_stop(teval, keys, stop);
-}
-
-struct traceeval *
-traceeval_2_alloc(const char *name, const struct traceeval_key_info kinfo[2])
-{
-	struct traceeval_key_info key[2] = { kinfo[0], kinfo[1] };
-	struct traceeval_key_info_array karray = {
-		.nr_keys = 2,
-		.keys = key,
-	};
-
-	return traceeval_n_alloc(name, &karray);
-}
-
-static int cmp_totals(const void *A, const void *B)
-{
-	const struct eval_instance *a = A;
-	const struct eval_instance *b = B;
-
-	if (a->total < b->total)
-		return -1;
-	return a->total > b->total;
-}
-
-static int cmp_max(const void *A, const void *B)
-{
-	const struct eval_instance *a = A;
-	const struct eval_instance *b = B;
-
-	if (a->max < b->max)
-		return -1;
-	return a->max > b->max;
-}
-
-static int cmp_min(const void *A, const void *B)
-{
-	const struct eval_instance *a = A;
-	const struct eval_instance *b = B;
-
-	if (a->min < b->min)
-		return -1;
-	return a->min > b->min;
-}
-
-static int cmp_cnt(const void *A, const void *B)
-{
-	const struct eval_instance *a = A;
-	const struct eval_instance *b = B;
-
-	if (a->cnt < b->cnt)
-		return -1;
-	return a->cnt > b->cnt;
-}
-
-static int cmp_inverse(const void *A, const void *B, void *cmp)
-{
-	int (*cmp_func)(const void *, const void *) = cmp;
-
-	return cmp_func(B, A);
-}
-
-static int cmp_evals(const void *A, const void *B, void *data)
-{
-	const struct eval_instance *a = A;
-	const struct eval_instance *b = B;
-	struct traceeval *teval = data;
-	int err;
-
-	return cmp_keys(&teval->array, a->keys, b->keys, &err);
-}
-
-static int cmp_evals_dec(const void *A, const void *B, void *data)
-{
-	struct traceeval *teval = data;
-	int err;
-
-	return cmp_keys(&teval->array, B, A, &err);
-}
-
-static int eval_sort(struct traceeval *teval, enum sort_type sort_type, bool ascending)
-{
-	int (*cmp_func)(const void *, const void *);
-
-	if (create_results(teval) < 0)
-		return -1;
-
-	if (teval->sort_type == sort_type)
-		return 0;
-
-	switch (sort_type) {
-	case TOTALS:
-		cmp_func = cmp_totals;
-		break;
-	case MAX:
-		cmp_func = cmp_max;
-		break;
-	case MIN:
-		cmp_func = cmp_min;
-		break;
-	case CNT:
-		cmp_func = cmp_cnt;
-		break;
-	case NONE:
-	case KEYS:
-		if (ascending) {
-			qsort_r(teval->results, teval->nr_evals,
-				sizeof(*teval->results), cmp_evals, teval);
-		} else {
-			qsort_r(teval->results, teval->nr_evals,
-				sizeof(*teval->results), cmp_evals_dec, teval);
-		}
-		return 0;
-	}
-
-	if (ascending)
-		qsort(teval->results, teval->nr_evals, sizeof(*teval->results), cmp_func);
-	else
-		qsort_r(teval->results, teval->nr_evals, sizeof(*teval->results),
-			cmp_inverse, cmp_func);
-	teval->sort_type = sort_type;
-	return 0;
-}
-
-int traceeval_sort_totals(struct traceeval *teval, bool ascending)
-{
-	return eval_sort(teval, TOTALS, ascending);
-}
-
-int traceeval_sort_max(struct traceeval *teval, bool ascending)
-{
-	return eval_sort(teval, MAX, ascending);
-}
-
-int traceeval_sort_min(struct traceeval *teval, bool ascending)
-{
-	return eval_sort(teval, MIN, ascending);
-}
-
-int traceeval_sort_cnt(struct traceeval *teval, bool ascending)
-{
-	return eval_sort(teval, CNT, ascending);
-}
-
-struct cmp_data {
-	struct traceeval	*teval;
-	traceeval_cmp_func	func;
-	void			*data;
-};
-
-static int cmp_custom(const void *A, const void *B, void *data)
-{
-	const struct traceeval_key_array *a = A;
-	const struct traceeval_key_array *b = B;
-	struct cmp_data *cdata = data;
-
-	return cdata->func(cdata->teval, a, b, cdata->data);
-}
-
-int traceeval_sort_custom(struct traceeval *teval, traceeval_cmp_func cmp, void *data)
-{
-	struct cmp_data cdata;
-
-	if (create_results(teval) < 0)
-		return -1;
-
-	cdata.teval = teval;
-	cdata.func = cmp;
-	cdata.data = data;
-
-	qsort_r(teval->results, teval->nr_evals,
-		sizeof(*teval->results), cmp_custom, &cdata);
-
-	return 0;
-}
-
-int traceeval_sort_keys(struct traceeval *teval, bool ascending)
-{
-	return eval_sort(teval, KEYS, ascending);
-}
-- 
2.40.1

