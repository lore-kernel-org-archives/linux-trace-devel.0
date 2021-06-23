Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B045EC4743C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jun 2021 13:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8537A61076
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jun 2021 13:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhFWNWL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 09:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230163AbhFWNWK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 09:22:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEB2E61075;
        Wed, 23 Jun 2021 13:19:52 +0000 (UTC)
Date:   Wed, 23 Jun 2021 09:19:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] libtracefs: Add APIs for data streaming
Message-ID: <20210623091951.7eed6b50@gandalf.local.home>
In-Reply-To: <481ebd67-050b-06bf-bcce-ae0febd79ab5@gmail.com>
References: <20210623120526.36623-1-y.karadz@gmail.com>
        <20210623084535.7a199813@gandalf.local.home>
        <481ebd67-050b-06bf-bcce-ae0febd79ab5@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 23 Jun 2021 16:02:00 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> > I'm thinking we should invert the above. That is, have a stop instead of
> > "keep_going", where it is false by default (when the instance is created).
> > 
> > That's because, if we start here, and the SIGINT comes in before we get
> > here, it keep_going might get set to false, and missed.  
> 
> I intentionally tried to avoid having any dependency of the initialization value of the "keep_going" flag. We have to 
> consider the case when the user creates one instance and then calls this function multiple times in a row.

If anything then, make it the first thing that gets done, and not just
before the loop.

That is:


+int tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance,
+			      int flags)
+{
+	int *keep_going = instance ? &instance->pipe_keep_going :
+				     &top_pipe_keep_going;
+	const char *file = "trace_pipe";
+	int brass[2], in_fd, ret = -1;
+	off_t data_size;

	*keep_going = true;

+
+	in_fd = tracefs_instance_file_open(instance, file, O_RDONLY);
+	if (in_fd < 0) {
+		tracefs_warning("Failed to open 'trace_pipe'.");
+		return ret;
+	}
+
+	if(pipe(brass) < 0) {
+		tracefs_warning("Failed to open pipe.");
+		goto close_file;
+	}
+
+	data_size = fcntl(brass[0], F_GETPIPE_SZ);
+	if (data_size <= 0) {
+		tracefs_warning("Failed to open pipe (size=0).");
+		goto close_all;
+	}
+
+	*keep_going = true;

And not here.

+	while (*keep_going) {
+		ret = splice(in_fd, NULL,
+			     brass[1], NULL,
+			     data_size, flags);
+		if (ret < 0)
+			break;
+
+		ret = splice(brass[0], NULL,
+			     fd, NULL,
+			     data_size, flags);
+		if (ret < 0)
+			break;
+	}


And I think we need to make it volatile, otherwise the compiler is free to
ignore it. Because the compiler does not need to know about threads.

	*keep_going = true;
	while (*keep_going) {
		[ do something ]
	}

To the compiler that is the same as:

	while (1) {
		[ do something ]
	}

And is free to make that change when optimizing.

What needs to be done is:

	(*(volatile bool *)keep_going) = true;

and

	while (*(volatile bool *)keep_going) {

That way the compiler knows that the value can change from outside its
knowledge.

-- Steve
