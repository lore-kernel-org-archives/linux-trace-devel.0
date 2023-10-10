Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3024D321B2
	for <linux-trace-devel@vger.kernel.org>; Tue, 10 Oct 2023 19:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA54C433CD;
	Tue, 10 Oct 2023 19:55:34 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqIqe-007VW7-1i;
	Tue, 10 Oct 2023 15:56:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtraceeval: Add traceeval_vwaring() API
Date: Tue, 10 Oct 2023 15:55:25 -0400
Message-ID: <20231010195655.1789420-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231010195655.1789420-1-rostedt@goodmis.org>
References: <20231010195655.1789420-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a way to tell the library to print any errors. As passing in wrong
size keys and such can cause errors, having a way to tell the library to
print output when that happens is useful.

Add a traceeval_set_log_level() and define the following log levels:

  TEVAL_NONE - Do not print anything
  TEVAL_CRIT - Print anything that is considered a critical error
  TEVAL_WARN - Print warnings (this includes bad array sizes)
  TEVAL_INFO - Print any message that might be interesting

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval.h | 11 +++++++++++
 src/eval-local.h    |  5 +++++
 src/histograms.c    | 48 ++++++++++++++++++++++++++++++++++-----------
 3 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/include/traceeval.h b/include/traceeval.h
index 2b4082e8dfcb..55d6df67375a 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -10,6 +10,7 @@
 
 #include <stdlib.h>
 #include <stddef.h>
+#include <stdarg.h>
 #include <stdbool.h>
 
 /* Data definition interfaces */
@@ -62,6 +63,16 @@ enum traceeval_flags {
 	TRACEEVAL_FL_STAT		= (1 << 4),
 };
 
+enum traceeval_log_level {
+	TEVAL_NONE		= 0,
+	TEVAL_CRIT,
+	TEVAL_WARN,
+	TEVAL_INFO,
+};
+
+extern void traceeval_vwarning(const char *fmt, va_list ap);
+extern void traceeval_set_log_level(enum traceeval_log_level level);
+
 struct traceeval_data_delta {
 	unsigned long long			delta;
 	unsigned long long			timestamp;
diff --git a/src/eval-local.h b/src/eval-local.h
index b0de30c713b4..252a1c1d2029 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -5,6 +5,7 @@
 #include <string.h>
 
 #define __hidden __attribute__((visibility ("hidden")))
+#define __weak __attribute__((weak))
 
 #define offset_of(type, field) ((size_t)(&(((type *)(NULL))->field)))
 #define container_of(ptr, type, field) \
@@ -14,6 +15,10 @@
 #define HASH_SIZE(bits)	(1 << (bits))
 #define HASH_MASK(bits)	(HASH_SIZE(bits) - 1)
 
+
+extern void __attribute__ ((format (printf, 2, 3)))
+ teval_print_err(int level, const char *fmt, ...);
+
 /*
  * Compare two integers of variable length.
  *
diff --git a/src/histograms.c b/src/histograms.c
index 4e03c967dca3..32ae4f180063 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -14,19 +14,43 @@
 #include <traceeval.h>
 #include "eval-local.h"
 
+static int warning_level = TEVAL_NONE;
+
+void traceeval_set_log_level(enum traceeval_log_level level)
+{
+	warning_level = level;
+}
+
+/**
+ * traceeval_vwarning - print a warning message
+ * @fmt: The format of the message
+ * @ap: The parameters for the format
+ *
+ * This can be overridden by the application, but by default it
+ * will print to stderr.
+ */
+__weak void traceeval_vwarning(const char *fmt, va_list ap)
+{
+	vfprintf(stderr, fmt, ap);
+	fprintf(stderr, "\n");
+}
+
 /*
- * print_err - print an error message
+ * teval_print_err - print an error message
+ * @level: The warning level of this message
  * @fmt: String format
  * @...: (optional) Additional arguments to print in conjunction with @format
  */
-static void print_err(const char *fmt, ...)
+__hidden void teval_print_err(int level, const char *fmt, ...)
 {
 	va_list ap;
 
+	if (level > warning_level)
+		return;
+
 	va_start(ap, fmt);
-	vfprintf(stderr, fmt, ap);
+	traceeval_vwarning(fmt, ap);
 	va_end(ap);
-	fprintf(stderr, "\n");
 }
 
 /*
@@ -78,7 +102,8 @@ static int compare_traceeval_data(struct traceeval *teval,
 		compare_numbers_return(orig->delta.delta, copy->delta.delta);
 
 	default:
-		print_err("%d is an invalid enum traceeval_data_type member",
+		teval_print_err(TEVAL_WARN,
+				"%d is an invalid enum traceeval_data_type member",
 				type->type);
 		return -2;
 	}
@@ -193,9 +218,10 @@ static size_t type_alloc(const struct traceeval_type *defs,
 
 fail:
 	if (defs[i].name)
-		print_err("Failed to allocate traceeval_type %zu", size);
+		teval_print_err(TEVAL_CRIT,
+				"Failed to allocate traceeval_type %zu", size);
 	else
-		print_err("traceeval_type list missing a name");
+		teval_print_err(TEVAL_WARN, "traceeval_type list missing a name");
 
 	for (; i >= 0; i--)
 		free(new_defs[i].name);
@@ -355,7 +381,7 @@ fail_release:
 	traceeval_release(teval);
 
 fail:
-	print_err(err_msg);
+	teval_print_err(TEVAL_WARN, err_msg);
 	return NULL;
 }
 
@@ -386,7 +412,7 @@ static void clean_data_set(struct traceeval_data *data, struct traceeval_type *d
 
 	if (!data || !defs) {
 		if (data)
-			print_err("Data to be freed without accompanied types!");
+			teval_print_err(TEVAL_INFO, "Data to be freed without accompanied types!");
 		return;
 	}
 
@@ -792,7 +818,7 @@ void traceeval_results_release(struct traceeval *teval,
 {
 	if (!teval || !results) {
 		if (!teval)
-			print_err("Results to be freed without accompanied traceeval instance!");
+			teval_print_err(TEVAL_INFO, "Results to be freed without accompanied traceeval instance!");
 		return;
 	}
 }
@@ -1554,7 +1580,7 @@ void traceeval_iterator_results_release(struct traceeval_iterator *iter,
 {
 	if (!iter || !results) {
 		if (!iter)
-			print_err("Results to be freed without accompanied iterator!");
+			teval_print_err(TEVAL_INFO, "Results to be freed without accompanied iterator!");
 		return;
 	}
 }
-- 
2.42.0

