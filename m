Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B1E182D0
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Feb 2026 01:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770168135; cv=none; b=GBYpez1DVf2M/QrFZyZPh7b0lXeF0x9/v8DMQstft1REPNU4f8VYQPkabAQhBmSA+H2283pFQ5Sib2wTOMhj68CFYJ3GXWL2RnDdqOrdCj+UMG63Ayr3qudWHzxhD8tdqy4KLWr2j+/nnXqtnBCixvcys1hVszNfawyXHz3Rljc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770168135; c=relaxed/simple;
	bh=ghNsgbETDNZfT3oZWD8/7khAIv8/jQm7nbBQDPseCBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byHOlAPHv+oBtJPFxsDmVBF5J0m+6VTyauTnj+4EYC8n8Uk/bYsNSTPiENCjFr9PjvdRQEGR+nTT2MUvJGBFx+oz5FiOOl5wNBgQuDaM9lQypoxKC9XNpbtpo75yhRhxqroSqkLyhNKgw43ula7Kv/UQ93lcDQjCZcBXcZ+A/1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED3BC116D0;
	Wed,  4 Feb 2026 01:22:15 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnRbR-00000008xa7-1Bhd;
	Tue, 03 Feb 2026 20:22:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] trace-cmd record: Handle last_boot_info file
Date: Tue,  3 Feb 2026 20:18:05 -0500
Message-ID: <20260204012244.2135465-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260204012244.2135465-1-rostedt@goodmis.org>
References: <20260204012244.2135465-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

A persistent ring buffer has the ability to record a trace and have it
exposed after a crash or reboot. The issue with that buffer is that the
function pointers in it have the addresses of the last boot (the one that
the function events were recorded in). Due to KASLR, these address do not
match the address in kallsyms and can not be used directly to map the
address to the names of the functions.

To solve this, the kernel exposes the addresses in a last_boot_info file
if the content of the buffer is from the last boot. If the content is of
the current boot, the file simply contains "# Current".

If the file exists in the instance and contains something other than
"# Current" then record it into a new section called
TRACECMD_OPTION_LAST_BOOT_INFO.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../trace-cmd/trace-cmd.dat.v7.5.txt          |  7 +++
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-ftrace.c                  |  4 +-
 lib/trace-cmd/trace-input.c                   | 12 +++++
 tracecmd/include/trace-local.h                |  2 +
 tracecmd/trace-record.c                       | 49 +++++++++++++++++++
 6 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
index 73857d1a04f8..154ffe271df3 100644
--- a/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
+++ b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
@@ -276,6 +276,13 @@ OPTIONS SECTION
      compression algorthim defined by the trace.dat header. The compression data
      includes the size of the uncompressed output.
 
+  LAST_BOOT_INFO: id 24, size vary
+    The LAST_BOOT_INFO option data contains the content of the last_boot_info if
+     the file existed for an instance. It starts with the instance name, followed
+     by a colon ":" and then the content of the last_boot_info file. Currently
+     the instance name is not used, but exists in case in the future there are
+     more than one instance with this file.
+
 HEADER INFO SECTION
 -------------------
 
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 4743bbc62048..cf19c0d6f7e1 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -160,6 +160,7 @@ enum {
 	TRACECMD_OPTION_CMDLINES,
 	TRACECMD_OPTION_BUFFER_TEXT,
 	TRACECMD_OPTION_BTF_FILE,
+	TRACECMD_OPTION_LAST_BOOT_INFO,
 	TRACECMD_OPTION_MAX,
 };
 
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index f52b203ccbd4..c874113bc66e 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -272,7 +272,7 @@ print_graph_entry_leaf(struct trace_seq *s,
 	}
 
 	/* In case this is a retaddr event */
-	if (!tep_get_field_val(s, event, "retaddr", record, &val, 1))
+	if (!tep_get_field_val(s, event, "retaddr", record, &val, 0))
 		retfunc = tep_find_function(pevent, val);
 
 	duration = rettime - calltime;
@@ -347,7 +347,7 @@ static int print_graph_nested(struct trace_seq *s,
 		return trace_seq_putc(s, '!');
 
 	/* In case this is a retaddr event */
-	if (!tep_get_field_val(s, event, "retaddr", record, &val, 1))
+	if (!tep_get_field_val(s, event, "retaddr", record, &val, 0))
 		retfunc = tep_find_function(pevent, val);
 
 	/* Function */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 7e03c0da5485..ef5095b83b09 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4227,6 +4227,18 @@ static int handle_options(struct tracecmd_input *handle)
 			if (!(handle->flags & TRACECMD_FL_RAW_TS))
 				handle->flags |= TRACECMD_FL_IN_USECS;
 			break;
+		case TRACECMD_OPTION_LAST_BOOT_INFO:
+			{
+				char *file;
+
+				/* Skip the name of the instance (for now) */
+				file = strchr(buf, ':');
+				if (!file)
+					break;
+				file++;
+				tep_parse_last_boot_info(handle->pevent, file);
+				break;
+			}
 		case TRACECMD_OPTION_HEADER_INFO:
 		case TRACECMD_OPTION_FTRACE_EVENTS:
 		case TRACECMD_OPTION_EVENT_FORMATS:
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 4ad07b6357b1..32c5c5a3c4e9 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -298,6 +298,8 @@ struct buffer_instance {
 	int			argc;
 	char			**argv;
 
+	char			*last_boot_info;
+
 	struct addrinfo		*result;
 	unsigned int		cid;
 	unsigned int		port;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 30727d613492..dfa6cb91c436 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4778,6 +4778,22 @@ static void record_data(struct common_record_context *ctx)
 							cpus);
 				add_buffer_stat(handle, instance);
 				check_need_btf(&need_btf, instance->tracefs);
+				if (instance->last_boot_info && instance->name) {
+					char *buf;
+					int len;
+
+					if (asprintf(&buf, "%s:%s", instance->name,
+						     instance->last_boot_info) < 0) {
+						warning("Failed to add last_boot_info");
+						continue;
+					}
+					len = strlen(instance->name);
+					len += strlen(instance->last_boot_info) + 2;
+
+					tracecmd_add_option(handle, TRACECMD_OPTION_LAST_BOOT_INFO,
+							    len, buf);
+					free(buf);
+				}
 			}
 		}
 
@@ -7425,6 +7441,37 @@ void trace_set(int argc, char **argv)
 	exit(0);
 }
 
+static void read_last_boot_info(void)
+{
+	struct buffer_instance *instance;
+	char *path;
+	char *buf;
+
+	for_all_instances(instance) {
+		if (is_guest(instance))
+			continue;
+
+		if (!tracefs_file_exists(instance->tracefs, "last_boot_info"))
+			continue;
+
+		path = tracefs_instance_get_file(instance->tracefs, "last_boot_info");
+		if (!path) {
+			warning("Could not read last_boot_info");
+			return;
+		}
+		buf = read_file(path);
+		tracefs_put_tracing_file(path);
+		if (!buf) {
+			warning("Could not copy last_boot_info");
+			return;
+		}
+		if (strncmp(buf, "# Current", 9) == 0)
+			free(buf);
+		else
+			instance->last_boot_info = buf;
+	}
+}
+
 void trace_extract(int argc, char **argv)
 {
 	struct common_record_context ctx;
@@ -7466,6 +7513,8 @@ void trace_extract(int argc, char **argv)
 	if (ctx.events)
 		expand_event_list();
 
+	read_last_boot_info();
+
 	page_size = getpagesize();
 	update_plugins(type);
 	set_options();
-- 
2.51.0

