Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C21111A8
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2024 18:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721242120; cv=none; b=C4JC3mFWWCQBGpkMBldux+goq5Rgkrf93q+r25RbCAeyhN91ZdkDbtb+/yM92mhguSk5hBqUVdb3NkoNAp7iB4R0RcpWFTloNtYJvIwpVl9usCz6t5vf+b4O3yiNZqGWNgdPfUn5ngwyOTFRkht2hitDSVoNCDKoYk4o8ok+TI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721242120; c=relaxed/simple;
	bh=UGG3XEzKoEbL62kE4LUtFEjq+YX2zHgc/iH+Vzp/H1A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AhaVOLWQwoUIJceV15nzR/EVmj+6d9AoNKDYfDooeMRXmJ8ZNwSSDAcMELQHM0fh2g2H1hBvdxbGtSy6zJ3LfE/Q4rqidOxZaXbfoC1PRgyjVLRioHPXt6iP1eHh1sAyeiDXmsfiiGvcCHsbMfqo66UQJ2bTT88ik3caYV022aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ACDC2BD10;
	Wed, 17 Jul 2024 18:48:39 +0000 (UTC)
Date: Wed, 17 Jul 2024 14:48:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jianfeng Wang <jianfeng.w.wang@oracle.com>
Cc: linux-trace-devel@vger.kernel.org, junxiao.bi@oracle.com
Subject: Re: [PATCH v2 1/2] trace-cmd ftrace: print function retval in
 function_graph
Message-ID: <20240717144837.67f77bb1@rorschach.local.home>
In-Reply-To: <20240521213730.67993-2-jianfeng.w.wang@oracle.com>
References: <20240521213730.67993-1-jianfeng.w.wang@oracle.com>
	<20240521213730.67993-2-jianfeng.w.wang@oracle.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Sorry for the late reply, I'm finally able to look at userspace tooling.

First little nit, please start the subject with a capital letter:

  trace-cmd report: Print function retval in function_graph

Also note that it's for the report command.

On Tue, 21 May 2024 14:37:29 -0700
Jianfeng Wang <jianfeng.w.wang@oracle.com> wrote:

> The upstream Linux kernel has introduced a new feature, i.e.
> funcgraph-retval for the function_graph tracer. (Commit ID:
> a1be9ccc57f07d54278be34eed6bd679bc941c97). With this feature, the
> function_graph tracer can record each function's return value along
> with its execution time at the function_graph exit handler. This is
> useful for debugging kernel issues, such as syscall errors.
> 
> This commit enhances 'trace-cmd report' by supporting the
> function_graph retval feature if the underlying kernel supports it.
> Once the feature is supported, 'trace-cmd report' will print each
> function's return value in this format: '(ret=retval)" at the end
> of every funcgraph leaf entry and exit event.
> 
> Example usage:
> *  Record
> > trace-cmd record -p function_graph -P <pid>  
> 
> The recording process is not changed: trace-cmd can communicate
> with the kernel to get the actual funcgraph_exit event format.
> If the kernel supports ftrace-retval, trace-cmd will use the
> updated event format that has "retval" field.
> 
> * Report
> > trace-cmd report -O fgraph:depth -O fgraph:tailprint  
> 
> If the kernel supports this feature, the output looks like this:
> 
>  <...>-1136215 [006] ..... 1724848.377495: funcgraph_entry:                   |        __cond_resched() { (3)
>  <...>-1136215 [006] ..... 1724848.377495: funcgraph_entry:        0.200 us   |          rcu_all_qs(); (4) (ret=0x0)
>  <...>-1136215 [006] ..... 1724848.377496: funcgraph_exit:         0.601 us   |        } /* __cond_resched */ (3) (ret=0x0)
>  <...>-1136215 [006] ..... 1724848.377496: funcgraph_entry:        0.581 us   |        proc_reg_write(); (3) (ret=-5)
>  <...>-1136215 [006] ..... 1724848.377497: funcgraph_exit:         5.059 us   |      } /* vfs_write */ (2) (ret=-5)
>  <...>-1136215 [006] ..... 1724848.377497: funcgraph_exit:         6.332 us   |    } /* ksys_write */ (1) (ret=-5)
>  <...>-1136215 [006] ..... 1724848.377497: funcgraph_exit:       + 18.414 us  |  } /* __x64_sys_write */ (0) (ret=-5)
> 
> Signed-off-by: Jianfeng Wang <jianfeng.w.wang@oracle.com>
> ---
>  lib/trace-cmd/trace-ftrace.c | 37 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
> index 89e46c3d..2b4e49a5 100644
> --- a/lib/trace-cmd/trace-ftrace.c
> +++ b/lib/trace-cmd/trace-ftrace.c
> @@ -10,6 +10,9 @@
>  
>  #include "trace-cmd-private.h"
>  
> +#define MAX_LINUX_ERRNO   4095
> +#define IS_LINUX_ERR_VALUE(x) ((unsigned long long)(void *)(x) >= (unsigned long long)-MAX_LINUX_ERRNO)
> +
>  struct tep_plugin_option trace_ftrace_options[] = {
>  	{
>  		.name = "tailprint",
> @@ -185,6 +188,8 @@ print_graph_entry_leaf(struct trace_seq *s,
>  	unsigned long long rettime, calltime;
>  	unsigned long long duration, depth;
>  	unsigned long long val;
> +	unsigned long long retval;
> +	bool fgraph_retval_supported = true;
>  	const char *func;
>  	int ret;
>  	int i;
> @@ -195,6 +200,13 @@ print_graph_entry_leaf(struct trace_seq *s,
>  	if (tep_get_field_val(s, finfo->fgraph_ret_event, "calltime", ret_rec, &calltime, 1))
>  		return trace_seq_putc(s, '!');
>  
> +	if (!tep_find_field(finfo->fgraph_ret_event, "retval"))
> +		fgraph_retval_supported = false;
> +	else {

This should follow Linux kernel syntax rules. That is, if one block of
a if statement has brackets, then the other should too.

Thanks,

-- Steve

> +		if (tep_get_field_val(s, finfo->fgraph_ret_event, "retval", ret_rec, &retval, 1))
> +			return trace_seq_putc(s, '!');
> +	}
> +
>  	duration = rettime - calltime;
