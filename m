Return-Path: <SRS0=Hh4L=U2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702BFC48BD6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43B3020B1F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:40:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kPc59IDW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfF0Pkc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 11:40:32 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34555 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfF0Pkb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 11:40:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id k11so3142785wrl.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jun 2019 08:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kFgCkpfWWdandTDIuDD8UoOHFBQMxYvTAVvF6u9wVqU=;
        b=kPc59IDWF4m+rqHJGpOEFPnfrkVDmWUjU7lFBhcY+knZUEi73fkrJCZrUNkK5x3Vnw
         WtWiHcLYCVCGkCBc4B7SSOG0JWVT24chJ/L0Qg4L0KlbTXu+d9d8blPE4SDbHURVqg/d
         vzLa7AnZ1lT2xZANcbRO/W8ARqZjLWOh78AlkFg97QqM/RPFik5wNVb4WIzS+1+e6U6L
         e/RvyjXk9+pdCe3JtxyQQpQZU7eszhCuloru0BDG8Ioq9DWMqUW/mki7aYVWzmlXWn5I
         zhJUWqEj9NkCzGwzaucSY33kHyWk6GhxQdmhUaPtSNM9GwqvC21UDBKfzYFPYXEE0bFF
         B8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kFgCkpfWWdandTDIuDD8UoOHFBQMxYvTAVvF6u9wVqU=;
        b=uRGOK7lzlXu2/X9K+TkrtW8jNqRwNOpOQ+coJ4gQHABhEvzxXn/OrYVxRe83mliQMu
         z7orLIGfY3hBfETlA+QB8xxMPLLhMQxEUB1ltKPOtansPp0HiRlIah5VaKBc7QlGo59r
         Du+moLjIGbjoFZo42q+CvXc5Yic4dnDgG91q72TJAHN3tFawPA1W01cf9Tna1KWcCXtj
         TUcffLaiMoFxmTgOYE9OFKkx+E/0QzRWu+rXzWpFWXxaYT0+FFx+NrJSulE+juUXC5Da
         5o4EK+ZmAKeVe2myj2DV2NqNm+G68AG758sI7uWIgb4MYXHdw7KzQF00n8+YlQQKVKaH
         D7Sw==
X-Gm-Message-State: APjAAAWwhxEyfziP3+tvwzH2nOQZTIQXFTh+ld9hOvztPL4RE1Fs4+Pp
        sMigSaeXpDXpwEzoKNS4mn2NQN3BID4=
X-Google-Smtp-Source: APXvYqwJGvU/m3+rj99/1fZm2eG4TNXsys9QCcgb+F6p1/dCXRFmfvHAmb4ULO1LUsL6cIVTgalFvA==
X-Received: by 2002:a5d:6583:: with SMTP id q3mr4160247wru.184.1561650029328;
        Thu, 27 Jun 2019 08:40:29 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c4sm3031178wrt.86.2019.06.27.08.40.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 08:40:28 -0700 (PDT)
Subject: Re: [PATCH] trace-cmd: remove ununsed knuth_hash*() routines
To:     Steven Rostedt <rostedt@goodmis.org>,
        Greg Thelen <gthelen@google.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20190626060101.220607-1-gthelen@google.com>
 <20190626153401.645b1174@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <550e11ae-1ac1-dbee-e88b-e62f63a6d032@gmail.com>
Date:   Thu, 27 Jun 2019 18:40:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190626153401.645b1174@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 26.06.19 г. 22:34 ч., Steven Rostedt wrote:
> On Tue, 25 Jun 2019 23:01:01 -0700
> Greg Thelen <gthelen@google.com> wrote:
> 
>> Neither knuth_hash16() nor knuth_hash() are used.
>> Delete them.
>>
> 
> Yordan,
> 
> Do you foresee that we will be using the other two versions of the hash?
> 
> -- Steve
> 

Hi Greg,

Thanks for the fix!

I agree that we have to remove the unused hashing functions, but may I 
ask you to do a little bit of extra work here.
I think that if we are going to keep only one hashing function this 
function can be called simply knuth_has (not knuth_has8).

Also the comment on top which refers to the TAOCP book must be modified 
stating that the original idea from the book (32 bit hash) was adapted 
in order to be used for small tables.

cheers,
Yordan


PS: I just saw couple of new patches coming from you and I want to say 
that your help is more than welcome.



>> Signed-off-by: Greg Thelen <gthelen@google.com>
>> ---
>>   lib/trace-cmd/trace-filter-hash.c | 20 --------------------
>>   1 file changed, 20 deletions(-)
>>
>> diff --git a/lib/trace-cmd/trace-filter-hash.c b/lib/trace-cmd/trace-filter-hash.c
>> index 39b28790e0bc..c56628f69ff0 100644
>> --- a/lib/trace-cmd/trace-filter-hash.c
>> +++ b/lib/trace-cmd/trace-filter-hash.c
>> @@ -29,26 +29,6 @@ static inline uint8_t knuth_hash8(uint32_t val)
>>   	return UINT8_C(val) * UINT8_C(157);
>>   }
>>   
>> -static inline uint16_t knuth_hash16(uint32_t val)
>> -{
>> -	/*
>> -	 * Multiplicative hashing function.
>> -	 * Multiplication by the Prime number, closest to the golden
>> -	 * ratio of 2^16.
>> -	 */
>> -	return UINT16_C(val) * UINT16_C(40507);
>> -}
>> -
>> -static inline uint32_t knuth_hash(uint32_t val)
>> -{
>> -	/*
>> -	 * Multiplicative hashing function.
>> -	 * Multiplication by the Prime number, closest to the golden
>> -	 * ratio of 2^32.
>> -	 */
>> -	return val * UINT32_C(2654435761);
>> -}
>> -
>>   struct tracecmd_filter_id_item *
>>   tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id)
>>   {
> 
