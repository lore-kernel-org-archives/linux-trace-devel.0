Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA24389E18
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Feb 2026 23:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770073997; cv=none; b=Tf+BGkv24Co1RhPs7t/wnMkjM5ILoXu0DEUoPOxvV/AEekjhWStCRRv7lTPqOQz41iWVDpDdH++ohlUTxa63YQo6kABC5rAmhvBJTkYmdSsHxNFKjHIbiAY52Tr2ZQCqrPSAOQO81pzx4p+lcvSINzPK2qmX+dYRpsNb0UTy1MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770073997; c=relaxed/simple;
	bh=Dvp0uQzfaIc6hOJVNuPhLM6M1sHZ/nkyx82CRFN3myc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=pO36EfowZhh38c+p2g1Qk/tV5bNTwyrCyrfj1qaPlCDh4hlFc1qNY15vxXnix/+/en8rCFGxaLkHdkG6xweeN/wN0GA6ima2z/QNHLiB4QY/sXHaFKLml+81wdHZ1nR+Op5K51Eg69M4/zvAI8UFgFUVG3/xLIybWFv2u54utL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3B62B7C6D
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Feb 2026 23:13:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id 824532F
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Feb 2026 23:13:08 +0000 (UTC)
Date: Mon, 2 Feb 2026 18:13:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] trace-cmd list: Add --proto option to show fuction
 prototype
Message-ID: <20260202181333.0b2f8f5f@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 824532F
X-Stat-Signature: 6gh38t5fiu6eaf6dj3sihc8ak138sftc
X-Rspamd-Server: rspamout08
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/YpuuU/2FcdyVaNFOL2Rx+xcQoBW1GE20=
X-HE-Tag: 1770073988-661949
X-HE-Meta: U2FsdGVkX184An/tY+oIVQu1ltjg2yaRHEhC9M8E2HgTHVTim2u2wjB1/SHmhl4GCG17bxt8yuNMGL4kSLUSFYcqYcKvcUZ12ATQVX/J78eBRrl39aCKB4mINMnaNTNXWx3B94Bb1sVtrnpQaEE+MBY//j8KfWb2LB+Z1ixQEdLXTOJso58qo1N2MgYfXWsPoXi27Yc/D23Yy8u1KMrO/TpBWWuJJuyAyZUxSQzuDYIHZ+i1lMih8L76Oo18JepI7wrHrTbWKtqqtmjCFIhDiMBseSEC5xqZmrQr0o1YQRu+gx115p8JFtSp9GQyAvc3EOhTPwr7GVuJ3wE25Qa1NDng4cSUyTUlDbG59GYrAP5AwOy8O/EcAVu2FrS8VqaT6gsluY5dzLlfgfs10xxQKQ==

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If BTF is available and the user adds --proto to the command line, the
function list (-f) will include the prototypes of the functions.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/20260121143803.0a20acda@gandalf.local.home

- Have it still build with libtraceevent 1.8 (no BTF)

 Documentation/trace-cmd/trace-cmd-list.1.txt |  7 ++
 tracecmd/trace-cmd.bash                      |  2 +-
 tracecmd/trace-list.c                        | 94 +++++++++++++++++++-
 tracecmd/trace-usage.c                       |  1 +
 4 files changed, 99 insertions(+), 5 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-list.1.txt b/Documentation/trace-cmd/trace-cmd-list.1.txt
index b77e3460c647..e0a1a3b86c9f 100644
--- a/Documentation/trace-cmd/trace-cmd-list.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-list.1.txt
@@ -58,6 +58,13 @@ OPTIONS
 
     trace-cmd list -f '^sched.*'
 
+    If *--proto* is also added to the command line, the functions will also have
+    show their prototypes if BTF is available.
+
+*--proto*::
+    If BTF is available on the running kernel, it will also show the function
+    parameters with *-f*.
+
 *-P*::
     List the plugin files that get loaded on trace-cmd report.
 
diff --git a/tracecmd/trace-cmd.bash b/tracecmd/trace-cmd.bash
index a7e81e0ded4a..fca772011593 100644
--- a/tracecmd/trace-cmd.bash
+++ b/tracecmd/trace-cmd.bash
@@ -108,7 +108,7 @@ __trace_cmd_list_complete()
     case "$prev" in
 	list)
 	    local cmds=$(trace-cmd list -h |egrep "^ {10}-" | \
-				 sed -e 's/.*\(-.\).*/\1/')
+				 sed -e 's/^ *\(-[^ ]*\).*/\1/')
 	    COMPREPLY=( $(compgen -W "${cmds}" -- "${cur}") )
 	    ;;
 	-e)
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index b9e23f66ab58..50b6a1d99ea9 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -6,10 +6,12 @@
 
 #include <stdlib.h>
 #include <sys/stat.h>
+#include <unistd.h>
 
 #include "tracefs.h"
 #include "trace-local.h"
 
+#define BTF_FILE	"/sys/kernel/btf/vmlinux"
 
 static void dump_file_content(const char *path)
 {
@@ -474,9 +476,71 @@ static void show_clocks(void)
 	free(clocks);
 }
 
+#ifdef HAVE_KERNEL_BTF
+static struct tep_handle *load_btf(void)
+{
+	struct tep_handle *tep;
+	struct stat st;
+	ssize_t size;
+	char *buf;
+	int ret;
+	int fd;
+	int r, s = 0;
+
+	ret = stat(BTF_FILE, &st);
+	if (ret < 0)
+		return NULL;
+
+	size = st.st_size;
+	buf = malloc(size);
+	if (!buf)
+		return NULL;
+
+	fd = open(BTF_FILE, O_RDONLY);
+	if (fd < 0)
+		return NULL;
+
+	while (size) {
+		r = read(fd, buf + s, size);
+		if (r < 0)
+			break;
+		s += r;
+		size -= r;
+	}
+	close(fd);
+
+	tep = tep_alloc();
 
-static void show_functions(const char *funcre)
+	if (!tep || tep_load_btf(tep, buf, s) < 0) {
+		tep_free(tep);
+		tep = NULL;
+	}
+
+	free(buf);
+	return tep;
+}
+
+static int btf_list_args(struct tep_handle *tep, struct trace_seq *s,
+			 const char *func)
+{
+	return tep_btf_list_args(tep, s, func);
+}
+#else
+static inline struct tep_handle *load_btf(void)
 {
+	return NULL;
+}
+static int btf_list_args(struct tep_handle *tep, struct trace_seq *s,
+			 const char *func)
+{
+	return 0;
+}
+#endif
+
+static void show_functions(const char *funcre, int params)
+{
+	struct tep_handle *tep = NULL;
+	struct trace_seq s;
 	bool found = false;
 	char *new_re = NULL;
 	char **list;
@@ -487,6 +551,13 @@ static void show_functions(const char *funcre)
 		return;
 	}
 
+	trace_seq_init(&s);
+	if (params) {
+		tep = load_btf();
+		if (!tep)
+			params = 0;
+	}
+
 	/* if the re doesn't have any regular expressions, then add them */
 	for (i = 0; !found && funcre[i]; i++) {
 		if (funcre[i] == '\\')
@@ -510,8 +581,18 @@ static void show_functions(const char *funcre)
 
 	if (tracefs_filter_functions(funcre, NULL, &list) < 0)
 		die("Failed to read filte functions");
-	for (i = 0; list && list[i]; i++)
-		printf("%s\n", list[i]);
+	for (i = 0; list && list[i]; i++) {
+		printf("%s", list[i]);
+		if (params) {
+			trace_seq_reset(&s);
+			if (btf_list_args(tep, &s, list[i]) >= 0) {
+				printf("(");
+				trace_seq_do_printf(&s);
+				printf(")");
+			}
+		}
+		printf("\n");
+	}
 	tracefs_list_free(list);
 	free(new_re);
 }
@@ -652,6 +733,7 @@ void trace_list(int argc, char **argv)
 	int systems = 0;
 	int show_all = 1;
 	int compression = 0;
+	int params = 0;
 	int i;
 	const char *arg;
 	const char *funcre = NULL;
@@ -731,6 +813,10 @@ void trace_list(int argc, char **argv)
 					flags |= SHOW_EVENT_FULL;
 					break;
 				}
+				if (strcmp(argv[i], "--proto") == 0) {
+					params = 1;
+					break;
+				}
 				fprintf(stderr, "list: invalid option -- '%s'\n",
 					argv[i]);
 			default:
@@ -757,7 +843,7 @@ void trace_list(int argc, char **argv)
 		show_plugin_options();
 
 	if (funcs)
-		show_functions(funcre);
+		show_functions(funcre, params);
 
 	if (buffers)
 		show_buffers();
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 3fd975c00a6b..f5a1c74c2ddf 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -391,6 +391,7 @@ static struct usage_help usage_help[] = {
 		"          -B list defined buffer instances\n"
 		"          -C list the defined clocks (and active one)\n"
 		"          -c list the supported trace file compression algorithms\n"
+		"          --proto list the prototype of a function (if BTF is available)\n"
 	},
 	{
 		"restore",
-- 
2.51.0

