Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:33554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbeK1Hdl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 02:33:41 -0500
Date: Tue, 27 Nov 2018 15:34:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 01/11] kernel-shark-qt: Protect all calls of
 tep_read_number_field()
Message-ID: <20181127153433.5eee37ac@gandalf.local.home>
In-Reply-To: <20181121151356.16901-3-ykaradzhov@vmware.com>
References: <20181121151356.16901-1-ykaradzhov@vmware.com>
        <20181121151356.16901-3-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 21 Nov 2018 15:14:19 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> tep_read_number_field() is being used to retrieve the value of a data
> field and this value has being used without checking if the function
> succeeded. This is a potential bug because tep_read_number_field() may
> fail and in such a case the retrieved field value will be arbitrary.
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark-qt/src/plugins/sched_events.c | 52 +++++++++++++---------
>  1 file changed, 30 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel-shark-qt/src/plugins/sched_events.c b/kernel-shark-qt/src/plugins/sched_events.c
> index 1851569..c22e198 100644
> --- a/kernel-shark-qt/src/plugins/sched_events.c
> +++ b/kernel-shark-qt/src/plugins/sched_events.c
> @@ -97,10 +97,12 @@ int plugin_get_next_pid(struct tep_record *record)
>  	struct plugin_sched_context *plugin_ctx =
>  		plugin_sched_context_handler;
>  	unsigned long long val;
> +	int ret;
>  
> -	tep_read_number_field(plugin_ctx->sched_switch_next_field,
> -			      record->data, &val);
> -	return val;
> +	ret = tep_read_number_field(plugin_ctx->sched_switch_next_field,
> +				    record->data, &val);
> +
> +	return (ret == 0) ? val : ret;

BTW, here's a little optimization trick:

	return ret ? : val;

We should change the rest to do that.

-- Steve

>  }
>  
