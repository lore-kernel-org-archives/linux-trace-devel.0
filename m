Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8E939E171
	for <linux-trace-devel@vger.kernel.org>; Tue, 20 Jan 2026 20:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768940123; cv=none; b=Qp4/85zmUUMHmZSQAM1Rxe8MfcsyOx3hnYnr/X6wSEkVpaZW+KQzAgwJOy6MeIK3oBW7rB5+d9cxpUDLtOqeud40epNbw9O3PZATIe/I22jvwo+OskoDtTPGnf+OrnRCgtGExczz0e2EGZJHwT1Kk6eAtJ9nsQL/bUUWTtVcfB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768940123; c=relaxed/simple;
	bh=+O/FgdDGRG9aCrKetiCN9Xasn9vM/aNabHkFxZIaChw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5koyEYwiYR47fAgAstEk9Oy8Aa6oA9yNLuz5LH5eAOw2+On42sosfllJkwRPhhriAiU3uPjxwj19wz+Akvy311CmjOT9pFQ9qs/Sz2k32/HvCcAF4occMQB0gRAvba8ispepvn4idrEPu5/X7gIW+DdrgYbY0553rdbMRGCzzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E38C16AAE;
	Tue, 20 Jan 2026 20:15:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1viI8f-00000001vwP-1aLo;
	Tue, 20 Jan 2026 15:15:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtraceevent: Add tep_btf_list_args()
Date: Tue, 20 Jan 2026 15:13:37 -0500
Message-ID: <20260120201543.460979-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260120201543.460979-1-rostedt@goodmis.org>
References: <20260120201543.460979-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tep_btf_list_args() to display a function's prototype:

 struct trace_seq s;

 trace_seq_init(&s);
 tep_btf_list_args(tep, &s, "proc_scheduler");
 trace_seq_do_printf(&s);

produces:

    const struct ctl_table *ctl, int write, void *buffer, size_t *lenp, loff_t *ppos

Where the prototype of proc_scheduler() is:

 static int proc_scheduler(const struct ctl_table *ctl, int write,
			  void *buffer, size_t *lenp, loff_t *ppos)

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-btf-proto.txt | 124 ++++++++++++++++++
 Documentation/libtraceevent.txt           |   1 +
 include/traceevent/event-parse.h          |   1 +
 src/trace-btf.c                           | 151 +++++++++++++++++++++-
 4 files changed, 275 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/libtraceevent-btf-proto.txt

diff --git a/Documentation/libtraceevent-btf-proto.txt b/Documentation/libtraceevent-btf-proto.txt
new file mode 100644
index 000000000000..1a51edd7ed4d
--- /dev/null
+++ b/Documentation/libtraceevent-btf-proto.txt
@@ -0,0 +1,124 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_btf_list_args - Show the arguments of a function from BTF
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_btf_list_args*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, const char pass:[*]_func_);
+--
+
+DESCRIPTION
+-----------
+If the Linux kernel has BTF configured, then a binary file will exist
+in the path of */sys/kernel/btf/vmlinux*. If this file is read into memory
+and passed to *tep_load_btf()* function, then it can be used to read the arguments
+of a given function, if that function data is found within the BTF file.
+
+The *tep_btf_print_args()* takes a _tep_ handle, a trace_seq _s_ pointer
+(that was initialized by *trace_seq_init(3)*), and a _func_ string that is
+the name of the function to find the BTF information to use to print the function's prototype. 
+If BTF is not loaded or the _func_ name is not found it will return a negative.
+
+RETURN VALUE
+------------
+*tep_btf_list_args()* returns the number of arguments read on success and -1 on failure
+(for example, if the function is not found).
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <event-parse.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#define BTF_FILE "/sys/kernel/btf/vmlinux"
+
+int main(int argc, char **argv)
+{
+	struct tep_handle *tep;
+	struct trace_seq s;
+	struct stat st;
+	char *buf;
+	int fd, r, z;
+
+	if (argc < 2)
+		exit(-1);
+
+	if (stat(BTF_FILE, &st) < 0) {
+		perror(BTF_FILE);
+		exit(-1);
+	}
+
+	buf = malloc(st.st_size);
+	if (!buf)
+		exit(-1);
+	fd = open(BTF_FILE, O_RDONLY);
+	if (fd < 0) {
+		perror(BTF_FILE);
+		exit(-1);
+	}
+	for (z = 0; z < st.st_size; ) {
+		r = read(fd, buf + z, st.st_size - z);
+		if (r <= 0)
+			break;
+		z += r;
+	}
+	close(fd);
+	tep = tep_alloc();
+	if (!tep)
+		exit(-1);
+
+	tep_load_btf(tep, buf, z);
+	free(buf);
+
+	trace_seq_init(&s);
+	tep_btf_list_args(tep, &s, argv[1]);
+	printf("%s(", argv[1]);
+	trace_seq_do_printf(&s);
+	printf(")\n");
+	exit(0);
+}
+
+--
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*tep_btf_load*(3), *tep_btf_print_args*(3), *libtraceevent*(3), *trace-cmd*(1)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 5fb5fc19ffc1..6e5fdbc6e886 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -170,6 +170,7 @@ BTF parsing:
 	int *tep_load_btf*(struct tep_handle pass:[*]_tep_, void pass:[*]_raw_data_, size_t _data_size_);
 	int *tep_btf_print_args*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, void pass:[*]_args_,
 		       int nmem, int size, const char pass:[*]_func_);
+	int *tep_btf_list_args*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, const char pass:[*]_func_);
 
 Trace sequences:
 *#include <trace-seq.h>*
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 9c1abfae28d9..0070e21eb952 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -589,6 +589,7 @@ struct kbuffer *tep_kbuffer(struct tep_handle *tep);
 
 /* BTF */
 int tep_load_btf(struct tep_handle *tep, void *raw_data, size_t data_size);
+int tep_btf_list_args(struct tep_handle *tep, struct trace_seq *s, const char *func);
 int tep_btf_print_args(struct tep_handle *tep, struct trace_seq *s, void *args,
 		       int nmem, int size, const char *func);
 
diff --git a/src/trace-btf.c b/src/trace-btf.c
index 0b733bf9cb75..cf5a9780ab8e 100644
--- a/src/trace-btf.c
+++ b/src/trace-btf.c
@@ -323,6 +323,89 @@ static struct btf_type *btf_skip_modifiers(struct tep_btf *btf, int id)
 	return t;
 }
 
+static void add_name(struct tep_btf *btf, struct btf_type *t,
+		     struct trace_seq *s, const char *alt)
+{
+	const char *name;
+
+	name = btf_name(btf, t->name_off);
+	if (name)
+		trace_seq_printf(s, "%s ", name);
+	else if (alt)
+		trace_seq_printf(s, "%s ", alt);
+	else
+		trace_seq_puts(s, "?? ");
+}
+
+static void btf_add_type(struct tep_btf *btf, struct trace_seq *s, int id)
+{
+	struct btf_type *t = btf_get_type(btf, id);
+	unsigned int encode;
+	int bits;
+
+	while (t) {
+		switch (BTF_INFO_KIND(t->info)) {
+		case BTF_KIND_TYPEDEF:
+			add_name(btf, t, s, "typedef");
+			return;
+
+		case BTF_KIND_ENUM:
+			trace_seq_puts(s, "enum ");
+			add_name(btf, t, s, NULL);
+			return;
+
+		case BTF_KIND_STRUCT:
+			trace_seq_puts(s, "struct ");
+			add_name(btf, t, s, NULL);
+			return;
+
+		case BTF_KIND_UNION:
+			trace_seq_puts(s, "union ");
+			add_name(btf, t, s, NULL);
+			return;
+
+		case BTF_KIND_PTR:
+			if (t->type)
+				btf_add_type(btf, s, t->type);
+			else
+				trace_seq_puts(s, "void ");
+			trace_seq_puts(s, "*");
+			return;
+
+		case BTF_KIND_VOLATILE:	trace_seq_puts(s, "volatile ");
+			btf_add_type(btf, s, t->type);
+			return;
+
+		case BTF_KIND_CONST:	trace_seq_puts(s, "const ");
+			btf_add_type(btf, s, t->type);
+			return;
+
+		case BTF_KIND_INT:
+			encode = *(int *)((void *)t + sizeof(*t));
+			if (!(BTF_INT_ENCODING(encode) & BTF_INT_SIGNED))
+				trace_seq_puts(s, "unsigned ");
+
+			bits = BTF_INT_BITS(encode);
+			switch (bits) {
+			case 8:		trace_seq_puts(s, "char "); break;
+			case 16:	trace_seq_puts(s, "short "); break;
+			case 32:	trace_seq_puts(s, "int "); break;
+			case 64:	trace_seq_puts(s, "long long "); break;
+			default:	trace_seq_printf(s, "int%d ", bits);
+			}
+			return;
+
+
+		case BTF_KIND_RESTRICT:
+		case BTF_KIND_TYPE_TAG:
+			id = t->type;
+			t = btf_get_type(btf, t->type);
+			continue;
+		}
+		break;
+	}
+}
+
 static void assign_arg(unsigned long long *arg, void *args, int size, int a)
 {
 	*arg = size == 4 ?
@@ -338,7 +421,7 @@ static int init_btf_func(struct tep_btf *btf, struct trace_seq *s,
 	unsigned long long arg;
 	const char *fp;
 
-	if (size != 4 && size != 8)
+	if (args && (size != 4 && size != 8))
 		return -1;
 
 	if (!type && (fp = strchr(func, '.'))) {
@@ -353,7 +436,7 @@ static int init_btf_func(struct tep_btf *btf, struct trace_seq *s,
 	}
 
 	if (!type) {
-		for (int i = 0; i < nmem; i++) {
+		for (int i = 0; args && i < nmem; i++) {
 			assign_arg(&arg, args, size, i);
 			trace_seq_printf(s, "%llx", arg);
 			if (i + 1 < nmem)
@@ -375,6 +458,70 @@ static int init_btf_func(struct tep_btf *btf, struct trace_seq *s,
 	return 0;
 }
 
+/**
+ * tep_btf_list_args - List the arguments (type and name) for a function
+ * @tep: The tep descriptor to use
+ * @s: The trace_seq to write the arguments into
+ * @func: The name of the function.
+ *
+ * Loads up @s with the type and name of @func's arguments (basically
+ * its prototype).
+ *
+ * Returns: number of arguments found, or -1 on failure.
+ */
+int tep_btf_list_args(struct tep_handle *tep, struct trace_seq *s, const char *func)
+{
+	struct tep_btf *btf = tep->btf;
+	struct btf_type *type = tep_btf_find_func(btf, func);
+	struct btf_param *param;
+	const char *param_name;
+	int p, nr;
+
+	if (init_btf_func(btf, s, NULL, 0, 0, func, &type) < 0)
+		return -1;
+
+	/* Type is NULL if function wasn't found */
+	if (!type)
+		return -1;
+
+	/* Get the function proto */
+	type = btf_get_type(btf, type->type);
+
+	/* No proto means "()" ? */
+	if (!type)
+		return 0;
+
+	if (BTF_INFO_KIND(type->info) != BTF_KIND_FUNC_PROTO) {
+		tep_warning("Invalid func proto type %d %s for function %s\n",
+			    BTF_INFO_KIND(type->info),
+			    btf_type_str(type), func);
+		return -1;
+	}
+
+	/* Get the number of parameters */
+	nr = BTF_INFO_VLEN(type->info);
+
+	/* The parameters are right after the FUNC_PROTO type */
+	param = ((void *)type) + sizeof(*type);
+
+	for (p = 0; p < nr; p++) {
+
+		if (p)
+			trace_seq_puts(s, ", ");
+
+		param_name = btf_name(btf, param[p].name_off);
+		if (!param_name)
+			param_name = "??";
+
+		btf_add_type(btf, s, param[p].type);
+
+
+		if (param_name)
+			trace_seq_printf(s, "%s", param_name);
+	}
+	return p;
+}
+
 /**
  * tep_btf_print_args - Print function arguments from BTF info
  * @tep: The tep descriptor to use
-- 
2.51.0

