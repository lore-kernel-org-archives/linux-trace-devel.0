Return-Path: <SRS0=qwEJ=6G=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDFDC55189
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Apr 2020 13:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A885F20774
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Apr 2020 13:39:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aQPOsnnT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgDVNjp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Apr 2020 09:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgDVNjo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Apr 2020 09:39:44 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AC3C03C1A9
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Apr 2020 06:39:43 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id j14so1675649lfg.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Apr 2020 06:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6BH1VXjeUDPWzwXVm68n0goLyNv8ouZXyfwsXdhx2No=;
        b=aQPOsnnTYbk/jM6DwOx3swXGJ0/isDh/vTRDMncAzhH6VuJiUGmK3avgukYdBoYSFy
         Wwzy2TLz4OxhS+htuFU69TJEi7d3gznCUgrtDo825TeDgf5XMiE0H07Hf8npoLy0g01I
         9wp7/z9R2YCDyAEA92jWdhjH8L9wwsWxw5J2epShnkUWp+OcdZr4qQgCqgEEpdMWOdEh
         NCao//wNHDEALg/O/C2/BSarAI5TQsFyHG67K2yHSed+UCX9/yh+IYch8VjSW+t21/yh
         35lTVKYXDvWF44wcIwWKVSbO+ggXEe8aaTA/NJ2An4R7HidTLs9Mbfkp9pgR+mPcEx/E
         Tq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6BH1VXjeUDPWzwXVm68n0goLyNv8ouZXyfwsXdhx2No=;
        b=XeIgoVB70aXh7NbR0SxDeT3XCF+k92W/dzex5e9y0wkhXAPqD4BZnKqjQqW4cLcx+m
         dYWhGzKH8BiR09g4nAK4J/jJ9Xo/XmjsgtW9TyOyYsl67tn4eIWOdGbO0fcPNAoNHAna
         YXM6+SgywlsLliYCvtXjPpuEJ5eri+mtHYYIY7W+24EpuCzMwS/xnoLhfxv2e88tGK6f
         tGIJTFEe3XccemVe17bBGtnjiUabbKTBHIaeHTcPvn12p2pSEx4vAOzvMz5BwqRsULmD
         RZGMVlhQz8KgAuNeKckeCgBbNk1X0XNDJRLD9+tNOx3X8a04d9baW9clTA8Sw5JhD+ZK
         Rzhg==
X-Gm-Message-State: AGi0PuaP34lhzIHr6e0m6AJZe+X38LlCtgy2IaZEK5fsQIGdXwitRAJs
        0ZdkNBbvH3CBdisVfaIJUPViO3jU1B4=
X-Google-Smtp-Source: APiQypL/olCC1dHCmRmOM7Sa9I/WE0P4Ug6TfSdCcwIOvuIKYc9HHRqDRC7pdN7U5pVwm5FVvMlOjA==
X-Received: by 2002:ac2:58ec:: with SMTP id v12mr17151256lfo.215.1587562781396;
        Wed, 22 Apr 2020 06:39:41 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.94])
        by smtp.gmail.com with ESMTPSA id b2sm4711283lfi.14.2020.04.22.06.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 06:39:40 -0700 (PDT)
Subject: Re: [PATCH v3 2/5] kernel-shark-2.alpha: Use new tracecmd APIs to
 open guest tracing file
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20200416160047.77118-1-tz.stoyanov@gmail.com>
 <20200416160047.77118-3-tz.stoyanov@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <e8ec2011-d8dd-0d66-58b8-6d6a133a0bea@gmail.com>
Date:   Wed, 22 Apr 2020 16:39:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416160047.77118-3-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 16.04.20 г. 19:00 ч., Tzvetomir Stoyanov (VMware) wrote:
> From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> 
> The new tracecmd API tracecmd_open_head() allows opening a trace.dat
> file on stages. First, only the headers from the file are read and parsed,
> without reading the tracing data.
> The tracecmd_pair_peer() API is used to bind a tracing peer to
> this file, before parsing the trace data. This affects events timestamps
> correction when the tracing data is loaded.
> The tracecmd_get_guest_cpumap() API is used to find dependencies between
> all files and find a possible tracing peers.
> 
> This change depends on these trace-cmd patch sets:
>    "Useful APIs for merging tracing files"
> https://patchwork.kernel.org/project/linux-trace-devel/list/?series=268745
>    "Split reading the trace.dat options from trace data"
> https://patchwork.kernel.org/project/linux-trace-devel/list/?series=268743
> 
> Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> ---
>   src/libkshark-tepdata.c | 59 ++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> index 8678e12..f280e57 100644
> --- a/src/libkshark-tepdata.c
> +++ b/src/libkshark-tepdata.c
> @@ -985,6 +985,45 @@ const char *tep_plugin_names[] = {"sched_events",
>   
>   #define LINUX_IDLE_TASK_PID	0
>   
> +/** Find a host stream from the same tracing session, that has guest information */
> +struct tracecmd_input *kshark_tep_find_merge_peer(struct kshark_context *kshark_ctx,
> +						  struct tracecmd_input *handle)

This function can be defined static.

> +{
> +	struct tracecmd_input *peer_handle = NULL;
> +	struct kshark_data_stream *peer_stream;
> +	unsigned long long trace_id;
> +	int *streamIds = NULL;

Nit: please stick to "snake_case" in the C code and "camelCase in the 
C++ code.

No need to send new version. I am applying patchs 1-3 from this patch-set.

Thanks a lot!
Yordan

> +	int ret;
> +	int i;
> +
> +	trace_id = tracecmd_get_traceid(handle);
> +	if (!trace_id)
> +		goto out;
> +
> +	streamIds = kshark_all_streams(kshark_ctx);
> +	if (!streamIds)
> +		goto out;
> +	for (i = 0; i < kshark_ctx->n_streams; i++) {
> +		peer_stream = kshark_get_data_stream(kshark_ctx, streamIds[i]);
> +		if (!peer_stream || peer_stream->format != KS_TEP_DATA)
> +			continue;
> +		peer_handle = kshark_get_tep_input(peer_stream);
> +		if (!peer_handle)
> +			continue;
> +		ret = tracecmd_get_guest_cpumap(peer_handle, trace_id,
> +						NULL, NULL, NULL);
> +		if (!ret)
> +			break;
> +	}
> +
> +	if (i == kshark_ctx->n_streams)
> +		peer_handle = NULL;
> +
> +out:
> +	free(streamIds);
> +	return peer_handle;
> +}
> +
>   /** Initialize the FTRACE data input (from file). */
>   int kshark_tep_init_input(struct kshark_data_stream *stream,
>   			  const char *file)
> @@ -992,8 +1031,10 @@ int kshark_tep_init_input(struct kshark_data_stream *stream,
>   	struct kshark_context *kshark_ctx = NULL;
>   	struct tepdata_handle *tep_handle;
>   	struct kshark_plugin_list *plugin;
> +	struct tracecmd_input *merge_peer;
>   	struct tep_event *event;
>   	int i, n_tep_plugins;
> +	int ret;
>   
>   	if (!kshark_instance(&kshark_ctx) || !init_thread_seq())
>   		return -EEXIST;
> @@ -1009,13 +1050,29 @@ int kshark_tep_init_input(struct kshark_data_stream *stream,
>   	if (!tep_handle)
>   		return -EFAULT;
>   
> -	tep_handle->input = tracecmd_open(file);
> +	/** Open the tracing file, parse headers and create trace input context */
> +	tep_handle->input = tracecmd_open_head(file);
>   	if (!tep_handle->input) {
>   		free(tep_handle);
>   		stream->interface.handle = NULL;
>   		return -EEXIST;
>   	}
>   
> +	/** Find a merge peer from the same tracing session */
> +	merge_peer = kshark_tep_find_merge_peer(kshark_ctx, tep_handle->input);
> +	if (merge_peer)
> +		tracecmd_pair_peer(tep_handle->input, merge_peer);
> +
> +	/** Read the racing data from the file */
> +	ret = tracecmd_init_data(tep_handle->input);
> +
> +	if (ret < 0) {
> +		tracecmd_close(tep_handle->input);
> +		free(tep_handle);
> +		stream->interface.handle = NULL;
> +		return -EEXIST;
> +	}
> +
>   	tep_handle->tep = tracecmd_get_pevent(tep_handle->input);
>   
>   	tep_handle->sched_switch_event_id = -EINVAL;
> 
