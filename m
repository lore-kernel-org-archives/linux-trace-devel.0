Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751134AbeACRxk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:40 -0500
Message-Id: <20180103175338.698370365@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 27/38] trace-cmd msg: Create a msg_handle to pass around for saved state
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0027-trace-cmd-msg-Create-a-msg_handle-to-pass-around-for.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of just passing around a file descriptor, create a msg_handle
descriptor that can save state of the msg connection. This will be used to
localize more variables as well as to add new features.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-cmd.h    | 46 ++++++++++++++++++++++-----
 trace-listen.c | 52 +++++++++++++++++++++++--------
 trace-msg.c    | 32 +++++++++++--------
 trace-output.c | 29 ++++++++++-------
 trace-record.c | 98 +++++++++++++++++++++++++++++++++++-----------------------
 5 files changed, 174 insertions(+), 83 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index 7e182779e78b..0fce54baea5b 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -231,6 +231,7 @@ struct tracecmd_event_list {
 };
 
 struct tracecmd_option;
+struct tracecmd_msg_handle;
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *tracecmd_create_file(const char *output_file,
@@ -244,7 +245,10 @@ tracecmd_create_init_file_glob(const char *output_file,
 			       struct tracecmd_event_list *list);
 struct tracecmd_output *tracecmd_create_init_fd(int fd);
 struct tracecmd_output *
-tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list, bool send_meta);
+tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list);
+struct tracecmd_output *
+tracecmd_create_init_fd_msg(struct tracecmd_msg_handle *msg_handle,
+			    struct tracecmd_event_list *list);
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file);
 struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
 							   const char *tracing_dir,
@@ -296,16 +300,42 @@ void tracecmd_disable_all_tracing(int disable_tracer);
 void tracecmd_disable_tracing(void);
 void tracecmd_enable_tracing(void);
 
+enum tracecmd_msg_bits {
+	TRACECMD_MSG_BIT_CLIENT		= 0,
+	TRACECMD_MSG_BIT_SERVER		= 1,
+};
+
+enum tracecmd_msg_flags {
+	TRACECMD_MSG_FL_CLIENT		= (1 << TRACECMD_MSG_BIT_CLIENT),
+	TRACECMD_MSG_FL_SERVER		= (1 << TRACECMD_MSG_BIT_SERVER),
+};
+
+/* for both client and server */
+struct tracecmd_msg_handle {
+	unsigned long		flags;
+	int			fd;
+};
+
+struct tracecmd_msg_handle *
+  tracecmd_msg_handle_alloc(int fd, unsigned long flags);
+
+/* Closes the socket and frees the handle */
+void tracecmd_msg_handle_close(struct tracecmd_msg_handle *msg_handle);
+
 /* for clients */
-int tracecmd_msg_send_init_data(int fd, int total_cpus, int **client_ports);
-int tracecmd_msg_metadata_send(int fd, const char *buf, int size);
-int tracecmd_msg_finish_sending_metadata(int fd);
-void tracecmd_msg_send_close_msg(int fd);
+int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
+				int total_cpus, int **client_ports);
+int tracecmd_msg_metadata_send(struct tracecmd_msg_handle *msg_handle,
+			       const char *buf, int size);
+int tracecmd_msg_finish_sending_metadata(struct tracecmd_msg_handle *msg_handle);
+void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
 
 /* for server */
-int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize);
-int tracecmd_msg_send_port_array(int fd, int total_cpus, int *ports);
-int tracecmd_msg_collect_metadata(int ifd, int ofd);
+int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle,
+				 int *cpus, int *pagesize);
+int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
+				 int total_cpus, int *ports);
+int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int ofd);
 
 /* --- Plugin handling --- */
 extern struct pevent_plugin_option trace_ftrace_options[];
diff --git a/trace-listen.c b/trace-listen.c
index cfb0f146244d..d5379b36a85e 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -118,6 +118,26 @@ static int process_option(char *option)
 	return 0;
 }
 
+struct tracecmd_msg_handle *
+tracecmd_msg_handle_alloc(int fd, unsigned long flags)
+{
+	struct tracecmd_msg_handle *handle;
+
+	handle = calloc(1, sizeof(struct tracecmd_msg_handle));
+	if (!handle)
+		return NULL;
+
+	handle->fd = fd;
+	handle->flags = flags;
+	return handle;
+}
+
+void tracecmd_msg_handle_close(struct tracecmd_msg_handle *msg_handle)
+{
+	close(msg_handle->fd);
+	free(msg_handle);
+}
+
 static void finish(int sig)
 {
 	done = true;
@@ -348,7 +368,8 @@ static int open_udp(const char *node, const char *port, int *pid,
 	return num_port;
 }
 
-static int communicate_with_client(int fd, int *cpus, int *pagesize)
+static int communicate_with_client(struct tracecmd_msg_handle *msg_handle,
+				   int *cpus, int *pagesize)
 {
 	char *last_proto = NULL;
 	char buf[BUFSIZ];
@@ -357,6 +378,7 @@ static int communicate_with_client(int fd, int *cpus, int *pagesize)
 	int size;
 	int n, s, t, i;
 	int ret = -EINVAL;
+	int fd = msg_handle->fd;
 
 	/* Let the client know what we are */
 	write(fd, "tracecmd", 8);
@@ -411,7 +433,7 @@ static int communicate_with_client(int fd, int *cpus, int *pagesize)
 		proto_ver = V2_PROTOCOL;
 
 		/* read the CPU count, the page size, and options */
-		if (tracecmd_msg_initial_setting(fd, cpus, pagesize) < 0)
+		if (tracecmd_msg_initial_setting(msg_handle, cpus, pagesize) < 0)
 			goto out;
 	} else {
 		/* The client is using the v1 protocol */
@@ -517,7 +539,7 @@ static void destroy_all_readers(int cpus, int *pid_array, const char *node,
 }
 
 static int *create_all_readers(int cpus, const char *node, const char *port,
-			       int pagesize, int fd)
+			       int pagesize, struct tracecmd_msg_handle *msg_handle)
 {
 	char buf[BUFSIZ];
 	int *port_array;
@@ -558,7 +580,7 @@ static int *create_all_readers(int cpus, const char *node, const char *port,
 
 	if (proto_ver == V2_PROTOCOL) {
 		/* send set of port numbers to the client */
-		if (tracecmd_msg_send_port_array(fd, cpus, port_array) < 0) {
+		if (tracecmd_msg_send_port_array(msg_handle, cpus, port_array) < 0) {
 			plog("Failed sending port array\n");
 			goto out_free;
 		}
@@ -567,10 +589,10 @@ static int *create_all_readers(int cpus, const char *node, const char *port,
 		for (cpu = 0; cpu < cpus; cpu++) {
 			snprintf(buf, BUFSIZ, "%s%d",
 				 cpu ? "," : "", port_array[cpu]);
-			write(fd, buf, strlen(buf));
+			write(msg_handle->fd, buf, strlen(buf));
 		}
 		/* end with null terminator */
-		write(fd, "\0", 1);
+		write(msg_handle->fd, "\0", 1);
 	}
 
 	return pid_array;
@@ -645,7 +667,8 @@ static int put_together_file(int cpus, int ofd, const char *node,
 	return ret;
 }
 
-static int process_client(const char *node, const char *port, int fd)
+static int process_client(struct tracecmd_msg_handle *msg_handle,
+			  const char *node, const char *port)
 {
 	int *pid_array;
 	int pagesize;
@@ -653,21 +676,21 @@ static int process_client(const char *node, const char *port, int fd)
 	int ofd;
 	int ret;
 
-	ret = communicate_with_client(fd, &cpus, &pagesize);
+	ret = communicate_with_client(msg_handle, &cpus, &pagesize);
 	if (ret < 0)
 		return ret;
 
 	ofd = create_client_file(node, port);
 
-	pid_array = create_all_readers(cpus, node, port, pagesize, fd);
+	pid_array = create_all_readers(cpus, node, port, pagesize, msg_handle);
 	if (!pid_array)
 		return -ENOMEM;
 
 	/* Now we are ready to start reading data from the client */
 	if (proto_ver == V2_PROTOCOL)
-		tracecmd_msg_collect_metadata(fd, ofd);
+		tracecmd_msg_collect_metadata(msg_handle, ofd);
 	else
-		collect_metadata_from_client(fd, ofd);
+		collect_metadata_from_client(msg_handle->fd, ofd);
 
 	/* wait a little to let our readers finish reading */
 	sleep(1);
@@ -712,6 +735,7 @@ static int do_fork(int cfd)
 static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
 			  socklen_t peer_addr_len)
 {
+	struct tracecmd_msg_handle *msg_handle;
 	char host[NI_MAXHOST], service[NI_MAXSERV];
 	int s;
 	int ret;
@@ -720,6 +744,8 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
 	if (ret)
 		return ret;
 
+	msg_handle = tracecmd_msg_handle_alloc(cfd, TRACECMD_MSG_FL_SERVER);
+
 	s = getnameinfo((struct sockaddr *)peer_addr, peer_addr_len,
 			host, NI_MAXHOST,
 			service, NI_MAXSERV, NI_NUMERICSERV);
@@ -734,9 +760,9 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
 		return -1;
 	}
 
-	process_client(host, service, cfd);
+	process_client(msg_handle, host, service);
 
-	close(cfd);
+	tracecmd_msg_handle_close(msg_handle);
 
 	if (!debug)
 		exit(0);
diff --git a/trace-msg.c b/trace-msg.c
index aaeec06b82e3..7c93ff3b3ff3 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -395,10 +395,12 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
 	return 0;
 }
 
-int tracecmd_msg_send_init_data(int fd, int total_cpus, int **client_ports)
+int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
+				int total_cpus, int **client_ports)
 {
 	struct tracecmd_msg send_msg;
 	struct tracecmd_msg recv_msg;
+	int fd = msg_handle->fd;
 	int *ports;
 	int i, cpus;
 	int ret;
@@ -452,7 +454,8 @@ static void error_operation_for_server(struct tracecmd_msg *msg)
 
 #define MAX_OPTION_SIZE 4096
 
-int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize)
+int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle,
+				 int *cpus, int *pagesize)
 {
 	struct tracecmd_msg_opt *opt;
 	struct tracecmd_msg msg;
@@ -462,7 +465,7 @@ int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize)
 	u32 size = MIN_TINIT_SIZE;
 	u32 cmd;
 
-	ret = tracecmd_msg_recv_wait(fd, &msg);
+	ret = tracecmd_msg_recv_wait(msg_handle->fd, &msg);
 	if (ret < 0) {
 		if (ret == -ETIMEDOUT)
 			warning("Connection timed out\n");
@@ -527,7 +530,8 @@ error:
 	return ret;
 }
 
-int tracecmd_msg_send_port_array(int fd, int total_cpus, int *ports)
+int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
+				 int total_cpus, int *ports)
 {
 	struct tracecmd_msg msg;
 	int ret;
@@ -537,24 +541,26 @@ int tracecmd_msg_send_port_array(int fd, int total_cpus, int *ports)
 	if (ret < 0)
 		return ret;
 
-	ret = tracecmd_msg_send(fd, &msg);
+	ret = tracecmd_msg_send(msg_handle->fd, &msg);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-void tracecmd_msg_send_close_msg(int fd)
+void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle)
 {
 	struct tracecmd_msg msg;
 
 	tracecmd_msg_init(MSG_CLOSE, &msg);
-	tracecmd_msg_send(fd, &msg);
+	tracecmd_msg_send(msg_handle->fd, &msg);
 }
 
-int tracecmd_msg_metadata_send(int fd, const char *buf, int size)
+int tracecmd_msg_metadata_send(struct tracecmd_msg_handle *msg_handle,
+			       const char *buf, int size)
 {
 	struct tracecmd_msg msg;
+	int fd = msg_handle->fd;
 	int n;
 	int ret;
 	int count = 0;
@@ -589,19 +595,19 @@ int tracecmd_msg_metadata_send(int fd, const char *buf, int size)
 	return ret;
 }
 
-int tracecmd_msg_finish_sending_metadata(int fd)
+int tracecmd_msg_finish_sending_metadata(struct tracecmd_msg_handle *msg_handle)
 {
 	struct tracecmd_msg msg;
 	int ret;
 
 	tracecmd_msg_init(MSG_FINMETA, &msg);
-	ret = tracecmd_msg_send(fd, &msg);
+	ret = tracecmd_msg_send(msg_handle->fd, &msg);
 	if (ret < 0)
 		return ret;
 	return 0;
 }
 
-int tracecmd_msg_collect_metadata(int ifd, int ofd)
+int tracecmd_msg_collect_metadata(struct tracecmd_msg_handle *msg_handle, int ofd)
 {
 	struct tracecmd_msg msg;
 	u32 t, n, cmd;
@@ -609,7 +615,7 @@ int tracecmd_msg_collect_metadata(int ifd, int ofd)
 	int ret;
 
 	do {
-		ret = tracecmd_msg_recv_wait(ifd, &msg);
+		ret = tracecmd_msg_recv_wait(msg_handle->fd, &msg);
 		if (ret < 0) {
 			if (ret == -ETIMEDOUT)
 				warning("Connection timed out\n");
@@ -643,7 +649,7 @@ int tracecmd_msg_collect_metadata(int ifd, int ofd)
 
 	/* check the finish message of the client */
 	while (!done) {
-		ret = tracecmd_msg_recv(ifd, &msg);
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
 		if (ret < 0) {
 			warning("reading client");
 			return ret;
diff --git a/trace-output.c b/trace-output.c
index d04c4019640f..cbacd5426963 100644
--- a/trace-output.c
+++ b/trace-output.c
@@ -65,12 +65,12 @@ struct tracecmd_output {
 	int		fd;
 	int		page_size;
 	int		cpus;
-	int		flags;
 	struct pevent	*pevent;
 	char		*tracing_dir;
 	int		options_written;
 	int		nr_options;
 	struct list_head options;
+	struct tracecmd_msg_handle *msg_handle;
 };
 
 struct list_event {
@@ -88,8 +88,8 @@ struct list_event_system {
 static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 {
-	if (handle->flags & OUTPUT_FL_SEND_META)
-		return tracecmd_msg_metadata_send(handle->fd, data, size);
+	if (handle->msg_handle)
+		return tracecmd_msg_metadata_send(handle->msg_handle, data, size);
 
 	return __do_write_check(handle->fd, data, size);
 }
@@ -782,7 +782,8 @@ static struct tracecmd_output *
 create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *tracing_dir,
 	       const char *kallsyms,
-	       struct tracecmd_event_list *list, bool send_meta)
+	       struct tracecmd_event_list *list,
+	       struct tracecmd_msg_handle *msg_handle)
 {
 	struct tracecmd_output *handle;
 	struct pevent *pevent;
@@ -794,9 +795,6 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 		return NULL;
 	memset(handle, 0, sizeof(*handle));
 
-	if (send_meta)
-		handle->flags |= OUTPUT_FL_SEND_META;
-
 	handle->fd = fd;
 	if (tracing_dir) {
 		handle->tracing_dir = strdup(tracing_dir);
@@ -804,6 +802,8 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 			goto out_free;
 	}
 
+	handle->msg_handle = msg_handle;
+
 	list_head_init(&handle->options);
 
 	buf[0] = 23;
@@ -888,7 +888,7 @@ static struct tracecmd_output *create_file(const char *output_file,
 	if (fd < 0)
 		return NULL;
 
-	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, false);
+	handle = create_file_fd(fd, ihandle, tracing_dir, kallsyms, list, NULL);
 	if (!handle) {
 		close(fd);
 		unlink(output_file);
@@ -1318,13 +1318,20 @@ struct tracecmd_output *tracecmd_create_file(const char *output_file,
 
 struct tracecmd_output *tracecmd_create_init_fd(int fd)
 {
-	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, false);
+	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, NULL);
+}
+
+struct tracecmd_output *
+tracecmd_create_init_fd_msg(struct tracecmd_msg_handle *msg_handle,
+			    struct tracecmd_event_list *list)
+{
+	return create_file_fd(msg_handle->fd, NULL, NULL, NULL, list, msg_handle);
 }
 
 struct tracecmd_output *
-tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list, bool send_meta)
+tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list)
 {
-	return create_file_fd(fd, NULL, NULL, NULL, list, send_meta);
+	return create_file_fd(fd, NULL, NULL, NULL, list, NULL);
 }
 
 struct tracecmd_output *
diff --git a/trace-record.c b/trace-record.c
index e9e2976f1a94..3decb57a9a6c 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -90,7 +90,6 @@ static int clear_function_filters;
 static char *host;
 static int *client_ports;
 static int sfd;
-static int psfd;
 static struct tracecmd_output *network_handle;
 
 /* Max size to let a per cpu file get */
@@ -2680,36 +2679,36 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 	exit(0);
 }
 
-static void check_first_msg_from_server(int fd)
+static void check_first_msg_from_server(struct tracecmd_msg_handle *msg_handle)
 {
 	char buf[BUFSIZ];
 
-	read(fd, buf, 8);
+	read(msg_handle->fd, buf, 8);
 
 	/* Make sure the server is the tracecmd server */
 	if (memcmp(buf, "tracecmd", 8) != 0)
 		die("server not tracecmd server");
 }
 
-static void communicate_with_listener_v1(int fd)
+static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 {
 	char buf[BUFSIZ];
 	ssize_t n;
 	int cpu, i;
 
-	check_first_msg_from_server(fd);
+	check_first_msg_from_server(msg_handle);
 
 	/* write the number of CPUs we have (in ASCII) */
 	sprintf(buf, "%d", cpu_count);
 
 	/* include \0 */
-	write(fd, buf, strlen(buf)+1);
+	write(msg_handle->fd, buf, strlen(buf)+1);
 
 	/* write the pagesize (in ASCII) */
 	sprintf(buf, "%d", page_size);
 
 	/* include \0 */
-	write(fd, buf, strlen(buf)+1);
+	write(msg_handle->fd, buf, strlen(buf)+1);
 
 	/*
 	 * If we are using IPV4 and our page size is greater than
@@ -2724,14 +2723,14 @@ static void communicate_with_listener_v1(int fd)
 
 	if (use_tcp) {
 		/* Send one option */
-		write(fd, "1", 2);
+		write(msg_handle->fd, "1", 2);
 		/* Size 4 */
-		write(fd, "4", 2);
+		write(msg_handle->fd, "4", 2);
 		/* use TCP */
-		write(fd, "TCP", 4);
+		write(msg_handle->fd, "TCP", 4);
 	} else
 		/* No options */
-		write(fd, "0", 2);
+		write(msg_handle->fd, "0", 2);
 
 	client_ports = malloc(sizeof(int) * cpu_count);
 	if (!client_ports)
@@ -2743,7 +2742,7 @@ static void communicate_with_listener_v1(int fd)
 	 */
 	for (cpu = 0; cpu < cpu_count; cpu++) {
 		for (i = 0; i < BUFSIZ; i++) {
-			n = read(fd, buf+i, 1);
+			n = read(msg_handle->fd, buf+i, 1);
 			if (n != 1)
 				die("Error, reading server ports");
 			if (!buf[i] || buf[i] == ',')
@@ -2756,18 +2755,19 @@ static void communicate_with_listener_v1(int fd)
 	}
 }
 
-static void communicate_with_listener_v2(int fd)
+static void communicate_with_listener_v2(struct tracecmd_msg_handle *msg_handle)
 {
-	if (tracecmd_msg_send_init_data(fd, cpu_count, &client_ports) < 0)
+	if (tracecmd_msg_send_init_data(msg_handle, cpu_count, &client_ports) < 0)
 		die("Cannot communicate with server");
 }
 
-static void check_protocol_version(int fd)
+static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 {
 	char buf[BUFSIZ];
+	int fd = msg_handle->fd;
 	int n;
 
-	check_first_msg_from_server(fd);
+	check_first_msg_from_server(msg_handle);
 
 	/*
 	 * Write the protocol version, the magic number, and the dummy
@@ -2806,8 +2806,9 @@ static void check_protocol_version(int fd)
 	}
 }
 
-static void setup_network(void)
+static struct tracecmd_msg_handle *setup_network(void)
 {
+	struct tracecmd_msg_handle *msg_handle;
 	struct addrinfo hints;
 	struct addrinfo *result, *rp;
 	int sfd, s;
@@ -2854,48 +2855,65 @@ again:
 
 	freeaddrinfo(result);
 
+	msg_handle = tracecmd_msg_handle_alloc(sfd, TRACECMD_MSG_FL_CLIENT);
+	if (!msg_handle)
+		die("Failed to allocate message handle");
+
 	if (proto_ver == V2_PROTOCOL) {
-		check_protocol_version(sfd);
+		check_protocol_version(msg_handle);
 		if (proto_ver == V1_PROTOCOL) {
 			/* reconnect to the server for using the v1 protocol */
 			close(sfd);
 			goto again;
 		}
-		communicate_with_listener_v2(sfd);
+		communicate_with_listener_v2(msg_handle);
 	}
 
 	if (proto_ver == V1_PROTOCOL)
-		communicate_with_listener_v1(sfd);
+		communicate_with_listener_v1(msg_handle);
 
-	/* Now create the handle through this socket */
-	network_handle = tracecmd_create_init_fd_glob(sfd, listed_events,
-						      proto_ver == V2_PROTOCOL);
+	return msg_handle;
+}
 
+static struct tracecmd_msg_handle *setup_connection(void)
+{
+	struct tracecmd_msg_handle *msg_handle;
+
+	msg_handle = setup_network();
+
+	/* Now create the handle through this socket */
 	if (proto_ver == V2_PROTOCOL) {
-		psfd = sfd; /* used for closing */
-		tracecmd_msg_finish_sending_metadata(sfd);
-	}
+		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
+		tracecmd_msg_finish_sending_metadata(msg_handle);
+	} else
+		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
+							      listed_events);
 
 	/* OK, we are all set, let'r rip! */
+	return msg_handle;
 }
 
-static void finish_network(void)
+static void finish_network(struct tracecmd_msg_handle *msg_handle)
 {
 	if (proto_ver == V2_PROTOCOL)
-		tracecmd_msg_send_close_msg(psfd);
-	close(sfd);
+		tracecmd_msg_send_close_msg(msg_handle);
+	tracecmd_msg_handle_close(msg_handle);
 	free(host);
 }
 
-static void start_threads(enum trace_type type, int global)
+static struct tracecmd_msg_handle *start_threads(enum trace_type type, int global)
 {
+	struct tracecmd_msg_handle *msg_handle = NULL;
 	struct buffer_instance *instance;
 	int *brass = NULL;
 	int i = 0;
 	int ret;
 
-	if (host)
-		setup_network();
+	if (host) {
+		msg_handle = setup_connection();
+		if (!msg_handle)
+			die("Failed to make connection");
+	}
 
 	/* make a thread for every CPU we have */
 	pids = malloc(sizeof(*pids) * cpu_count * (buffers + 1));
@@ -2932,6 +2950,8 @@ static void start_threads(enum trace_type type, int global)
 		}
 	}
 	recorder_threads = i;
+
+	return msg_handle;
 }
 
 static void append_buffer(struct tracecmd_output *handle,
@@ -3031,7 +3051,8 @@ enum {
 	DATA_FL_OFFSET		= 2,
 };
 
-static void record_data(char *date2ts, int flags)
+static void record_data(struct tracecmd_msg_handle *msg_handle,
+			char *date2ts, int flags)
 {
 	struct tracecmd_option **buffer_options;
 	struct tracecmd_output *handle;
@@ -3039,8 +3060,8 @@ static void record_data(char *date2ts, int flags)
 	char **temp_files;
 	int i;
 
-	if (host) {
-		finish_network();
+	if (msg_handle) {
+		finish_network(msg_handle);
 		return;
 	}
 
@@ -4823,6 +4844,7 @@ static void record_trace(int argc, char **argv,
 			 struct common_record_context *ctx)
 {
 	enum trace_type type = get_trace_cmd_type(ctx->curr_cmd);
+	struct tracecmd_msg_handle *msg_handle = NULL;
 	struct buffer_instance *instance;
 
 	/*
@@ -4895,7 +4917,7 @@ static void record_trace(int argc, char **argv,
 	if (type & (TRACE_TYPE_RECORD | TRACE_TYPE_STREAM)) {
 		signal(SIGINT, finish);
 		if (!latency)
-			start_threads(type, ctx->global);
+			msg_handle = start_threads(type, ctx->global);
 	} else {
 		update_task_filter();
 		tracecmd_enable_tracing();
@@ -4926,7 +4948,7 @@ static void record_trace(int argc, char **argv,
 		tracecmd_disable_all_tracing(0);
 
 	if (IS_RECORD(ctx)) {
-		record_data(ctx->date2ts, ctx->data_flags);
+		record_data(msg_handle, ctx->date2ts, ctx->data_flags);
 		delete_thread_data();
 	} else
 		print_stats();
@@ -5006,7 +5028,7 @@ void trace_extract(int argc, char **argv)
 		ctx.date2ts = get_date_to_ts();
 	}
 
-	record_data(ctx.date2ts, ctx.data_flags);
+	record_data(NULL, ctx.date2ts, ctx.data_flags);
 	delete_thread_data();
 	destroy_stats();
 	finalize_record_trace(&ctx);
-- 
2.13.2
