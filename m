Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbfAIVUP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jan 2019 16:20:15 -0500
Date: Wed, 9 Jan 2019 16:20:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        tstoyanov@vmware.com
Subject: Re: [PATCH v2 0/6] Add VM guest kernel tracing using vsock sockets
 for transport
Message-ID: <20190109162003.14c14dc6@gandalf.local.home>
In-Reply-To: <20190108150015.21327-1-kaslevs@vmware.com>
References: <20190108150015.21327-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


From: Steven Rostedt (VMware) <rostedt@goodmis.org>

BTW, can you add a patch like this too. Add my signed off by along with
yours. We need trace-cmd to continue to build with older kernels that
do not support vsocks. As I still have some boxes that don't and I use
to test on ;-)

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/Makefile b/Makefile
index 27d3683..01e3541 100644
--- a/Makefile
+++ b/Makefile
@@ -205,6 +205,13 @@ CFLAGS ?= -g -Wall
 CPPFLAGS ?=
 LDFLAGS ?=
 
+VSOCK_DEFINED := $(shell if (echo '\#include <linux/vm_socket.h>' | gcc -E - &> /dev/null) ; then echo 1; else echo 0 ; fi)
+
+export VSOCK_DEFINED
+ifeq ($(VSOCK_DEFINED), 1)
+CFLAGS += -DVSOCK
+endif
+
 export CFLAGS
 export INCLUDES
 
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 6f2e405..865b1c6 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -17,7 +17,6 @@ TRACE_CMD_OBJS += trace-record.o
 TRACE_CMD_OBJS += trace-read.o
 TRACE_CMD_OBJS += trace-split.o
 TRACE_CMD_OBJS += trace-listen.o
-TRACE_CMD_OBJS += trace-agent.o
 TRACE_CMD_OBJS += trace-stack.o
 TRACE_CMD_OBJS += trace-hist.o
 TRACE_CMD_OBJS += trace-mem.o
@@ -34,13 +33,17 @@ TRACE_CMD_OBJS += trace-output.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-msg.o
 
+ifeq ($(VSOCK_DEFINED), 1)
+TRACE_CMD_OBJS += trace-agent.o
+endif
+
 ALL_OBJS := $(TRACE_CMD_OBJS:%.o=$(bdir)/%.o)
 
 all_objs := $(sort $(ALL_OBJS))
 all_deps := $(all_objs:$(bdir)/%.o=$(bdir)/.%.d)
 
 CONFIG_INCLUDES =
-CONFIG_LIBS	=
+CONFIG_LIBS	= -lrt
 CONFIG_FLAGS	=
 
 all: $(TARGETS)
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 2d4fc1b..3ae5e2e 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -83,7 +83,9 @@ struct command commands[] = {
 	{"hist", trace_hist},
 	{"mem", trace_mem},
 	{"listen", trace_listen},
+#ifdef VSOCK
 	{"agent", trace_agent},
+#endif
 	{"split", trace_split},
 	{"restore", trace_restore},
 	{"stack", trace_stack},
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1573389..9d78ab0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -33,7 +33,10 @@
 #include <errno.h>
 #include <limits.h>
 #include <libgen.h>
+
+#ifdef VSOCK
 #include <linux/vm_sockets.h>
+#endif
 
 #include "trace-local.h"
 #include "trace-msg.h"
@@ -2658,6 +2661,7 @@ static int connect_port(const char *host, unsigned port)
 	return sfd;
 }
 
+#ifdef VSOCK
 static int open_vsock(unsigned cid, unsigned port)
 {
 	struct sockaddr_vm addr = {
@@ -2676,6 +2680,13 @@ static int open_vsock(unsigned cid, unsigned port)
 
 	return sd;
 }
+#else
+static inline int open_vsock(unsigned cid, unsigned port)
+{
+	die ("vsock is not supported");
+	return 0;
+}
+#endif
 
 static int do_accept(int sd)
 {
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index db8389d..93e85ba 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -237,6 +237,7 @@ static struct usage_help usage_help[] = {
 		"          -d directory to store client files.\n"
 		"          -l logfile to write messages to.\n"
 	},
+#ifdef VSOCK
 	{
 		"agent",
 		"listen on a vsock socket for trace clients",
@@ -245,6 +246,7 @@ static struct usage_help usage_help[] = {
 		"          -p port number to listen on.\n"
 		"          -D run in daemon mode.\n"
 	},
+#endif
 	{
 		"list",
 		"list the available events, plugins or options",
