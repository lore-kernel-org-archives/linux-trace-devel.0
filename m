Return-Path: <SRS0=K4HJ=PW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4836C43387
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jan 2019 22:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 938F720659
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jan 2019 22:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfANWqH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jan 2019 17:46:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:49722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbfANWqH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jan 2019 17:46:07 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13C50205F4;
        Mon, 14 Jan 2019 22:46:04 +0000 (UTC)
Date:   Mon, 14 Jan 2019 17:46:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        tstoyanov@vmware.com
Subject: Re: [PATCH v3 6/6] trace-cmd: Add VM kernel tracing over vsock
 sockets transport
Message-ID: <20190114174603.09287a2c@gandalf.local.home>
In-Reply-To: <20190114152800.31060-7-kaslevs@vmware.com>
References: <20190114152800.31060-1-kaslevs@vmware.com>
        <20190114152800.31060-7-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 14 Jan 2019 17:28:00 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:
\
> --- /dev/null
> +++ b/tracecmd/trace-agent.c
> @@ -0,0 +1,229 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2018 VMware Inc, Slavomir Kaslev <kaslevs@vmware.com>
> + *
> + * based on prior implementation by Yoshihiro Yunomae
> + * Copyright (C) 2013 Hitachi, Ltd.
> + * Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> + */
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <getopt.h>
> +#include <signal.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/ioctl.h>
> +#include <sys/socket.h>
> +#include <sys/wait.h>
> +#include <unistd.h>
> +#include <linux/vm_sockets.h>
> +
> +#include "trace-local.h"
> +#include "trace-msg.h"
> +
> +static int make_vsock(unsigned port)
> +{
> +	struct sockaddr_vm addr = {
> +		.svm_family = AF_VSOCK,
> +		.svm_cid = VMADDR_CID_ANY,
> +		.svm_port = port,
> +	};
> +	int sd;
> +
> +	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
> +	if (sd < 0)
> +		return -1;
> +
> +	setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &(int){1}, sizeof(int));
> +
> +	if (bind(sd, (struct sockaddr *)&addr, sizeof(addr)))
> +		return -1;
> +
> +	if (listen(sd, SOMAXCONN))
> +		return -1;
> +
> +	return sd;
> +}
> +
> +static int get_vsock_port(int sd)
> +{
> +	struct sockaddr_vm addr;
> +	socklen_t addr_len = sizeof(addr);
> +
> +	if (getsockname(sd, (struct sockaddr *)&addr, &addr_len))
> +		return -1;
> +
> +	if (addr.svm_family != AF_VSOCK)
> +		return -1;
> +
> +	return addr.svm_port;
> +}
> +
> +static void make_vsocks(int nr, int **fds, int **ports)
> +{
> +	int i, fd, port;
> +
> +	*fds = calloc(nr, sizeof(*fds));
> +	*ports = calloc(nr, sizeof(*ports));
> +	if (!*fds || !*ports)
> +		die("Failed to allocate memory");
> +
> +	for (i = 0; i < nr; i++) {
> +		fd = make_vsock(VMADDR_PORT_ANY);
> +		if (fd < 0)
> +			die("Failed to open vsock socket");
> +
> +		port = get_vsock_port(fd);
> +		if (port < 0)
> +			die("Failed to get vsock socket address");
> +
> +		(*fds)[i] = fd;
> +		(*ports)[i] = port;
> +	}
> +}
> +
> +static void free_vsocks(int nr, int *fds, int *ports)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr; i++)
> +		close(fds[i]);
> +	free(fds);
> +	free(ports);
> +}
> +
> +static void agent_handle(int sd, int nr_cpus, int page_size)
> +{
> +	struct tracecmd_msg_handle *msg_handle;
> +	int *fds, *ports;
> +	char **argv = NULL;
> +	int argc = 0;
> +
> +	msg_handle = tracecmd_msg_handle_alloc(sd, TRACECMD_MSG_FL_CLIENT);
> +	if (!msg_handle)
> +		die("Failed to allocate message handle");
> +
> +	if (tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv))
> +		die("Failed to receive trace request");
> +
> +	make_vsocks(nr_cpus, &fds, &ports);
> +
> +	if (tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size, ports))
> +		die("Failed to send trace response");
> +
> +	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv);
> +
> +	free_vsocks(nr_cpus, fds, ports);
> +	free(argv[0]);
> +	free(argv);
> +	tracecmd_msg_handle_close(msg_handle);
> +	exit(0);
> +}
> +
> +static volatile pid_t handler_pid;
> +
> +static void handle_sigchld(int sig)
> +{
> +	int wstatus;
> +	pid_t pid;
> +
> +	for (;;) {
> +		pid = waitpid(-1, &wstatus, WNOHANG);
> +		if (pid <= 0)
> +			break;
> +
> +		if (pid == handler_pid)
> +			handler_pid = 0;
> +	}
> +}
> +
> +static void agent_serve(unsigned port)
> +{
> +	int sd, cd, nr_cpus;
> +	pid_t pid;
> +
> +	signal(SIGCHLD, handle_sigchld);
> +
> +	nr_cpus = count_cpus();
> +	page_size = getpagesize();
> +
> +	sd = make_vsock(port);
> +	if (sd < 0)
> +		die("Failed to open vsock socket");
> +
> +	for (;;) {
> +		cd = accept(sd, NULL, NULL);
> +		if (cd < 0) {
> +			if (errno == EINTR)
> +				continue;
> +			die("accept");
> +		}
> +
> +		if (handler_pid)
> +			goto busy;
> +
> +		pid = fork();
> +		if (pid == 0) {
> +			close(sd);
> +			signal(SIGCHLD, SIG_DFL);
> +			agent_handle(cd, nr_cpus, page_size);
> +		}
> +		if (pid > 0)
> +			handler_pid = pid;
> +
> +	busy:
> +		close(cd);
> +	}
> +

Hmm, I don't see any break from the above for (;;) and that's an
infinite loop. That makes this dead code below.

> +	close(sd);
> +	signal(SIGCHLD, SIG_DFL);
> +}



> +
> +void trace_agent(int argc, char **argv)
> +{
> +	bool do_daemon = false;
> +	unsigned port = TRACE_AGENT_DEFAULT_PORT;
> +
> +	if (argc < 2)
> +		usage(argv);
> +
> +	if (strcmp(argv[1], "agent") != 0)
> +		usage(argv);
> +
> +	for (;;) {
> +		int c, option_index = 0;
> +		static struct option long_options[] = {
> +			{"port", required_argument, NULL, 'p'},
> +			{"help", no_argument, NULL, '?'},
> +			{NULL, 0, NULL, 0}
> +		};
> +
> +		c = getopt_long(argc-1, argv+1, "+hp:D",
> +				long_options, &option_index);
> +		if (c == -1)
> +			break;
> +		switch (c) {
> +		case 'h':
> +			usage(argv);
> +			break;
> +		case 'p':
> +			port = atoi(optarg);
> +			break;
> +		case 'D':
> +			do_daemon = true;
> +			break;
> +		default:
> +			usage(argv);
> +		}
> +	}
> +
> +	if ((argc - optind) >= 2)
> +		usage(argv);
> +
> +	if (do_daemon && daemon(1, 0))
> +		die("daemon");
> +
> +	agent_serve(port);
> +}
> diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
> index 797b303..3ae5e2e 100644
> --- a/tracecmd/trace-cmd.c
> +++ b/tracecmd/trace-cmd.c
> @@ -83,6 +83,9 @@ struct command commands[] = {
>  	{"hist", trace_hist},
>  	{"mem", trace_mem},
>  	{"listen", trace_listen},
> +#ifdef VSOCK
> +	{"agent", trace_agent},
> +#endif
>  	{"split", trace_split},
>  	{"restore", trace_restore},
>  	{"stack", trace_stack},
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 012371c..6c8754e 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -33,6 +33,9 @@
>  #include <errno.h>
>  #include <limits.h>
>  #include <libgen.h>
> +#ifdef VSOCK
> +#include <linux/vm_sockets.h>
> +#endif
>  
>  #include "trace-local.h"
>  #include "trace-msg.h"
> @@ -74,8 +77,6 @@ static int buffers;
>  static int clear_function_filters;
>  
>  static char *host;
> -static int *client_ports;
> -static int sfd;
>  
>  /* Max size to let a per cpu file get */
>  static int max_kb;
> @@ -171,6 +172,15 @@ static struct tracecmd_recorder *recorder;
>  
>  static int ignore_event_not_found = 0;
>  
> +static inline size_t grow_cap(size_t old_cap)
> +{
> +	size_t cap = 3 * old_cap / 2;
> +
> +	if (cap < 16)
> +		cap = 16;
> +	return cap;
> +}

I'm a bit confused by what the grow_cap() is for.

> +
>  static inline int is_top_instance(struct buffer_instance *instance)
>  {
>  	return instance == &top_instance;
> @@ -518,6 +528,36 @@ static char *get_temp_file(struct buffer_instance *instance, int cpu)
>  	return file;
>  }
>  
> +static char *get_guest_file(const char *file, const char *guest)
> +{
> +	size_t guest_len = strlen(guest);
> +	size_t file_len = strlen(file);
> +	size_t base_len, idx = 0;
> +	const char *p;
> +	char *out;
> +
> +	out = malloc(file_len + guest_len + 2 /* dash and \0 */);
> +	if (!out)
> +		return NULL;
> +
> +	p = strrchr(file, '.');
> +	if (p && p != file)
> +		base_len = p - file;
> +	else
> +		base_len = file_len;
> +
> +	memcpy(out, file, base_len);
> +	idx += base_len;
> +	out[idx++] = '-';
> +	memcpy(out + idx, guest, guest_len);
> +	idx += guest_len;
> +	memcpy(out + idx, p, file_len - base_len);
> +	idx += file_len - base_len;
> +	out[idx] = '\0';

Can't we pretty much replace this whole function with:

	p = strrchr(file, '.');
	if (p && p != file) {
		base_len = p - file;
	else
		base_len = strlen(file);

	asprintf(&out, "%.*s-%s%s", base_len, file, guest, file + base_len);

?


> +
> +	return out;
> +}
> +
>  static void put_temp_file(char *file)
>  {
>  	free(file);
> @@ -623,6 +663,16 @@ static void delete_thread_data(void)
>  	}
>  }
>  
> +static void tell_guests_to_stop(void)
> +{
> +	struct buffer_instance *instance;
> +
> +	for_all_instances(instance) {
> +		if (instance->flags & BUFFER_FL_GUEST)
> +			tracecmd_msg_handle_close(instance->msg_handle);
> +	}
> +}
> +
>  static void stop_threads(enum trace_type type)
>  {
>  	struct timeval tv = { 0, 0 };
> @@ -632,6 +682,8 @@ static void stop_threads(enum trace_type type)
>  	if (!recorder_threads)
>  		return;
>  
> +	tell_guests_to_stop();
> +
>  	/* Tell all threads to finish up */
>  	for (i = 0; i < recorder_threads; i++) {
>  		if (pids[i].pid > 0) {
> @@ -2571,14 +2623,14 @@ static void flush(int sig)
>  		tracecmd_stop_recording(recorder);
>  }
>  
> -static void connect_port(int cpu)
> +static int connect_port(const char *host, unsigned port)
>  {
>  	struct addrinfo hints;
>  	struct addrinfo *results, *rp;
> -	int s;
> +	int s, sfd;
>  	char buf[BUFSIZ];
>  
> -	snprintf(buf, BUFSIZ, "%d", client_ports[cpu]);
> +	snprintf(buf, BUFSIZ, "%d", port);
>  
>  	memset(&hints, 0, sizeof(hints));
>  	hints.ai_family = AF_UNSPEC;
> @@ -2605,7 +2657,190 @@ static void connect_port(int cpu)
>  
>  	freeaddrinfo(results);
>  
> -	client_ports[cpu] = sfd;
> +	return sfd;
> +}
> +
> +#ifdef VSOCK
> +static int open_vsock(unsigned cid, unsigned port)
> +{
> +	struct sockaddr_vm addr = {
> +		.svm_family = AF_VSOCK,
> +		.svm_cid = cid,
> +		.svm_port = port,
> +	};
> +	int sd;
> +
> +	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
> +	if (sd < 0)
> +		return -1;
> +
> +	if (connect(sd, (struct sockaddr *)&addr, sizeof(addr)))
> +		return -1;
> +
> +	return sd;
> +}
> +#else
> +static inline int open_vsock(unsigned cid, unsigned port)
> +{
> +	die("vsock is not supported");
> +	return -1;
> +}
> +#endif
> +
> +static int do_accept(int sd)
> +{
> +	int cd;
> +
> +	for (;;) {
> +		cd = accept(sd, NULL, NULL);
> +		if (cd < 0) {
> +			if (errno == EINTR)
> +				continue;
> +			die("accept");
> +		}
> +
> +		return cd;
> +	}
> +
> +	return -1;
> +}
> +
> +static bool is_digits(const char *s)
> +{
> +	const char *p;
> +
> +	for (p = s; *p; p++)
> +		if (!isdigit(*p))
> +			return false;
> +
> +	return true;
> +}
> +
> +struct guest {
> +	char *name;
> +	int cid;
> +	int pid;
> +};
> +
> +static size_t guests_cap, guests_len;
> +static struct guest *guests;
> +
> +static char *get_qemu_guest_name(char *arg)
> +{
> +	char *tok, *end = arg;
> +
> +	while ((tok = strsep(&end, ","))) {
> +		if (strncmp(tok, "guest=", 6) == 0)
> +			return tok + 6;
> +	}
> +
> +	return arg;
> +}
> +
> +static void read_qemu_guests(void)
> +{
> +	static bool initialized = false;
> +	struct dirent *entry;
> +	char path[PATH_MAX];
> +	DIR *dir;
> +
> +	if (initialized)
> +		return;
> +
> +	initialized = true;
> +	dir = opendir("/proc");
> +	if (!dir)
> +		die("opendir");
> +
> +	for (entry = readdir(dir); entry; entry = readdir(dir)) {
> +		bool is_qemu = false, last_was_name = false;
> +		struct guest guest = {};
> +		char *p, *arg = NULL;
> +		size_t arg_size = 0;
> +		FILE *f;
> +
> +		if (!(entry->d_type == DT_DIR && is_digits(entry->d_name)))
> +			continue;
> +
> +		guest.pid = atoi(entry->d_name);
> +		snprintf(path, sizeof(path), "/proc/%s/cmdline", entry->d_name);
> +		f = fopen(path, "r");
> +		if (!f)
> +			continue;
> +
> +		while (getdelim(&arg, &arg_size, 0, f) != -1) {
> +			if (!is_qemu && strstr(arg, "qemu-system-")) {
> +				is_qemu = true;
> +				continue;
> +			}
> +
> +			if (!is_qemu)
> +				continue;
> +
> +			if (strcmp(arg, "-name") == 0) {
> +				last_was_name = true;
> +				continue;
> +			}
> +
> +			if (last_was_name) {
> +				guest.name = strdup(get_qemu_guest_name(arg));
> +				last_was_name = false;
> +				continue;
> +			}
> +
> +			p = strstr(arg, "guest-cid=");
> +			if (p) {
> +				guest.cid = atoi(p + 10);
> +				continue;
> +			}
> +		}
> +
> +		if (is_qemu) {
> +			if (guests_cap == guests_len) {
> +				guests_cap = grow_cap(guests_cap);

This isn't a fast path is it? I'm not sure why we are using
guests_cap() here. Note, realloc allocs more than required and is
pretty much a nop if the allocated amount is still within its
allocation that it made the first time.

-- Steve


> +				guests = realloc(guests,
> +						 guests_cap * sizeof(*guests));
> +			}
> +			guests[guests_len++] = guest;
> +		}
> +
> +		free(arg);
> +		fclose(f);
> +	}
> +
> +	closedir(dir);
> +}
> +
> 
