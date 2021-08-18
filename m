Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D23C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Aug 2021 11:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 970A461058
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Aug 2021 11:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbhHRLJl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Aug 2021 07:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234953AbhHRLJb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 07:09:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E94D961056;
        Wed, 18 Aug 2021 11:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629284936;
        bh=B1HlmalKG2Nd9HzfSJD1nnTG2Q2FTlnYnSy2mKI/utI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NtUWHA2L8sACPk/s0huyECUpMgbCvbq7rLllzkeFUZRoB/8TomlU0dSDCh7pQnSx9
         H9IzPgUlEP9vQByEOVxXZFVe3VGRyjah1hNFIaKiIhsdQaNFo0jkA8A3pV4vSbivMT
         UjXda3mbE+a33kfmr70KbbTD/Rd9/Mfq3VOZFpe+fwC9FFJLqe8aHG3yRnmFSm+8Wk
         aD6Tp3HLX8rQBGEkTliDj975qayJ6RQMGJw4/4Gu4Q58PKVIpZRT1gJMtnpdd20ru/
         0ZvGjFMwkme7yINu0DTvhq+vXW+x2rVI2KXzF0uAK+J7eV86433+1mahmyAtIqlftS
         /Q1HixPePRAsw==
Date:   Wed, 18 Aug 2021 20:08:51 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 5/7] tracing/probes: Use struct_size() instead of
 defining custom macros
Message-Id: <20210818200851.954e5030a64eb11ee156fa78@kernel.org>
In-Reply-To: <20210817035027.795000217@goodmis.org>
References: <20210817034255.421910614@goodmis.org>
        <20210817035027.795000217@goodmis.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 16 Aug 2021 23:43:00 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Remove SIZEOF_TRACE_KPROBE() and SIZEOF_TRACE_UPROBE() and use
> struct_size() as that's what it is made for. No need to have custom
> macros. Especially since struct_size() has some extra memory checks for
> correctness.
> 

Good catch!

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you!

> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_kprobe.c | 6 +-----
>  kernel/trace/trace_uprobe.c | 6 +-----
>  2 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index ed1e3c2087ab..ca726c9d0859 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -80,10 +80,6 @@ static struct trace_kprobe *to_trace_kprobe(struct dyn_event *ev)
>  	for_each_dyn_event(dpos)		\
>  		if (is_trace_kprobe(dpos) && (pos = to_trace_kprobe(dpos)))
>  
> -#define SIZEOF_TRACE_KPROBE(n)				\
> -	(offsetof(struct trace_kprobe, tp.args) +	\
> -	(sizeof(struct probe_arg) * (n)))
> -
>  static nokprobe_inline bool trace_kprobe_is_return(struct trace_kprobe *tk)
>  {
>  	return tk->rp.handler != NULL;
> @@ -265,7 +261,7 @@ static struct trace_kprobe *alloc_trace_kprobe(const char *group,
>  	struct trace_kprobe *tk;
>  	int ret = -ENOMEM;
>  
> -	tk = kzalloc(SIZEOF_TRACE_KPROBE(nargs), GFP_KERNEL);
> +	tk = kzalloc(struct_size(tk, tp.args, nargs), GFP_KERNEL);
>  	if (!tk)
>  		return ERR_PTR(ret);
>  
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 93ff96541971..590bb9a02f8d 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -83,10 +83,6 @@ static struct trace_uprobe *to_trace_uprobe(struct dyn_event *ev)
>  	for_each_dyn_event(dpos)		\
>  		if (is_trace_uprobe(dpos) && (pos = to_trace_uprobe(dpos)))
>  
> -#define SIZEOF_TRACE_UPROBE(n)				\
> -	(offsetof(struct trace_uprobe, tp.args) +	\
> -	(sizeof(struct probe_arg) * (n)))
> -
>  static int register_uprobe_event(struct trace_uprobe *tu);
>  static int unregister_uprobe_event(struct trace_uprobe *tu);
>  
> @@ -340,7 +336,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
>  	struct trace_uprobe *tu;
>  	int ret;
>  
> -	tu = kzalloc(SIZEOF_TRACE_UPROBE(nargs), GFP_KERNEL);
> +	tu = kzalloc(struct_size(tu, tp.args, nargs), GFP_KERNEL);
>  	if (!tu)
>  		return ERR_PTR(-ENOMEM);
>  
> -- 
> 2.30.2


-- 
Masami Hiramatsu <mhiramat@kernel.org>
