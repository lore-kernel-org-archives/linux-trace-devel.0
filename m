Return-Path: <SRS0=BCkm=VO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD67FC76186
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 12:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FF4420880
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 12:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OKjBQbUi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbfGQMmh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 08:42:37 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40632 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfGQMmh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 08:42:37 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so22024103wmj.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2019 05:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V+2xLSIb1GmF7YIQygfwG32z06skwWoaqJtl+Nad2+k=;
        b=OKjBQbUif3IhqJpwjmD6eJr85UM5101zw5K+378XZPdjloGIgSFluI8BdZMSxH9RJo
         G2dKEoWMRI0mOTfuVDB0Mm/+1XcSDhMpMHsmRwaYVBxSHVBVJyNxiMfAcJQLuuPK2m8l
         zrR1b+x3LAtATkiMkOFuYHpXiJmF3+BJiikPcEl+o4GoNYMKPE3RHIzgBf7F1eCW7pgW
         /kDBjXheT4H1RazTV4e54rvLRl6c0iR9vYMIs6LPVwnzoT0LgWHjwECktDOVrdsBkr8f
         P69p0sTO4rdPTUCyaNMywQvx1Ibn84xsXzkvbGDx564bDVK2nKzgART0+Eo1BUx62XzQ
         REYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V+2xLSIb1GmF7YIQygfwG32z06skwWoaqJtl+Nad2+k=;
        b=XJe+XhyWfFGmRr2JZWwFR7JL3vefYvscSWUrcvKic3vxKmMTwt8rvrB2iVFaIO+BXv
         sSixx4sXWEUCMudYqt7YOeWfa2pITc3mmELFr8oSBXBfOs6B7JzbFWkhWgNoubIFqiVt
         dKBmnA0hIL9p24UC0nWJX0tdFFrLbgcgo49+2+3LJ/DipaRZdNuv5AOlRHR5Wm5jYALV
         9miWmM67TCsGtPrhq6IkTNJMgG0tVANu2i+T1MKtMHrmTc+ixcQU8VESThS0qFmhDSbl
         B07/qoK/cAqtwdFT2eqMXVaaME9bQI0kT3rwep4vLdrfQFwkQEy2EAtP9thsmcQDi+nG
         X+Jg==
X-Gm-Message-State: APjAAAXL75CXuqFy2AhGnkNqnU2D0q69xz5UrYtVp4dNOGY/7axwEPpj
        ZqsOKTPc5rG05b1uVFEqLC5KRWqzZrM=
X-Google-Smtp-Source: APXvYqzzJO/S4a/8hJvN32wdvQ7glafVhcyUPEwKbPvJzon5MbnTswoHTjdxNFrq6pGtOaCKL9ucjw==
X-Received: by 2002:a7b:c144:: with SMTP id z4mr38216801wmi.50.1563367354918;
        Wed, 17 Jul 2019 05:42:34 -0700 (PDT)
Received: from [10.27.112.183] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b15sm38615208wrt.77.2019.07.17.05.42.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 05:42:34 -0700 (PDT)
Subject: Re: [PATCH 1/2] kernel-shark: Initialize the data-related fields of
 the model
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20190717085306.12393-1-y.karadz@gmail.com>
 <20190717085306.12393-2-y.karadz@gmail.com>
 <20190717083709.4a56867c@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <3117115a-5468-1b26-9a89-d871f43a1289@gmail.com>
Date:   Wed, 17 Jul 2019 15:42:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190717083709.4a56867c@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 17.07.19 г. 15:37 ч., Steven Rostedt wrote:
> On Wed, 17 Jul 2019 11:53:05 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> It is particularly important to initialize to zero the "data_size" field
>> because its value is used when doing operations like scroll or zoom to
>> check if data has been loaded or not. Not having "data_size" set to zero
>> can cause segfault (as reported by Steven).
>>
>> Reported-By: Steven Rostedt (VMware) <rostedt@goodmis.org>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204195
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   kernel-shark/src/libkshark-model.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
>> index 18f9c69..fd4d876 100644
>> --- a/kernel-shark/src/libkshark-model.c
>> +++ b/kernel-shark/src/libkshark-model.c
>> @@ -36,6 +36,9 @@ void ksmodel_init(struct kshark_trace_histo *histo)
>>   	 * Initialize an empty histo. The histo will have no bins and will
>>   	 * contain no data.
>>   	 */
>> +	histo->data_size = 0;
>> +	histo->data = NULL;
>> +
>>   	histo->bin_size = 0;
>>   	histo->min = 0;
>>   	histo->max = 0;
> 
> Are we just trying to set all fields of histo to NULL or zero? If so,
> why not just do:
> 
> 	memset(histo, 0, sizeof(*histo));
> 
> ?
> 
> This will make sure ksmodel_init() zeros all of histo when/if we add new
> fields.
> 

Yes, this will do a better job.

Thanks!
Yordan


> -- Steve
> 
