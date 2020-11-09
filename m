Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D602C2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Nov 2020 14:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B162E20E65
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Nov 2020 14:56:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NRmexOtX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730637AbgKIO4B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Nov 2020 09:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730294AbgKIO4B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Nov 2020 09:56:01 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E085CC0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Nov 2020 06:56:00 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id v5so8237684wmh.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 09 Nov 2020 06:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QLDmSkdm9Sv+xQ8CcoYLZS9jpcKGpKJpaHYLhLYfuBc=;
        b=NRmexOtXIugKr59hre/yok3EbHK0SRIP+hu3Y2oYhEMsZ+zQQD7NoJK/hMvqra+wMY
         2nLGj0gJcpWd1ZZFaC3zqz00sBl3xqUcAWlfQB08XcNXcP5bwIi/DrPTEp6L1zYH3Qfr
         xXgiqUG1JBxolkKutzWjKRe2QWPm8n3Q5zj6CwBWZQdNi4StfrqeURdfm/CiSLwNetI4
         KofoPR3SYQ1PtKgMzGCOPhgtSl/zMCGN3KzYKhJNXT7TLQl1s6CWaBuIccxdcjsMASVS
         Nj/tAm2oknvkGJwL9JkRvGdR2Xw7gC3bEvjZfJv4ZcVDdPrL47Dewe1QvGOLGVEmUf8v
         Ai3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QLDmSkdm9Sv+xQ8CcoYLZS9jpcKGpKJpaHYLhLYfuBc=;
        b=oAkGh8WJnxbbJHizQYSYozLEtFh5UEFCI48nfbsn7Ofn/t6iXmgk8ZwSdg4n47vT9B
         OIuvTnnjU+f6w7Ip0/UwOQ67/9xZhsrTRckcsxQh1sFHLF25t0uUsqais5N7EaSLKThH
         F1jGdsXhALyLC7oRNiZ8XkjX+ipxDOqoVVWJX1/DvVM4OD9lXbmrgTuzyY8SF+GCvsQi
         FycjjX9Yt5r/9LIFUu2hS9CGiLC2hGqalWI+5PXwbEqQli0uBrh+TLO90OdHjZErqRDj
         mkdI7DM+EucEo6LC2Ifs0K2styUS0UXlZONRgb3qOESEiaQtV8ShwXmRhEwAnLv1R+Mr
         VE7A==
X-Gm-Message-State: AOAM5323yvOaOWJtl0tMrpPcCd+6dHqj/p0TUybTzPwAgxCug2SV82kk
        RsRgAXMnDXH6XxTXr5zgwgDVbGyPNok=
X-Google-Smtp-Source: ABdhPJyjjYGZP/1E1r02Hdlt2qXUaqK67kfqG3EaCr8eVH2TROzro6rYb5lc7rIyIfZCX6NCQ5hTLw==
X-Received: by 2002:a1c:7f14:: with SMTP id a20mr15038356wmd.95.1604933759424;
        Mon, 09 Nov 2020 06:55:59 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id m20sm15005742wrg.81.2020.11.09.06.55.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 06:55:58 -0800 (PST)
Subject: Re: [PATCH v2 20/20] kernel-shark: Integrate streams with
 libkshark-configio
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201012133523.469040-1-y.karadz@gmail.com>
 <20201012133523.469040-21-y.karadz@gmail.com>
 <20201105142253.69485d76@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <af6f31bc-b5cb-d3fa-bb2f-fb953ef19734@gmail.com>
Date:   Mon, 9 Nov 2020 16:55:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201105142253.69485d76@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 5.11.20 г. 21:22 ч., Steven Rostedt wrote:
> On Mon, 12 Oct 2020 16:35:23 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> +int kshark_import_trace_file(struct kshark_context *kshark_ctx,
>> +			     struct kshark_config_doc *conf)
>>   {
>> -	const char *file = NULL;
>> +	const char *file = NULL, *name = NULL;
>> +	int sd = -1;
>> +
>>   	switch (conf->format) {
>>   	case KS_CONFIG_JSON:
>> -		if (kshark_trace_file_from_json(&file, conf->conf_doc))
>> -			kshark_open(kshark_ctx, file);
>> +		if (kshark_trace_file_from_json(&file, &name, "data",
>> +						conf->conf_doc)) {
>> +			if (strcmp(name, "top") == 0) {
> 
> Is "top" something that could be named by a user? That is, we could have a
> conflict if a buffer is called "top"?
> 
> If this is a special meaning, then we should probably make this something A
> user can not do, or even better, unlikely to have. And we shouldn't have it
> hardcoded as "top" anyway, it should be a macro.
> 
> 
> #define KERNEL_SHARK_TOP_STREAM		"/ / / __Top__ / / /"
> 
> Then everywhere use that.
> 
> Like in kshark_tep_init_input():
> 
> 	stream->name = strdup(KERNEL_SHARK_TOP_STREAM);
> 
> And also replace "top" in this code with that macro as well.

Hi Steven,

In the review of patch 13/20 you already suggested to replace the name 
"top" with a non-printable character:

const char top_name[] = { 0x1b, 0x00 }; // Non printable character
#define TOP_NAME	(char *)&top_name

This change will be included in v3.

Thanks!
Yordan


> 
> -- Steve
> 
> 
>> +				sd = kshark_open(kshark_ctx, file);
>> +			} else {
>> +				int sd_top;
>> +
>> +				sd_top = kshark_tep_find_top_stream(kshark_ctx,
>> +								    file);
>> +				if (sd_top < 0) {
>> +					/*
>> +					 * The "top" steam (buffer) has to be
>> +					 * initialized first.
>> +					 */
>> +					sd_top = kshark_open(kshark_ctx, file);
>> +				}
>> +
>> +				if (sd_top >= 0)
>> +					sd = kshark_tep_open_buffer(kshark_ctx,
>> +								    sd_top,
>> +								    name);
>> +
>> +				if (sd >= 0)
>> +				kshark_tep_handle_plugins(kshark_ctx, sd);
>> +			}
>> +		}
>> +
>> +		break;
>>   
>> +	default:
>> +		fprintf(stderr, "Document format %d not supported\n",
>> +			conf->format);
>>   		break;
>> +	}
>> +
>> +	return sd;
>> +}
