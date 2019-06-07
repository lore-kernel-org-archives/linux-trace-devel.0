Return-Path: <SRS0=5Z96=UG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FEA8C28CC3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jun 2019 06:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04B5A2089E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jun 2019 06:48:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qpUyn0I2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfFGGsT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 02:48:19 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43409 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbfFGGsT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 02:48:19 -0400
Received: by mail-io1-f65.google.com with SMTP id k20so587549ios.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 06 Jun 2019 23:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aEhHmCJlVpz6+R0GfskTlzIXA0fQfi23mgP4/k5VOAI=;
        b=qpUyn0I2/dpyrQMunCJRz0ia5b5DI5yJLOQwp6BPxz+n2eQAjiYVURUANncglTn95Q
         4ujK2saeQVT7BamTIlPyDvIN8J8WbQQgbMdAVv5p2YHTbklXdsqWOqTObeKp1/K52T0p
         lwE6q698GBdOzA4xLLKeqLKd+c9nRP89zVN8RG94nWMWIt9/MzU617XVaYO4Hz35qP7S
         6kQSEYpwKjMtz7VPptQqsbDuju5floTIfhVr/dJwkTPL8xBdTLbVE1ee6xBT/sFTPJSB
         PYySewyMDmHWKjGl07H6Hhyx0kwrN+vOwvKUegQpKDWhYl757a/l8/b9rB1nhnz6qvQL
         qqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aEhHmCJlVpz6+R0GfskTlzIXA0fQfi23mgP4/k5VOAI=;
        b=F7TuqgpFo1rdqInLRrPJjBeXlbGnHnTyPAKlapGVFFGpgglTIUn4D3blPQ8u/U+t2R
         ThKWvsRx5wyAzr7sJkNUe6jwcV4DL1HTAk0QAsFo24WzafP5pW6cxnqmMKTyTgaLai7h
         y55m4BXbO5Dja/5diDn8p9OsbZHB492jN+cCGviPqYNFhJ3AImxYHEtfkdb9Nc4C/9WA
         SWna6iXbf/8HxMtExMtxMNAr2RHrcbpbsKoqTgw6wj4c4uxBE350pN/6q5vu46VRzMEn
         IfNTAbq74QVKICh2ANLbtnmRq3VXhQHGIBXVzzPZgBhlp0nf4eKgD10wGfpnnJRXqbO5
         /oQQ==
X-Gm-Message-State: APjAAAVRdDluVT4oChzPGOJEWhYnzotei9lt8H1l5Y4eji+KvgeEugEf
        qZ46TtnceckZl9HC+2svll7jfYrLV8AE/itH4g==
X-Google-Smtp-Source: APXvYqyULz9HfHjtEZa/8bUtjIN/83PniuzBbhetywgFHa3RZeoodQL7kx3gtUtU/ypvJDwYdHKyGMKzfn3m4P2e8OA=
X-Received: by 2002:a6b:1cc:: with SMTP id 195mr17261575iob.87.1559890098512;
 Thu, 06 Jun 2019 23:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190605111937.17894-1-tstoyanov@vmware.com> <20190605111937.17894-2-tstoyanov@vmware.com>
In-Reply-To: <20190605111937.17894-2-tstoyanov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Fri, 7 Jun 2019 09:48:07 +0300
Message-ID: <CAE0o1NswsBe7aGNBAX8jn0fbJd5R1doJgpAO+a+qJ=j=A1+9gg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] trace-cmd: Fix a possible race condition and
 deadlock in trace-cmd
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jun 5, 2019 at 2:21 PM Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:
>
> When pipes are used for communication between trace-cmd main
> thread and per-cpu recorder threads, there is a possible race
> condition in stop_threads(), which can cause a deadlock between
> the main thread and cpu recorder thread:
>    In trace_stream_read(), the select() call can return 0 if threads
>    have no data to send. This will force stop_threads() to stop reading
>    the thread's pipes and enter a waitpid() loop, to wait for all threads
>    to be terminated. However, there is a case when some threads are still
>    flushing its data - tracecmd_flush_recording() tries a blocking write()
>    to the pipe. A dead lock appears - the cpu thread is blocked in write(),
>    as its buffer is full and no one is reading it. The main thread is blocked
>    in waitpid(), to wait the same thread to exit.
> The deadlock can be (randomly) observed with the command
> "trace-cmd profile -p function -F sleep 10"
>
> The proposed fix removes the select timeout, makes the call blocking,
> to ensure the threads are flushed its data before going in waitpid() loop.
>
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tracecmd/trace-record.c | 3 +--
>  tracecmd/trace-stream.c | 6 ++++++
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 4523128..2f5fbd9 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -626,7 +626,6 @@ static void delete_thread_data(void)
>
>  static void stop_threads(enum trace_type type)
>  {
> -       struct timeval tv = { 0, 0 };
>         int ret;
>         int i;
>
> @@ -643,7 +642,7 @@ static void stop_threads(enum trace_type type)
>         /* Flush out the pipes */
>         if (type & TRACE_TYPE_STREAM) {
>                 do {
> -                       ret = trace_stream_read(pids, recorder_threads, &tv);
> +                       ret = trace_stream_read(pids, recorder_threads, NULL);
>                 } while (ret > 0);
>         }
>
> diff --git a/tracecmd/trace-stream.c b/tracecmd/trace-stream.c
> index dad3466..3814a35 100644
> --- a/tracecmd/trace-stream.c
> +++ b/tracecmd/trace-stream.c
> @@ -92,6 +92,7 @@ int trace_stream_read(struct pid_record_data *pids, int nr_pids, struct timeval
>         struct pid_record_data *last_pid;
>         fd_set rfds;
>         int top_rfd = 0;
> +       int nr_fd;
>         int ret;
>         int i;
>
> @@ -119,18 +120,23 @@ int trace_stream_read(struct pid_record_data *pids, int nr_pids, struct timeval
>                 return 1;
>         }
>
> +       nr_fd = 0;
>         FD_ZERO(&rfds);
>
>         for (i = 0; i < nr_pids; i++) {
>                 /* Do not process closed pipes */
>                 if (pids[i].closed)
>                         continue;
> +               nr_fd++;
>                 if (pids[i].brass[0] > top_rfd)
>                         top_rfd = pids[i].brass[0];
>
>                 FD_SET(pids[i].brass[0], &rfds);
>         }
>
> +       if (!nr_fd)
> +               return 0;
> +
>         ret = select(top_rfd + 1, &rfds, NULL, NULL, tv);
>
>         if (ret > 0)
> --
> 2.21.0
>

Looks good to me.

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Cheers,

-- Slavi
