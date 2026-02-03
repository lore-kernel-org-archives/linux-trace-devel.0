Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4662F2E11AA
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Feb 2026 22:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770157705; cv=none; b=ConDNeQouEhPbIGdiqKt35CTubh14IN+THV9s7Bi7gL3Ihw31UZNCNlNl/SLDCawUG+edZ2mK4DiJg9HBMARZIlg12VWNlPVIY79kwIzcxlg9lt6cH/Ywp64cJs1T/W8nPX2MjbdIUseSJtK/C0QOBseygHawklfYj6fcGCm+Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770157705; c=relaxed/simple;
	bh=Mk5O09bJDjraON0eC8z/W5sOiUiwf60lSOdakVtT7kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3uAU+xoiu4rsn0qknWc3H1wUWznsIn5bFA26RAA1fz79Q0JRZOu8fsgxkrUF4bNmzgQy3hHDEej7kegD2frHTdHnwYP3NUnQMn3lUQ5Zu08SgNP5h6LGqoTuQgqKK+AWWkdBsp6tXgYvoRHrAVPgMtR9a336ytQ9ZculiIM1ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EEEC19425;
	Tue,  3 Feb 2026 22:28:24 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnOtC-00000008qzo-26pR;
	Tue, 03 Feb 2026 17:28:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 1/2] libtraceevent: Split out btf func init code from tep_btf_print_args()
Date: Tue,  3 Feb 2026 17:27:26 -0500
Message-ID: <20260203222853.2110187-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260203222853.2110187-1-rostedt@goodmis.org>
References: <20260203222853.2110187-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In order to use BTF for various other attributes of functions, move out the
btf function initialization from the tp_btf_print_args() and into its own
function.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/trace-btf.c | 70 +++++++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 25 deletions(-)

diff --git a/src/trace-btf.c b/src/trace-btf.c
index d0231b49d144..0b733bf9cb75 100644
--- a/src/trace-btf.c
+++ b/src/trace-btf.c
@@ -330,35 +330,13 @@ static void assign_arg(unsigned long long *arg, void *args, int size, int a)
 		*(unsigned long long *)(args + a * sizeof(long long));
 }
 
-/**
- * tep_btf_print_args - Print function arguments from BTF info
- * @tep: The tep descriptor to use
- * @s: The trace_seq to write the arguments into
- * @args: The array that holds the arguments
- * @nmem: The number of arguments
- * @size: The size of each item in args (4 or 8).
- * @func: The name of the function.
- *
- * Loads up the @s with a list of arguments for the function based on
- * the @args.
- *
- * If there's no BTF loaded or @func is not found, then it just writes
- * the @args as raw numbers. Otherwise it will pretty print the
- * arguments based on the function info in BTF.
- *
- * Returns: 0 on success and -1 on failure.
- */
-int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
-		       int nmem, int size, const char *func)
+static int init_btf_func(struct tep_btf *btf, struct trace_seq *s,
+			 void *args, int nmem, int size,
+			 const char *func, struct btf_type **p_type)
 {
-	struct tep_btf *btf = tep->btf;
 	struct btf_type *type = tep_btf_find_func(btf, func);
-	struct btf_param *param;
 	unsigned long long arg;
-	unsigned int encode;
-	const char *param_name;
 	const char *fp;
-	int a, p, x, nr;
 
 	if (size != 4 && size != 8)
 		return -1;
@@ -381,6 +359,7 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 			if (i + 1 < nmem)
 				trace_seq_puts(s, ", ");
 		}
+		*p_type = NULL;
 		return 0;
 	}
 
@@ -391,6 +370,47 @@ int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 		return -1;
 	}
 
+	*p_type = type;
+
+	return 0;
+}
+
+/**
+ * tep_btf_print_args - Print function arguments from BTF info
+ * @tep: The tep descriptor to use
+ * @s: The trace_seq to write the arguments into
+ * @args: The array that holds the arguments
+ * @nmem: The number of arguments
+ * @size: The size of each item in args (4 or 8).
+ * @func: The name of the function.
+ *
+ * Loads up the @s with a list of arguments for the function based on
+ * the @args.
+ *
+ * If there's no BTF loaded or @func is not found, then it just writes
+ * the @args as raw numbers. Otherwise it will pretty print the
+ * arguments based on the function info in BTF.
+ *
+ * Returns: 0 on success and -1 on failure.
+ */
+int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
+		       int nmem, int size, const char *func)
+{
+	struct tep_btf *btf = tep->btf;
+	struct btf_type *type = tep_btf_find_func(btf, func);
+	struct btf_param *param;
+	unsigned long long arg;
+	unsigned int encode;
+	const char *param_name;
+	int a, p, x, nr;
+
+	if (init_btf_func(btf, s, args, nmem, size, func, &type) < 0)
+		return -1;
+
+	/* Type is NULL if function wasn't found */
+	if (!type)
+		return 0;
+
 	/* Get the function proto */
 	type = btf_get_type(btf, type->type);
 
-- 
2.51.0

