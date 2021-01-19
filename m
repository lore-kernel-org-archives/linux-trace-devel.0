Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1749C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Jan 2021 22:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0C66230FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Jan 2021 22:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbhASWU2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Jan 2021 17:20:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbhASWTY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Jan 2021 17:19:24 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 565C822E01;
        Tue, 19 Jan 2021 22:18:43 +0000 (UTC)
Date:   Tue, 19 Jan 2021 17:18:41 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/5] libtracefs: New APIs for getting existing trace
 instance
Message-ID: <20210119171841.265844d3@gandalf.local.home>
In-Reply-To: <20210115050410.1194011-5-tz.stoyanov@gmail.com>
References: <20210115050410.1194011-1-tz.stoyanov@gmail.com>
        <20210115050410.1194011-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 15 Jan 2021 07:04:09 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +++ b/include/tracefs.h
> @@ -20,9 +20,12 @@ struct tracefs_instance;
>  
>  void tracefs_instance_free(struct tracefs_instance *instance);
>  struct tracefs_instance *tracefs_instance_create(const char *name);
> +struct tracefs_instance *tracefs_instance_get(const char *tracing_dir,
> +					      const char *name);

I don't think I care for the "_get" name here because it doesn't get
anything, it allocates it. As below, we have functions with "_get" that
return something that already exists (and why it returns a "const" value).

I think the above should be called:

  tracefs_instance_alloc()

?

-- Steve


>  int tracefs_instance_destroy(struct tracefs_instance *instance);
>  bool tracefs_instance_is_new(struct tracefs_instance *instance);
>  const char *tracefs_instance_get_name(struct tracefs_instance *instance);
> +const char *tracefs_instance_get_trace_dir(struct tracefs_instance *instance);
>  char *
>  tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
>  char *tracefs_instance_get_dir(struct tracefs_instance *instance);
> diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
