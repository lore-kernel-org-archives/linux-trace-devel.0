Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B6DC07E9C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62EFF61C60
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhGGNYQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 09:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhGGNYQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 09:24:16 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05534C061574
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jul 2021 06:21:35 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id v20so3214010eji.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Jul 2021 06:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hGBWL4mWrJU5yI+qVZhbEafxwqOpAKrZLpf2fbcpFbY=;
        b=r9kffW0srZUgZXjXuugpa4H/JTvv6QzirOjNL+HFJZy9ph/SqoqXJRlIgJM/qJjoQW
         1AedNdga0X8xqo+vicarV6sE63ckQXrxIc0D5pyVH588f2bVLXWq5lIrTDpX+KYxs3il
         YI5ia/BgvwxTsCS4+Nqcx3YezM4m/D2+gyAuWKArR+KwDia6ZMoZADvIeFBMeQTH2Ian
         7YmV5FiEg2botK8Wge53QLx/rQtZ2sAkwC8pTw616DlAefEOZVCGeQSLFoLdSxJYusQX
         9bBdHlMGGm0OOcXYzzLyU4Fz8Rbpk4StIBnFIePI/pOxMlMcfwEDH0cH8zY9IzX+nqEX
         P0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hGBWL4mWrJU5yI+qVZhbEafxwqOpAKrZLpf2fbcpFbY=;
        b=mK3LrDYHEgAh+Q3lk+LD3eQONzcde1S5QQqBcygsI8V7tcXgbBB1mJ/J4tby7ylDpB
         6mb0FbZjjt2YPFaNO3ww5fOYR/701um1DP//7pbiY/pWZsLYH32BvvmN3oVMWpzKD6fU
         HS1drD+QN7aRkKAgtfi8rtGCJdwbuWdn/EkbSaL7F9DKRPXSYpz5ocPeb/227nCdUwJV
         56JPt3tJURKXU0Rcq7+JvtovENS7iqeJ2nstc31EuoRWjRRthYnq5G2iLOiBm9qAuNBf
         YGYxmo8QHPUgNGfjIAvW7CrMkfrhrQVTfCpdtWSgrpI1zHTqC/mYZhc5XY6WTpcYnbmJ
         eS2g==
X-Gm-Message-State: AOAM533YTepRTF/3/SygWiLtaFD/8SZE1EK3da+6Mg2kqX8UqgzbLhG5
        B4qJ720vPACjtj1LA8tjIe0=
X-Google-Smtp-Source: ABdhPJx7FwXVL8aX7syrEo/sAFmgIvayDBQZIU+mi1pbNc71+vt3CVyEmHStc7cOopwHTTKOW/vFsw==
X-Received: by 2002:a17:906:4882:: with SMTP id v2mr24438631ejq.134.1625664093558;
        Wed, 07 Jul 2021 06:21:33 -0700 (PDT)
Received: from [192.168.0.109] ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id jx1sm7005750ejc.101.2021.07.07.06.21.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 06:21:32 -0700 (PDT)
Subject: Re: [PATCH 4/4] libtracefs: Implement API to create / modify and
 display histograms
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
References: <20210707031110.249759-1-rostedt@goodmis.org>
 <20210707031110.249759-5-rostedt@goodmis.org>
 <0707117e-119a-c7b6-ee1e-ef57e49917ad@gmail.com>
 <20210707091327.138fe95f@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <e766549f-daae-af99-8933-33eec53b97e9@gmail.com>
Date:   Wed, 7 Jul 2021 16:21:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210707091327.138fe95f@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 7.07.21 г. 16:13, Steven Rostedt wrote:
> On Wed, 7 Jul 2021 11:12:03 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> Hi Steven,
> 
>>> +
>>> +	switch (cmd) {
>>> +	case START:
>>> +		ret = tracefs_hist_start(hist);
>>> +		if (ret) {
>>> +			char *err = tracefs_error_last(instance);
>>> +			if (err)
>>> +				fprintf(stderr, "\n%s\n", err);
>>> +		}
>>> +		break;
>>> +	case PAUSE:
>>> +		ret = tracefs_hist_pause(hist);
>>> +		break;
>>> +	case CONT:
>>> +		ret = tracefs_hist_continue(hist);
>>> +		break;
>>> +	case RESET:
>>> +		ret = tracefs_hist_reset(hist);
>>> +		break;
>>> +	case DELETE:
>>> +		ret = tracefs_hist_destroy(hist);
>>> +		break;
>>> +	case SHOW: {
>>> +		char *content;
>>> +		content = tracefs_event_file_read(instance, "kmem", "kmalloc",
>>> +						  "hist", NULL);
>>
>> It looks more intuitive to have
>>
>> char *tracefs_hist_read(struct tracefs_hist *hist)
> 
> I thought a little about this, and rather have parsing of the file. We
> could always add a helper function to do this later if it is helpful,
> 
>>
>>> +		ret = content ? 0 : -1;
>>> +		if (content) {
>>> +			printf("%s\n", content);
>>> +			free(content);
>>> +		}
>>> +		break;
>>> +	}
>>> +	}
>>
>> This "switch" can move to the library as well.
>> We can have a method
>>
>> int tracefs_hist_ctrl(struct tracefs_hist *hist,
>> 		      const char *cmd,
>> 		      void *output);
>>
> 
> Both this and the read file above could be added as enhancements, but I
> don't think we need to add them to this current patch.
> 

Yes, sure.

But maybe in this case you can postpone the addition of the examples for 
another patch that is after having those enhancements.

Thanks!
Yordan


> Thanks,
> 
> -- Steve
> 
