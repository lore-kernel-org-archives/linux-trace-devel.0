Return-Path: <SRS0=6Q4x=5T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9705EC43331
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 11:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6238D2082F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 11:39:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PHldsk5s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgDCLjd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Apr 2020 07:39:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45451 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbgDCLjc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 07:39:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id t7so8089750wrw.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Apr 2020 04:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dKzuPTEwIrxNPKCl7QKtMhVzvI1znaaYjy1yFssCzfk=;
        b=PHldsk5sTIKY+0/7D6qDpiEC+p9QqBmQIfeOFXSjoLyJHbNipQ4KIJR+U0M9xYRNk6
         bMIWS5LRW3Iv0KMz0/6wgBhzNcZK0Wy+FTxud3iccg0ji8/Ca5WhX/da8mOUi/zOzabG
         SOpYdfdwcFzv3dj6/oNdOL2HVimqGL2kdAaU8COXYCv3thZv/TbLop4NgPtAf3Slm+BY
         1Oh8JijCLvRe4W2L/Zw1D7aIyd1OB49sSVonUTflkpDDCJUFYFBZuZTjqg291m7RLbi5
         CgG3BzbSUw4Lz9ZRloJWdk5pqmiblQKkkci8532QyIEF7pNoomki4ki5BNtaYAqu9SZ5
         A47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dKzuPTEwIrxNPKCl7QKtMhVzvI1znaaYjy1yFssCzfk=;
        b=GKUjtrH7fGBxVOcP7w25WbsbEQ4RqTCd3oiWcDWDBlbOUzvL4LQdqjjUdvIVJZYVu9
         rLELK3usyHut9oBdLC9OHwDT1DVbg+Sx5JtAq/HvwhfHk25WmyQnNAqS2QE20sP8HKZK
         o3DHHKxWIxRmOpDWRnRyy2qEKD91iNFRzRMdAbTWfkaPD1B96LnzCD5/ph5SzagADrG+
         lxaemuBBn/hEnS9ur3HsNr5wQSfLZ2cScjRdyzkiqc3HI3rJ4Nw/V4OTSjauXwn6cag0
         8v6ibBjHPBOlpLcHqVPtDvECQrcn42zWKLfl5mXMBCfU9e6V/K7IxlD8PDI7YxBYb+LA
         4m4A==
X-Gm-Message-State: AGi0PuaezVce2TcLQjhX4k9QQ8Gcl6VHCWMh2gShobFWg2wBZUlVUg9I
        Ea/8sFZ0W6ivgWkwj+WaDm9RsJ1X
X-Google-Smtp-Source: APiQypKZC2zGjd8N//b/U8EMU22QYs0xDfPKeCQ+teMryMj0FREMbvyz7+0grDxCGIL4QsJ3TmJKTA==
X-Received: by 2002:a5d:4cc7:: with SMTP id c7mr8382389wrt.375.1585913969224;
        Fri, 03 Apr 2020 04:39:29 -0700 (PDT)
Received: from [10.23.10.233] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o16sm11861571wrw.75.2020.04.03.04.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 04:39:28 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark-2.alpha: Use new tracecmd API to open guest
 tracing file
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20200401164509.191494-1-tz.stoyanov@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <0f53a13b-f1ff-f467-0f95-899ca404b5b0@gmail.com>
Date:   Fri, 3 Apr 2020 14:39:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200401164509.191494-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 1.04.20 г. 19:45 ч., Tzvetomir Stoyanov (VMware) wrote:
> From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> 
> The new tracecmd API tracecmd_open_merge() is used to open guest
> tracing file and synchronize it to the host file.
> This change is for testing purposes only, to test the new per CPU
> timestamps synchronization logic.
> It assumes that the stream with id 0 is the host one, and all others are
> guest streams.
> This change depends on commit:
>   "trace-cmd: Add new API to merge two trace files"
> where the new tracecmd API is introduced.
> 
> Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> ---
>   src/libkshark-tepdata.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> index 8678e12..b80b945 100644
> --- a/src/libkshark-tepdata.c
> +++ b/src/libkshark-tepdata.c
> @@ -1008,8 +1008,17 @@ int kshark_tep_init_input(struct kshark_data_stream *stream,
>   	tep_handle = calloc(1, sizeof(*tep_handle));
>   	if (!tep_handle)
>   		return -EFAULT;
> -
> -	tep_handle->input = tracecmd_open(file);

Hi Ceco,

Is it possible to avoid the hard-coded ID number of the primary stream 
(zero in this case)?

Maybe we can add data field to "struct tepdata_handle" that can be used 
to indicate if the stream is "primary" or not. Note that "struct 
tepdata_handle" is defined only for "libkshark-tepdata.c".

Also do we consider a case when we will need to load more than one 
"primary" stream?

Thanks!
Yordan


> +	if (stream->stream_id > 0) {
> +		struct kshark_data_stream *primary;
> +
> +		primary = kshark_get_data_stream(kshark_ctx, 0);
> +		if (primary && primary->file)
> +			tep_handle->input = tracecmd_open_merge(file,
> +								primary->file);
> +		else
> +			tep_handle->input = tracecmd_open(file);
> +	} else
> +		tep_handle->input = tracecmd_open(file);
>   	if (!tep_handle->input) {
>   		free(tep_handle);
>   		stream->interface.handle = NULL;
> 
