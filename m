Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAE230C373
	for <linux-trace-devel@vger.kernel.org>; Wed, 21 Jan 2026 19:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769024780; cv=none; b=j1Nxt+8eMpmHvYOnxaXCcGat+n9FKEwyO3B8GjGiETCbBOVT3vok0+m2GM9BJwzmH7DC9etPrpNXNQjcfwuwG99epQT6FnzNnEK44HfDkKYoOYrZMMiY8PNCNCMsvqDJLN+Vf2ywZGUYkjQx2iOqpwICNm5dIatsLe4m5yQ4+vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769024780; c=relaxed/simple;
	bh=9ar1z445Oq+MwRu/uQxn+s73/s57CALrVqJuWuhK+gI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=EOPg0u8PjOVYI/KVWXbmi6lVvIciuEbAYddlvq3GH8G+s3y5zS1Ati6eS2YgKbNRouBGqO73si2ayJHV45rCKYpheM+TcPkWKNDIpYBueoWQ9cKD8PvQWh2GDUcs7Pcuxw71dgKseqwq/3lUeEvzAPLJKSm1mvkKnQU3DqyFiqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 016178D0C3
	for <linux-trace-devel@vger.kernel.org>; Wed, 21 Jan 2026 19:37:41 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id B45DE8000E
	for <linux-trace-devel@vger.kernel.org>; Wed, 21 Jan 2026 19:37:40 +0000 (UTC)
Date: Wed, 21 Jan 2026 14:38:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd list: Add --proto option to show fuction
 prototype
Message-ID: <20260121143803.0a20acda@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: B45DE8000E
X-Stat-Signature: iuddedxzmcs8ptsxmborxkfj3dpyxrqg
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18cw8JaV4AcDmbGO/75gk3yVPp/9UkvT+8=
X-HE-Tag: 1769024260-684058
X-HE-Meta: U2FsdGVkX1/DNdfNUASKaAq+Dum/rFM0YDbh5s35UBqhw0CBkNdyfHKn59sLV+2VNZzM1C/yavvoVlkrwcYtx73qU9Pdm3KHfYbeVNIwwl1gSZNu5vbGbFu/cJchNkPL5gitHqNYWCcIh9fYk6IrEx7F6AXvXd4Sn6wSaaaRsosM4+JxbcJPAyr25zN5S4uGopBcyE3Em6HIbTd1OuKKoo2ynCzqnkKSzDTN51vVjbHI0dRJX/nhxD7R5TyWH+7xUNd+SaBj7AMLn4yTa+DU7SROtWfFQDrcFUKjIdYyUPW0EdEMq7WiBTDV5PUWbawap3jWI4fd0ksALd1nmoHQ7LPKDnNYL5ufniEiMTJRhWtqOTN+mKB24DCiLmSSiVmj

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If BTF is available and the user adds --proto to the command line, the
function list (-f) will include the prototypes of the functions.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-list.1.txt |  7 ++
 tracecmd/trace-cmd.bash                      |  2 +-
 tracecmd/trace-list.c                        | 76 ++++++++++++++++++--
 tracecmd/trace-usage.c                       |  1 +
 4 files changed, 81 insertions(+), 5 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-list.1.txt b/Documentation/trace-cmd/trace-cmd-list.1.txt
index b77e3460..e0a1a3b8 100644
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
index a7e81e0d..fca77201 100644
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
index b9e23f66..da2604ed 100644
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
@@ -474,9 +476,53 @@ static void show_clocks(void)
 	free(clocks);
 }
 
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
+
+	if (!tep || tep_load_btf(tep, buf, s) < 0) {
+		tep_free(tep);
+		tep = NULL;
+	}
 
-static void show_functions(const char *funcre)
+	free(buf);
+	return tep;
+}
+
+static void show_functions(const char *funcre, int params)
 {
+	struct tep_handle *tep = NULL;
+	struct trace_seq s;
 	bool found = false;
 	char *new_re = NULL;
 	char **list;
@@ -487,6 +533,13 @@ static void show_functions(const char *funcre)
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
@@ -510,8 +563,18 @@ static void show_functions(const char *funcre)
 
 	if (tracefs_filter_functions(funcre, NULL, &list) < 0)
 		die("Failed to read filte functions");
-	for (i = 0; list && list[i]; i++)
-		printf("%s\n", list[i]);
+	for (i = 0; list && list[i]; i++) {
+		printf("%s", list[i]);
+		if (params) {
+			trace_seq_reset(&s);
+			if (tep_btf_list_args(tep, &s, list[i]) >= 0) {
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
@@ -652,6 +715,7 @@ void trace_list(int argc, char **argv)
 	int systems = 0;
 	int show_all = 1;
 	int compression = 0;
+	int params = 0;
 	int i;
 	const char *arg;
 	const char *funcre = NULL;
@@ -731,6 +795,10 @@ void trace_list(int argc, char **argv)
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
@@ -757,7 +825,7 @@ void trace_list(int argc, char **argv)
 		show_plugin_options();
 
 	if (funcs)
-		show_functions(funcre);
+		show_functions(funcre, params);
 
 	if (buffers)
 		show_buffers();
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 3fd975c0..f5a1c74c 100644
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
2.50.1

