Return-Path: <SRS0=WSgK=RP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F08C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 23:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55FE22173C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 23:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfCLXH6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbfCLXH5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 19:07:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D22E6213A2;
        Tue, 12 Mar 2019 23:07:56 +0000 (UTC)
Date:   Tue, 12 Mar 2019 19:07:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v8 07/13] trace-cmd: Add VM kernel tracing over
 vsockets transport
Message-ID: <20190312190755.15e7f603@gandalf.local.home>
In-Reply-To: <20190222180539.27439-8-kaslevs@vmware.com>
References: <20190222180539.27439-1-kaslevs@vmware.com>
        <20190222180539.27439-8-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Feb 2019 20:05:33 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> +static void agent_serve(unsigned int port)
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
> +		die("Failed to open vsocket");
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

Also, for debugging purposes, I add a --debug option that prevents
forking, and the process is handled directly. The patch below is sorta
the idea.

This way we can run both the agent and host under gdb and step through
the communication, without having to deal with "set follow-fork" modes.

-- Steve

> +		if (pid == 0) {
> +			close(sd);
> +			signal(SIGCHLD, SIG_DFL);
> +			agent_handle(cd, nr_cpus, page_size);
> +		}
> +		if (pid > 0)
> +			handler_pid = pid;
> +
> +busy:
> +		close(cd);
> +	}
> +}
> +

diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 02dda47..da6ff12 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -170,6 +170,15 @@ static void handle_sigchld(int sig)
 	}
 }
 
+static pid_t do_fork()
+{
+	/* in debug mode, we do not fork off children */
+	if (debug)
+		return 0;
+
+	return fork();
+}
+
 static void agent_serve(unsigned int port)
 {
 	int sd, cd, nr_cpus;
@@ -195,7 +204,7 @@ static void agent_serve(unsigned int port)
 		if (handler_pid)
 			goto busy;
 
-		pid = fork();
+		pid = do_fork();
 		if (pid == 0) {
 			close(sd);
 			signal(SIGCHLD, SIG_DFL);
@@ -209,6 +218,10 @@ busy:
 	}
 }
 
+enum {
+	DO_DEBUG	= 255
+};
+
 void trace_agent(int argc, char **argv)
 {
 	bool do_daemon = false;
@@ -225,6 +238,7 @@ void trace_agent(int argc, char **argv)
 		static struct option long_options[] = {
 			{"port", required_argument, NULL, 'p'},
 			{"help", no_argument, NULL, '?'},
+			{"debug", no_argument, NULL, DO_DEBUG},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -242,6 +256,9 @@ void trace_agent(int argc, char **argv)
 		case 'D':
 			do_daemon = true;
 			break;
+		case DO_DEBUG:
+			debug = true;
+			break;
 		default:
 			usage(argv);
 		}
