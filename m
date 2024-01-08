Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBF146456
	for <linux-trace-devel@vger.kernel.org>; Mon,  8 Jan 2024 23:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52751C433C7
	for <linux-trace-devel@vger.kernel.org>; Mon,  8 Jan 2024 23:40:27 +0000 (UTC)
Date: Mon, 8 Jan 2024 18:41:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] trace-cmd stat: Add sub-buffer size
Message-ID: <20240108184123.62f9be6b@gandalf.local.home>
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

Show the sub-buffer size if the file system supports it and it is different
than the architecture page size.

This requires libtracefs 1.8, so update the Makefile with that
requirement.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/linux-trace-devel/20231228222008.2742615a@rorschach.local.home

- Added requirement of libtracefs version 1.8 in Makefile and meson.build.

 Makefile              | 2 +-
 meson.build           | 2 +-
 tracecmd/trace-stat.c | 7 +++++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 7058159cf51b..5429859760af 100644
--- a/Makefile
+++ b/Makefile
@@ -23,7 +23,7 @@ export LIBTRACECMD_VERSION
 VERSION_FILE = ltc_version.h
 
 LIBTRACEEVENT_MIN_VERSION = 1.5
-LIBTRACEFS_MIN_VERSION = 1.6
+LIBTRACEFS_MIN_VERSION = 1.8
 
 MAKEFLAGS += --no-print-directory
 
diff --git a/meson.build b/meson.build
index fbdf016f67a7..aadfe277b5be 100644
--- a/meson.build
+++ b/meson.build
@@ -25,7 +25,7 @@ htmldir = join_paths(prefixdir, get_option('htmldir'))
 conf = configuration_data()
 
 libtraceevent_dep = dependency('libtraceevent', version: '>= 1.5.0', required: true)
-libtracefs_dep = dependency('libtracefs', version: '>= 1.6.0', required: true)
+libtracefs_dep = dependency('libtracefs', version: '>= 1.8.0', required: true)
 
 threads_dep = dependency('threads', required: true)
 dl_dep = cc.find_library('dl', required : false)
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 9a6e22254b48..1d95d9934b47 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -633,6 +633,8 @@ static void report_buffers(struct buffer_instance *instance)
 	char *str;
 	char *cont;
 	char file[FILE_SIZE];
+	int pagesize;
+	int bufsize;
 	int cpu;
 
 	str = tracefs_instance_file_read(instance->tracefs, "buffer_size_kb", NULL);
@@ -678,6 +680,11 @@ static void report_buffers(struct buffer_instance *instance)
 	printf("\nBuffer total size in kilobytes:\n");
 	printf("   %s\n", str);
 
+	pagesize = getpagesize();
+	bufsize = tracefs_instance_get_subbuf_size(instance->tracefs);
+	if (bufsize > 0 && bufsize * 1024 != pagesize)
+		printf("\nSub-buffer size in kilobytes:\n   %d\n", bufsize);
+
  out:
 	free(str);
 }
-- 
2.43.0

