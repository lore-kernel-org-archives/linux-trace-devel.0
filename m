Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FC1C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Dec 2021 19:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhLITLF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 14:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhLITLF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 14:11:05 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAFDC0617A1
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Dec 2021 11:07:31 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id v1so23038815edx.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Dec 2021 11:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PAqNlA6mk0ZwyCA31n0gC5mmavDeHU3XFE8MSF4Zvtg=;
        b=qHqd8goFUtYdWAqn0E7nNz6tjDhvqHcIV4RSLSW78zMBk5/KuNd9fUKY2Q+AjyHd7Q
         qbv2cvmFOP1a7B5cXaw42qKXm3q2PLwYGm9XFFmv8A/wWyRU1ygEZJ420ufXDv2o5MBv
         B/9ZgR8dF8aOG2a+SIuhKsefnxhAaFVWHBc4TDdAxrgKf/bNUOsSi1ZuSjqVdSwQDzIx
         q3Hrl8rqrReDLmBjsNx2e5RSShL8W1O2NezBQgYWDpHDz+oDXBeQ9tNeCq70fnpxA/iX
         qiw6FJdXH4DBDlTDwMkg88E/Idp94YF2qElioi/e5/l6amkaH0GmHAnksakBZqscmQdm
         aunA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PAqNlA6mk0ZwyCA31n0gC5mmavDeHU3XFE8MSF4Zvtg=;
        b=NtYkwqwlxF363OpnPoYNJoTTytPU19R5rrqTLaVfsrr7m/GDXmTqNN+18bj0upsk22
         RB6jNoge12hPT+hHBx4Dsk7VMC92hcmuBEJNbcBR/XpqdHX0hZahZ/yr5ZFchkjjjYkS
         i+JBa6MdS+S67V+NB8trcctg2rBaK4YEOrjCLf2fshUIwnKSu7Eft9UsxkWVR5aXAzOD
         dpvNTpie8yqSBxr7RpJj8dV4didhoJ4zFj7JcfiHKJWh4FwIDVI8kLCAODHwdFZTRflN
         DC/RBIVDNzZ+PgHZQkd4dn0F3NSR/NhukKlxZbEVndEotX+nKDEQcc0ZwIZzGG9crxY3
         dimg==
X-Gm-Message-State: AOAM531gY8UhtME5zV7dmh5qMfWa5E71EjC0fZ1KLjT3cSE6NiehPkfn
        mmXwGRx5QN8CU0ZVCeIyZZxxg1WJ3Qk=
X-Google-Smtp-Source: ABdhPJxzg8ZKNh1De2poGzZR8poMGO19pz0niwPqAKBUOVgANNTfl4Iu7bcnxp0JIbTvCQ/oubruLA==
X-Received: by 2002:a17:907:3da9:: with SMTP id he41mr17902780ejc.105.1639076849642;
        Thu, 09 Dec 2021 11:07:29 -0800 (PST)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b14sm306451edw.6.2021.12.09.11.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 11:07:29 -0800 (PST)
Message-ID: <d001cb6e-3d07-429a-148b-7d15f62ef1de@gmail.com>
Date:   Thu, 9 Dec 2021 21:07:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] libtracefs: New APIs for getting the raw format of
 synth event
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20211209163815.16769-1-y.karadz@gmail.com>
 <20211209132435.187422a8@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20211209132435.187422a8@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 9.12.21 г. 20:24 ч., Steven Rostedt wrote:
>> +/*
>> + * tracefs_synth_echo_fmt - show the raw format of a synthetic event
>> + * @seq: A trace_seq to store the format string
>> + * @synth: The synthetic event to read format from
>> + *
>> + * This shows the raw format that describes the synthetic event, including
>> + * the format of the dynamic event and the start / end histograms.
>> + *
>> + * Returns 0 on succes -1 on error.
>> + */
>> +int tracefs_synth_echo_fmt(struct trace_seq *seq, struct tracefs_synth *synth)
> 
> Sorry to nitpick on the naming again, but perhaps we should call this
> 
>    tracefs_synth_raw_fmt()
> 
> Because saying "echo_fmt" I would think it would include the "echo" command
> in the output.
> 

OK

> 
>> +{
>> +	if (!synth->dyn_event)
>> +		return -1;
>> +
>> +	trace_seq_printf(seq, "%s", synth->dyn_event->format);
>> +	trace_seq_printf(seq, "\n%s", synth->start_hist);
>> +	trace_seq_printf(seq, "\n%s", synth->end_hist);
> Hmm, shouldn't this end with a \n? Or is it to allow quoting?

The function returns string and the user is free to do anything with it. If this string ends with "\n" and you print 
this string with puts() you will get extra line (same problem printing it in Python).


Thanks!
Y.

> 
> -- Steve
> 
> 
>> +
>> +	return 0;
>> +}
>> +
