Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C63629
	for <linux-trace-devel@vger.kernel.org>; Fri,  6 Oct 2023 00:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74888C433C7;
	Fri,  6 Oct 2023 00:50:19 +0000 (UTC)
Date: Thu, 5 Oct 2023 20:51:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: [PATCH] libtraceeval: Have TRACEEVAL_ARRAY_SIZE() handle NULL
 pointer
Message-ID: <20231005205129.6d6cbfad@gandalf.local.home>
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

In the new addition to make sure that pointers passed to traceeval_init()
and other functions that require a static array and not a dynamic one will
cause the build to fail, this causes NULL pointers to fail the build too.

Although keys must be filled, vals are allowed to be NULL. It was assumed
that:

   (void *)vals == NULL ? TRACEEVAL_ARRAY_SIZE(vals))

Would solve this, but gcc was still actually giving a warning about

  warning: division 'sizeof (void *) / sizeof (void)' does not compute the number of array elements

And now it even fails to build with the magic check.

Change TRACEEVAL_ARRAY_SIZE() to handle NULL for both keys and vals, by
not only having:

 #define TRACEEVAL_ARRAY_SIZE(data) \
	((void *)(data) == NULL ?  0 : __TRACEEVAL_ARRAY_SIZE(data))

As that is not enough, because gcc still evaluates the second part, and it
will fail to build. To handle this, add the following:

 #define __TRACEEVAL_ARRAY_SIZE(data)					\
	((sizeof(data) / (sizeof((data)[0])) + 0) +			\

The above adds " + 0" to the "sizeof((data)[0])" which quiets the warning
mentioned above (the addition of zero breaks the normal pattern of finding
an array size).

	(int)(sizeof(struct {						\
		int:(-!!(__builtin_types_compatible_p(typeof(data),	\
						      typeof(&((data)[0]))) && \
			 (void *)(data) != NULL));			\

Added "&& (void *)(data) != NULL" that makes the above return false (zero)
for a static array as well as NULL, which is exactly what we want.

			})))

No need to treat vals any different from keys.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/traceeval.h b/include/traceeval.h
index bbf8f6ac7dd1..67fb1eaad501 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -29,13 +29,17 @@
  *
  *    struct traceeval_data keys[] = { ... };
  */
-#define TRACEEVAL_ARRAY_SIZE(data)					\
-	((sizeof(data) / sizeof((data)[0])) +				\
+#define __TRACEEVAL_ARRAY_SIZE(data)					\
+	((sizeof(data) / (sizeof((data)[0])) + 0) +			\
 	(int)(sizeof(struct {						\
 		int:(-!!(__builtin_types_compatible_p(typeof(data),	\
-						      typeof(&((data)[0]))))); \
+						      typeof(&((data)[0]))) && \
+			 (void *)(data) != NULL));			\
 			})))
 
+#define TRACEEVAL_ARRAY_SIZE(data) \
+	((void *)(data) == NULL ?  0 : __TRACEEVAL_ARRAY_SIZE(data))
+
 /* Data type distinguishers */
 enum traceeval_data_type {
 	TRACEEVAL_TYPE_NONE,
@@ -191,7 +195,7 @@ struct traceeval;
 #define traceeval_init(keys, vals)					\
 	traceeval_init_size(keys, vals,					\
 			    TRACEEVAL_ARRAY_SIZE(keys),			\
-			    (void *)vals == NULL ?  0 : TRACEEVAL_ARRAY_SIZE(vals))
+			    TRACEEVAL_ARRAY_SIZE(vals))
 
 #define traceeval_init_size(keys, vals, nr_keys, nr_vals)		\
 	traceeval_init_data_size(keys, vals, nr_keys, nr_vals,		\
@@ -211,7 +215,7 @@ int traceeval_insert_size(struct traceeval *teval,
 
 #define traceeval_insert(teval, keys, vals)				\
 	traceeval_insert_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), \
-			      vals, (void *)vals == NULL ? 0 : TRACEEVAL_ARRAY_SIZE(vals))
+			      vals, TRACEEVAL_ARRAY_SIZE(vals))
 
 int traceeval_remove_size(struct traceeval *teval,
 			  const struct traceeval_data *keys, size_t nr_keys);
-- 
2.40.1

