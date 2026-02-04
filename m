Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B8281724
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Feb 2026 01:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770168135; cv=none; b=Ebz1xjMPqjouWJA1ngxtKJCclCNwPOyFJKRi5UxKbJRE5lwduVSWK5Na9FSWDvttnzs1tq+9Ajai2m4FwydxGmCDx1IiOEDOwfrOYLpTpnjAvrLkLJo0poDQod1lKtl83AT0kJFNSWtV/VBdaRCcAdNeyrGzkV7zH4bBPRs2y34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770168135; c=relaxed/simple;
	bh=JdVlv1uui4/zl/44spgxlbvgYVhhTdxCYia5gcxs6SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAKFC7ZiSrVw9glg5H+pfL9RgcFKXkREbWMndTnfM/yEJfy45SxBBPzCX2uqu8Y0O50ZHUv+5rbI3tta+Huh6edjbVY12uBh2DXvhgz+15/+ju28GQyCQlYDf8ei4hLjP/VSpsmu02RvihBHDf8SqHtA1Cb5sctImHvfy/AH4hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A4EC19425;
	Wed,  4 Feb 2026 01:22:15 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnRbR-00000008xaA-1I8A;
	Tue, 03 Feb 2026 20:22:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] trace-cmd record: Add section for /proc/modules
Date: Tue,  3 Feb 2026 20:18:06 -0500
Message-ID: <20260204012244.2135465-3-rostedt@goodmis.org>
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

Add a MODULES_FILE section that contains a compressed copy of the
/proc/modules file. This is recorded when the last_boot_info is recorded
so that the functions recorded in a previous boot can have their addresses
calculated with where the old modules were to find their function names in
the kallsyms file of the current boot.

To do that, the module addresses in the last_boot_info file is not enough.
It needs the module addresses of where they are loaded in the current boot
which is what /proc/modules contains.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../trace-cmd/trace-cmd.dat.v7.5.txt          | 24 +++++++++++---
 .../include/private/trace-cmd-private.h       |  2 ++
 lib/trace-cmd/trace-input.c                   | 19 +++++++++++
 lib/trace-cmd/trace-output.c                  | 32 +++++++++++++++++++
 tracecmd/trace-dump.c                         | 32 +++++++++++++++++++
 tracecmd/trace-record.c                       |  3 ++
 6 files changed, 107 insertions(+), 5 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
index 154ffe271df3..b8ecab20e123 100644
--- a/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
+++ b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
@@ -283,6 +283,12 @@ OPTIONS SECTION
      the instance name is not used, but exists in case in the future there are
      more than one instance with this file.
 
+  MODULES_FILE: id 25, size 8
+    The MODULES_FILE option data is:
+     A compressed data from the host file /proc/modules, using the compression
+     algorthim defined by the trace.dat header. The compression data includes
+     the size of the uncompressed output.
+
 HEADER INFO SECTION
 -------------------
 
@@ -455,15 +461,23 @@ BTF FILE SECTION
 
   Section ID: 23
 
-  Directly after the section header comes the information mapping
-  a PID to a process name.
-
-  The next 8 bytes contain a 64-bit word that holds the size of the
-  data mapping the PID to a process name.
+  Directly after the section header comes the a 8 byte value that contains
+  a 64-bit word that holds he size of the BTF file (may be compressed)
 
   The next set of data is of the size defined by the previous 8 bytes
   and contains the information from /sys/kernel/btf/vmlinux.
 
+MODULES FILE SECTION
+--------------------
+
+  Section ID: 25
+
+  Directly after the section header comes the a 8 byte value that contains
+  a 64-bit word that holds he size of the modules file (may be compressed)
+
+  The next set of data is of the size defined by the previous 8 bytes
+  and contains the information from /proc/modules.
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index cf19c0d6f7e1..33fa2f80dad1 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -161,6 +161,7 @@ enum {
 	TRACECMD_OPTION_BUFFER_TEXT,
 	TRACECMD_OPTION_BTF_FILE,
 	TRACECMD_OPTION_LAST_BOOT_INFO,
+	TRACECMD_OPTION_MODULES_FILE,
 	TRACECMD_OPTION_MAX,
 };
 
@@ -343,6 +344,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
 unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle);
 size_t tracecmd_get_out_file_offset(struct tracecmd_output *handle);
 int tracecmd_append_btf_file(struct tracecmd_output *handle);
+int tracecmd_append_modules_file(struct tracecmd_output *handle);
 
 /* --- Reading the Fly Recorder Trace --- */
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ef5095b83b09..22990430f14b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1048,6 +1048,21 @@ static inline int read_btf(struct tracecmd_input *handle)
 }
 #endif
 
+static int read_modules(struct tracecmd_input *handle)
+{
+	char *modules;
+	size_t size;
+
+	modules = tracecmd_uncompress_buffer(handle->compress, &size);
+	if (!modules)
+		return -1;
+
+	tep_load_modules(handle->pevent, modules, size);
+
+	free(modules);
+	return 0;
+}
+
 static int read_and_parse_cmdlines(struct tracecmd_input *handle);
 
 /**
@@ -1228,6 +1243,9 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 	case TRACECMD_OPTION_BTF_FILE:
 		ret = read_btf(handle);
 		break;
+	case TRACECMD_OPTION_MODULES_FILE:
+		ret = read_modules(handle);
+		break;
 	default:
 		ret = 0;
 		break;
@@ -4246,6 +4264,7 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_PRINTK:
 		case TRACECMD_OPTION_CMDLINES:
 		case TRACECMD_OPTION_BTF_FILE:
+		case TRACECMD_OPTION_MODULES_FILE:
 			if (size < 8)
 				break;
 			section_add_or_update(handle, option, -1,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c239f50b10e9..3ef6db6b80f2 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2324,6 +2324,38 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 	return 0;
 }
 
+#define MODULES_FILE "/proc/modules"
+
+int tracecmd_append_modules_file(struct tracecmd_output *handle)
+{
+	tsize_t offset;
+	struct stat st;
+	int ret;
+
+	if (!HAS_SECTIONS(handle))
+		return -1;
+
+	ret = stat(MODULES_FILE, &st);
+	if (ret < 0)
+		return -1;
+
+	offset = write_compress_section_header(handle, TRACECMD_OPTION_MODULES_FILE, "modules", true);
+	if (offset == (off_t)-1)
+		return -1;
+
+	tcmd_out_compression_start(handle);
+
+	copy_file(handle, MODULES_FILE);
+
+	if (tcmd_out_compression_end(handle))
+		return -1;
+
+	if (tcmd_out_update_section_header(handle, offset))
+		return -1;
+
+	return 0;
+}
+
 #define BTF_FILE "/sys/kernel/btf/vmlinux"
 
 int tracecmd_append_btf_file(struct tracecmd_output *handle)
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 0a21356e442d..6b115bf51b2d 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -47,6 +47,8 @@ enum dump_items {
 	CLOCK		= (1 << 11),
 	SECTIONS	= (1 << 12),
 	STRINGS		= (1 << 13),
+	LAST_BOOT_INFO	= (1 << 14),
+	MODULES_FILE	= (1 << 15),
 };
 
 struct file_section {
@@ -423,6 +425,22 @@ static void dump_cmdlines(int fd)
 	read_dump_string(fd, size, CMDLINES);
 }
 
+static void dump_modules(int fd)
+{
+	unsigned int size = 0;
+	char buf[1024];
+	int len;
+
+	do_print((SUMMARY | MODULES_FILE), "\t[Saved modules]\n");
+
+	while ((len = read_compressed(fd, buf, 1024)) > 0) {
+		do_print((SUMMARY | MODULES_FILE), "%*s", len, buf);
+		size += len;
+	}
+
+	do_print((SUMMARY | MODULES_FILE), "\n[%d bytes]\n", size);
+}
+
 static void dump_cpus_count(int fd)
 {
 	if (read_file_number(fd, &trace_cpus, 4))
@@ -801,6 +819,9 @@ static void dump_sections(int fd, int count)
 		case TRACECMD_OPTION_CMDLINES:
 			dump_cmdlines(fd);
 			break;
+		case TRACECMD_OPTION_MODULES_FILE:
+			dump_modules(fd);
+			break;
 		}
 		uncompress_reset();
 		sec = sec->next;
@@ -921,6 +942,12 @@ static int dump_options_read(int fd)
 		case TRACECMD_OPTION_CMDLINES:
 			dump_option_section(fd, size, option, "CMDLINES", CMDLINES);
 			break;
+		case TRACECMD_OPTION_LAST_BOOT_INFO:
+			dump_option_string(fd, size, "LAST_BOOT_INFO");
+			break;
+		case TRACECMD_OPTION_MODULES_FILE:
+			dump_option_section(fd, size, option, "MODULES_FILE", MODULES_FILE);
+			break;
 		case TRACECMD_OPTION_DONE:
 			uncompress_reset();
 			count += dump_option_done(fd, size);
@@ -1231,6 +1258,7 @@ enum {
 	OPT_ftrace	= 253,
 	OPT_head_event	= 254,
 	OPT_head_page	= 255,
+	OPT_modules	= 256,
 };
 
 void trace_dump(int argc, char **argv)
@@ -1257,6 +1285,7 @@ void trace_dump(int argc, char **argv)
 			{"kallsyms", no_argument, NULL, OPT_kallsyms},
 			{"printk", no_argument, NULL, OPT_printk},
 			{"cmd-lines", no_argument, NULL, OPT_cmd_lines},
+			{"modules", no_argument, NULL, OPT_modules},
 			{"options", no_argument, NULL, OPT_options},
 			{"flyrecord", no_argument, NULL, OPT_flyrecord},
 			{"clock", no_argument, NULL, OPT_clock},
@@ -1321,6 +1350,9 @@ void trace_dump(int argc, char **argv)
 		case OPT_clock:
 			verbosity |= CLOCK;
 			break;
+		case OPT_modules:
+			verbosity |= MODULES_FILE;
+			break;
 		case OPT_verbose:
 			if (trace_set_verbose(optarg) < 0)
 				die("invalid verbose level %s", optarg);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index dfa6cb91c436..a1f9b2363e9d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4793,6 +4793,9 @@ static void record_data(struct common_record_context *ctx)
 					tracecmd_add_option(handle, TRACECMD_OPTION_LAST_BOOT_INFO,
 							    len, buf);
 					free(buf);
+
+					/* Also add modules */
+					tracecmd_append_modules_file(handle);
 				}
 			}
 		}
-- 
2.51.0

