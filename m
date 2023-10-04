Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAFC1BDEE
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Oct 2023 22:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC17C433C8;
	Wed,  4 Oct 2023 22:51:17 +0000 (UTC)
Date: Wed, 4 Oct 2023 18:52:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>, Stevie Alvarez 
 <stevie.6strings@gmail.com>
Subject: [PATCH] libtraceeval: Use trick to force static array usage where
 needed
Message-ID: <20231004185225.366c1739@gandalf.local.home>
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

Some functions use the TRACEEVAL_ARRAY_SIZE() macro to determine the size
of the array passed to it. But this will not work if the developer uses a
pointer to the array. gcc may give a warning, but it will still happily
compile it leaving the developer wondering why their code does not work.

Use a little trick that checks and tests if the array is static, and will
fail the build if it is not.

 #define TRACEEVAL_ARRAY_SIZE(data)					\
	((sizeof(data) / sizeof((data)[0])) +				\
	(int)(sizeof(struct {						\
		int:(-!!(__builtin_types_compatible_p(typeof(data),	\
						      typeof(&((data)[0]))))); \
			})))

Going backwards to explain the above, we have:

  __builtin_types_compatible_p(typeof(data), typeof(&((data)[0]))

Which is a gcc/clang compiler directive that returns true if the two
pointers are compatible [ (a, b) where a = b is valid ]. For a static
array, we would have

 struct traceeval_data data[5]

Where typeof(data) is "struct traceeval_data []" and the type of
 &data[0] is a pointer to "struct traceeval_data", and the above
would return false (zero) [ data = &data[0] is invalid ].

For pointers:

 struct traceeval_data *data;

Then type of data is the same as &data[0] and it would return true (1).
[ data = &data[0] is valid ]

Now we have a structure defined:

  struct {
    int: (-!!(<result>));
  }

Which if <result> of the __builtin_types_compatible_p() returned false
(zero), then it would be:

  struct {
    int: 0; // structure with int size of 0 bits
 }

Which is perfectly valid. But if <result> returned true (as it would if it
was a pointer and not a static array), then it would be:

  struct {
     int: -1;  // structure with int size of -1 bits!
  }

Which is not valid to compile, and the build will fail.

But in order to make sure this is in the code that uses
TRACEEVAL_ARRAY_SIZE(), it needs to be part of the computation. To do
that, as "struct { int:0; }" is of size zero, we can simply add a sizeof()
around it, and attach the above with an addition "+".

 ... + sizeof((int)(sizeof(struct { int:0;}))) is the same as:

 ... + 0

Now with this logic, if a pointer is passed to something like
traceeval_init(), it will fail to build, and not cause hours of scratching
head debugging for the developer at runtime.

Of course, the developer will likely now scratch their head on why it
doesn't build, but that's because they didn't RTFM!

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/traceeval.h b/include/traceeval.h
index 4cc5eb6ef3de..6c6e09c53129 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -17,7 +17,12 @@
 /* Field name/descriptor for number of hits */
 #define TRACEEVAL_VAL_HITS ((const char *)(-1UL))
 
-#define TRACEEVAL_ARRAY_SIZE(data)	(sizeof(data) / sizeof((data)[0]))
+#define TRACEEVAL_ARRAY_SIZE(data)					\
+	((sizeof(data) / sizeof((data)[0])) +				\
+	(int)(sizeof(struct {						\
+		int:(-!!(__builtin_types_compatible_p(typeof(data),	\
+						      typeof(&((data)[0]))))); \
+			})))
 
 /* Data type distinguishers */
 enum traceeval_data_type {
-- 
2.40.1

