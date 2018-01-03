Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbeACRxj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:39 -0500
Message-Id: <20180103175337.688999474@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 20/38] trace-cmd: Make send_metadata a flag in the output handle
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0020-trace-cmd-Make-send_metadata-a-flag-in-the-output-ha.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of having a global variable called "send_metadata", have the network
setup pass in a flag to enabled sending the meta data via messages instead
of just writing to the file descriptor.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-cmd.h    |  2 +-
 trace-msg.c    |  4 ----
 trace-msg.h    |  1 -
 trace-output.c | 20 ++++++++++++++------
 trace-record.c |  3 ++-
 5 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index 6fd34d7fbd21..37177a6b6c3e 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -244,7 +244,7 @@ tracecmd_create_init_file_glob(const char *output_file,
 			       struct tracecmd_event_list *list);
 struct tracecmd_output *tracecmd_create_init_fd(int fd);
 struct tracecmd_output *
-tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list);
+tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list, bool send_meta);
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file);
 struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
 							   const char *tracing_dir,
diff --git a/trace-msg.c b/trace-msg.c
index 453901981c90..ab64f3f28f5e 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -70,7 +70,6 @@ int cpu_count;
 static int psfd;
 unsigned int page_size;
 int *client_ports;
-bool send_metadata;
 
 /* for server */
 static int *port_array;
@@ -398,9 +397,6 @@ int tracecmd_msg_send_init_data(int fd)
 	for (i = 0; i < cpus; i++)
 		client_ports[i] = ntohl(recv_msg.port_array[i]);
 
-	/* Next, send meta data */
-	send_metadata = true;
-
 	return 0;
 }
 
diff --git a/trace-msg.h b/trace-msg.h
index 0cc972cadc55..feae24ff4fd6 100644
--- a/trace-msg.h
+++ b/trace-msg.h
@@ -17,7 +17,6 @@ extern int cpu_count;
 /* for client */
 extern unsigned int page_size;
 extern int *client_ports;
-extern bool send_metadata;
 
 /* for server */
 extern bool done;
diff --git a/trace-output.c b/trace-output.c
index 9d7707f7ba79..d04c4019640f 100644
--- a/trace-output.c
+++ b/trace-output.c
@@ -57,10 +57,15 @@ struct tracecmd_option {
 	struct list_head list;
 };
 
+enum {
+	OUTPUT_FL_SEND_META	= (1 << 0),
+};
+
 struct tracecmd_output {
 	int		fd;
 	int		page_size;
 	int		cpus;
+	int		flags;
 	struct pevent	*pevent;
 	char		*tracing_dir;
 	int		options_written;
@@ -83,7 +88,7 @@ struct list_event_system {
 static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 {
-	if (send_metadata)
+	if (handle->flags & OUTPUT_FL_SEND_META)
 		return tracecmd_msg_metadata_send(handle->fd, data, size);
 
 	return __do_write_check(handle->fd, data, size);
@@ -777,7 +782,7 @@ static struct tracecmd_output *
 create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *tracing_dir,
 	       const char *kallsyms,
-	       struct tracecmd_event_list *list)
+	       struct tracecmd_event_list *list, bool send_meta)
 {
 	struct tracecmd_output *handle;
 	struct pevent *pevent;
@@ -789,6 +794,9 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 		return NULL;
 	memset(handle, 0, sizeof(*handle));
 
+	if (send_meta)
+		handle->flags |= OUTPUT_FL_SEND_META;
+
 	handle->fd = fd;
 	if (tracing_dir) {
 		handle->tracing_dir = strdup(tracing_dir);
@@ -880,7 +888,7 @@ static struct tracecmd_output *create_file(const char *output_file,
 	if (fd < 0)
 		return NULL;
 
-	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list);
+	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, false);
 	if (!handle) {
 		close(fd);
 		unlink(output_file);
@@ -1310,13 +1318,13 @@ struct tracecmd_output *tracecmd_create_file(const char *output_file,
 
 struct tracecmd_output *tracecmd_create_init_fd(int fd)
 {
-	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list);
+	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, false);
 }
 
 struct tracecmd_output *
-tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list)
+tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list, bool send_meta)
 {
-	return create_file_fd(fd, NULL, NULL, NULL, list);
+	return create_file_fd(fd, NULL, NULL, NULL, list, send_meta);
 }
 
 struct tracecmd_output *
diff --git a/trace-record.c b/trace-record.c
index 5088f7ae0852..48640af8acac 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -2865,7 +2865,8 @@ again:
 		communicate_with_listener_v1(sfd);
 
 	/* Now create the handle through this socket */
-	network_handle = tracecmd_create_init_fd_glob(sfd, listed_events);
+	network_handle = tracecmd_create_init_fd_glob(sfd, listed_events,
+						      proto_ver == V2_PROTOCOL);
 
 	if (proto_ver == V2_PROTOCOL)
 		tracecmd_msg_finish_sending_metadata(sfd);
-- 
2.13.2
