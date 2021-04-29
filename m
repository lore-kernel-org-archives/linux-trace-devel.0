Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F271CC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDF2261408
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbhD2Nu5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 09:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232867AbhD2Nu5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 09:50:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D3CA61408;
        Thu, 29 Apr 2021 13:50:10 +0000 (UTC)
Date:   Thu, 29 Apr 2021 09:50:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] trace-cmd library: Extend the create file APIs
 to support different file version
Message-ID: <20210429095009.68765c54@gandalf.local.home>
In-Reply-To: <20210429040119.843617-7-tz.stoyanov@gmail.com>
References: <20210429040119.843617-1-tz.stoyanov@gmail.com>
        <20210429040119.843617-7-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Apr 2021 07:01:18 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -266,20 +266,25 @@ struct tracecmd_event_list {
>  struct tracecmd_option;
>  struct tracecmd_msg_handle;
>  
> -struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
> +struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus,
> +						     unsigned long file_version);
>  struct tracecmd_output *
> -tracecmd_create_init_file_glob(const char *output_file,
> -			       struct tracecmd_event_list *list);
> +tracecmd_create_init_file_glob(const char *output_file, struct tracecmd_event_list *list,
> +			       unsigned long file_version);
>  struct tracecmd_output *tracecmd_create_init_fd(int fd);
>  struct tracecmd_output *
> -tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list);
> +tracecmd_create_init_fd_glob(int fd, struct tracecmd_event_list *list,
> +			     unsigned long file_version);
>  struct tracecmd_output *
>  tracecmd_create_init_fd_msg(struct tracecmd_msg_handle *msg_handle,
> -			    struct tracecmd_event_list *list);
> -struct tracecmd_output *tracecmd_create_init_file(const char *output_file);
> +			    struct tracecmd_event_list *list,
> +			    unsigned long file_version);
> +struct tracecmd_output *tracecmd_create_init_file(const char *output_file,
> +						  unsigned long file_version);
>  struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
>  							   const char *tracing_dir,
> -							   const char *kallsyms);
> +							   const char *kallsyms,
> +							   unsigned long file_version);
>  struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
>  					    unsigned short id, int size,
>  					    const void *data);


I think this is too complex of an API. The callers should not care what
version the file is used. It should be automatic.

That is, the init function can save the location of where it writes the
version number as I described in the other email. When the user calls an
API that requires a higher version than is recorded, we update it too.

Now this may take some coordination if the versions change the state. But
that too can be detected, as we can build an automata diagram to calculate
what version the user is using to continue the states.

-- Steve
