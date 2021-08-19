Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B99AC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9783610CF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhHSExY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 00:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhHSExY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 00:53:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 836EF6103A;
        Thu, 19 Aug 2021 04:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629348768;
        bh=DbnifDUE2/E036WKLPYldaSAIsnOFLDiA1ZXD7LKQLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sZcbr96EqImpP2ZATKxlkF9+9hb/qEZD7Ex8uk9JW7muusnf5G/CodbqqE+nPV9Ez
         K6efn5gY/HsnQ+RHUHZqvm3Gp/4OWeePhwMhRa5VhOpuWbnN9aJx/azeEjk7BIsjnb
         Kh8BwyvlMOO0yaUjjr9geNco55nTmFJP5aX0SjFWXhDiyX0WhrZUEs6YfyqPMjok+i
         r6Kuzxn2FXasSH9ffTzWlPqI16qOy7xjPoMRPECFhz1uzraHwhRPZryqejvE/c81K/
         hbpAnZTLoJcaWjBEf3LhLDWqQsXhJk+fhUNbEfvFJBxDtYaziMg/zXnme0M0Lia4sM
         nhO5M64PlpNJg==
Date:   Thu, 19 Aug 2021 13:52:46 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: Re: [PATCH v7 07/10] tracing/probes: Have process_fetch_insn() take
 a void * instead of pt_regs
Message-Id: <20210819135246.fbf2d4c7c248c9d4ce611b90@kernel.org>
In-Reply-To: <20210819041842.291622924@goodmis.org>
References: <20210819041321.105110033@goodmis.org>
        <20210819041842.291622924@goodmis.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 19 Aug 2021 00:13:28 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> In preparation to allow event probes to use the process_fetch_insn()
> callback in trace_probe_tmpl.h, change the data passed to it from a
> pointer to pt_regs, as the event probe will not be using regs, and make it
> a void pointer instead.

Yes, it is reasonable to be updated in the separated patch.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you!

> 
> Update the process_fetch_insn() callers for kprobe and uprobe events to
> have the regs defined in the function and just typecast the void pointer
> parameter.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_kprobe.c     | 3 ++-
>  kernel/trace/trace_probe_tmpl.h | 6 +++---
>  kernel/trace/trace_uprobe.c     | 3 ++-
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index c6fe7a6e3f35..4b013d24f5a9 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1325,9 +1325,10 @@ probe_mem_read(void *dest, void *src, size_t size)
>  
>  /* Note that we don't verify it, since the code does not come from user space */
>  static int
> -process_fetch_insn(struct fetch_insn *code, struct pt_regs *regs, void *dest,
> +process_fetch_insn(struct fetch_insn *code, void *rec, void *dest,
>  		   void *base)
>  {
> +	struct pt_regs *regs = rec;
>  	unsigned long val;
>  
>  retry:
> diff --git a/kernel/trace/trace_probe_tmpl.h b/kernel/trace/trace_probe_tmpl.h
> index f003c5d02a3a..b3bdb8ddb862 100644
> --- a/kernel/trace/trace_probe_tmpl.h
> +++ b/kernel/trace/trace_probe_tmpl.h
> @@ -54,7 +54,7 @@ fetch_apply_bitfield(struct fetch_insn *code, void *buf)
>   * If dest is NULL, don't store result and return required dynamic data size.
>   */
>  static int
> -process_fetch_insn(struct fetch_insn *code, struct pt_regs *regs,
> +process_fetch_insn(struct fetch_insn *code, void *rec,
>  		   void *dest, void *base);
>  static nokprobe_inline int fetch_store_strlen(unsigned long addr);
>  static nokprobe_inline int
> @@ -188,7 +188,7 @@ __get_data_size(struct trace_probe *tp, struct pt_regs *regs)
>  
>  /* Store the value of each argument */
>  static nokprobe_inline void
> -store_trace_args(void *data, struct trace_probe *tp, struct pt_regs *regs,
> +store_trace_args(void *data, struct trace_probe *tp, void *rec,
>  		 int header_size, int maxlen)
>  {
>  	struct probe_arg *arg;
> @@ -203,7 +203,7 @@ store_trace_args(void *data, struct trace_probe *tp, struct pt_regs *regs,
>  		/* Point the dynamic data area if needed */
>  		if (unlikely(arg->dynamic))
>  			*dl = make_data_loc(maxlen, dyndata - base);
> -		ret = process_fetch_insn(arg->code, regs, dl, base);
> +		ret = process_fetch_insn(arg->code, rec, dl, base);
>  		if (unlikely(ret < 0 && arg->dynamic)) {
>  			*dl = make_data_loc(0, dyndata - base);
>  		} else {
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 09f8ca7f7ba0..d219ba50efbd 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -213,9 +213,10 @@ static unsigned long translate_user_vaddr(unsigned long file_offset)
>  
>  /* Note that we don't verify it, since the code does not come from user space */
>  static int
> -process_fetch_insn(struct fetch_insn *code, struct pt_regs *regs, void *dest,
> +process_fetch_insn(struct fetch_insn *code, void *rec, void *dest,
>  		   void *base)
>  {
> +	struct pt_regs *regs = rec;
>  	unsigned long val;
>  
>  	/* 1st stage: get value from context */
> -- 
> 2.30.2


-- 
Masami Hiramatsu <mhiramat@kernel.org>
