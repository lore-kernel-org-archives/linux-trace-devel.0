Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CF7C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 31 Mar 2022 12:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236184AbiCaMha (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 08:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbiCaMh3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 08:37:29 -0400
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com [192.185.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8A3D3728
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Mar 2022 05:35:42 -0700 (PDT)
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id F016C37C1
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Mar 2022 07:29:03 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id ZtvDnNelI22u3ZtvDnaBHK; Thu, 31 Mar 2022 07:29:03 -0500
X-Authority-Reason: nr=8
Received: from host-79-43-204-123.retail.telecomitalia.it ([79.43.204.123]:33846 helo=[10.0.0.45])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1nZtvC-003hze-6S; Thu, 31 Mar 2022 07:29:02 -0500
Message-ID: <4a2834be-adf3-88f6-fc86-58ec16a2b03d@kernel.org>
Date:   Thu, 31 Mar 2022 14:28:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] rtla/osnoise_hist: avoid NULL pointer dereference on out
Content-Language: en-US
To:     Haowen Bai <baihaowen@meizu.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1648624385-10091-1-git-send-email-baihaowen@meizu.com>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <1648624385-10091-1-git-send-email-baihaowen@meizu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 79.43.204.123
X-Source-L: No
X-Exim-ID: 1nZtvC-003hze-6S
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-43-204-123.retail.telecomitalia.it ([10.0.0.45]) [79.43.204.123]:33846
X-Source-Auth: kernel@bristot.me
X-Email-Count: 11
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 3/30/22 09:13, Haowen Bai wrote:
> record is NULL and go out but dereference record->trace.
> 
> report by coccicheck:
> tools/tracing/rtla/src/osnoise_hist.c:870:31-36: ERROR:
> record is NULL but dereferenced.

Duplicated of:
https://lore.kernel.org/lkml/20220322113253.57390-1-wanjiabing@vivo.com/

Next time, please, consolidate your patches for the same Fixes: into a single one.

Thanks,
-- Daniel

> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>  tools/tracing/rtla/src/osnoise_hist.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/tracing/rtla/src/osnoise_hist.c b/tools/tracing/rtla/src/osnoise_hist.c
> index b4380d4..b7862b4 100644
> --- a/tools/tracing/rtla/src/osnoise_hist.c
> +++ b/tools/tracing/rtla/src/osnoise_hist.c
> @@ -819,13 +819,13 @@ int osnoise_hist_main(int argc, char *argv[])
>  		record = osnoise_init_trace_tool("osnoise");
>  		if (!record) {
>  			err_msg("Failed to enable the trace instance\n");
> -			goto out_hist;
> +			goto out_top;
>  		}
>  
>  		if (params->events) {
>  			retval = trace_events_enable(&record->trace, params->events);
>  			if (retval)
> -				goto out_hist;
> +				goto out_top;
>  		}
>  
>  		trace_instance_start(&record->trace);
> @@ -845,7 +845,7 @@ int osnoise_hist_main(int argc, char *argv[])
>  						    trace);
>  		if (retval < 0) {
>  			err_msg("Error iterating on events\n");
> -			goto out_hist;
> +			goto out_top;
>  		}
>  
>  		if (trace_is_off(&tool->trace, &record->trace))
> @@ -865,9 +865,9 @@ int osnoise_hist_main(int argc, char *argv[])
>  			save_trace_to_file(record->trace.inst, params->trace_output);
>  		}
>  	}
> -
> -out_hist:
> +out_top:
>  	trace_events_destroy(&record->trace, params->events);
> +out_hist:
>  	params->events = NULL;
>  	osnoise_free_histogram(tool->data);
>  out_destroy:

