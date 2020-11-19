Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C6CC63697
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C4B3246E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:06:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t3cdKvB7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgKSQGb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 11:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727677AbgKSQGb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 11:06:31 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EE0C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 08:06:30 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id gj5so8654601ejb.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 08:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u5apOHw9y2wxKw3BQ5ln0DX+y6z6KupToTktANi2rOc=;
        b=t3cdKvB7S5We7jeLdLcm2kSKrWItxzUnhEC4ky6HxPAnuQfcpoBS2SDRuH3cSz1n9w
         W5MTa0QAhgo7JRQrxxJfw4t09QkEdw3r+q4CPin22Jq1MB02bGMNL6QSh7ZLcs0qT2PU
         NqrqpZB7r44JmMLY7Pfb1tQigdkEld/MoiFjbj3d8OLcvY+1NsZ1JPdSCQmhtM0+mBP5
         yyhinzo02+1AODOm0CkLi+1hNsNeqKrkPqAamKkR+mfwgACmg/VjIJWYUhylI9dXVlQx
         w6I18by6Gw0/Y53xnGwBqILBQeUAD38Owxu1YmmMysTf/JnB7cyJ6YBiyT0myt92X87b
         Masw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u5apOHw9y2wxKw3BQ5ln0DX+y6z6KupToTktANi2rOc=;
        b=i+C/W08+wgCzN44L1THZxT1+E9ICYQHjcEW8Kzmb/kXqGrnHwHO5BYqA4/nTPNTGrb
         iQCES+lYN9SsoULjrenJuBRVC4Yy2zLyb/C57gcIR9bTxVDkW4711s4G67AFIrecwVsB
         4hWNgJqb8UKL3urip79T8w5H0w3cC7BvWAOnJNyglluxMCAii5A9w6htbO1uv14S97aX
         5EZ/fdzbcuLYZPOEdZkPZCSTbdPwHNEcZn6uOWQiKO7G2lvaa36qNl60dgXYkTHkr+wJ
         ufCnunljT8BbMmFT/yqOGeK81diGftcc77rUgizyICuV8OQj4v2qEbN5BSV82W8S1b0G
         tNaA==
X-Gm-Message-State: AOAM530DQIiCM1EEYVxadNpzCk0RnKV7FbTGCGSQn7wPkBV/0a8GD6Xe
        Vwj0GMm8zUj3mT+5JsXa1gR9T9SI41s=
X-Google-Smtp-Source: ABdhPJwRBmc1qFrhC5ldaw06eRqR6lSrhOGXgFJ9quAbnkRurZN9kYb0grheVUcLbNqpegemctxFyQ==
X-Received: by 2002:a17:906:9609:: with SMTP id s9mr5583218ejx.473.1605801988659;
        Thu, 19 Nov 2020 08:06:28 -0800 (PST)
Received: from [192.168.0.108] ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id g25sm2650532edf.96.2020.11.19.08.06.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 08:06:28 -0800 (PST)
Subject: Re: [PATCH v4 08/20] kernel-shark: Add stream interface for trace-cmd
 data
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201118145003.156542-1-y.karadz@gmail.com>
 <20201118145003.156542-9-y.karadz@gmail.com>
 <20201118201134.267cfcfe@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <c8576d27-cbe5-2718-2328-193934747b92@gmail.com>
Date:   Thu, 19 Nov 2020 18:06:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201118201134.267cfcfe@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.11.20 г. 3:11 ч., Steven Rostedt wrote:
> On Wed, 18 Nov 2020 16:49:51 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> +static char *tepdata_get_task(struct kshark_data_stream *stream,
>> +			      const struct kshark_entry *entry)
>> +{
>> +	struct kshark_generic_stream_interface *interface = stream->interface;
>> +	const char *task;
>> +	char *buffer;
>> +	int pid;
>> +
>> +	if (!interface)
>> +		return NULL;
>> +
>> +	pid = interface->get_pid(stream, entry);
>> +	task = tep_data_comm_from_pid(kshark_get_tep(stream), pid);
> 
> 
>> +	if (asprintf(&buffer, "%s", task)  <= 0)
>> +		return NULL;
>> +
>> +	return buffer;
> 
> That's a pretty fancy way to implement:
> 
> 	return strdup(task ? : "(nil)");
> 
>   ;-)
> 
> If you wanted to show "(nil)" when task is NULL.
> 
> Otherwise, if you want to return NULL if task is NULL, then you could
> simplify it further to just:
> 
> 	return task ? strdup(task) : NULL;
> 

I am taking this one for v5.

Thanks a lot!
Yordan

> 
> -- Steve
> 
> 
>> +}
