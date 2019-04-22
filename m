Return-Path: <SRS0=qNMP=SY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C19C282E1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 12:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07DD22087E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 12:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NSUkQ9N8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfDVMVK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 08:21:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55452 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfDVMVK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 08:21:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id o25so14224808wmf.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Apr 2019 05:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vK/EqmZPx0i//MWPjU+94KyfF9mvfipJAvLfQr7hjBM=;
        b=NSUkQ9N80W0uJpnZOITC1P7ekYVJ8dDoinarFM9A5H2V04zd9nMl1AC7P8iFAUV4PK
         Yn0aulgonO50lquWeFpVIpDZEcLIaX5pnJVL48RxMxcXtxEX9yzM6UNSQoxa+bdMkpo3
         g81hgnXpET1GZNYJVIO8wyxSCWIbwTcpnjPAp45dYE9zBgJhpQ6YiLouAXq1EecyNNY/
         2sY1DVEAIN31ZebDBK3VkTM5gRp928DvY9C8oK4Z93znRlAoWVPj3CwmOqeRswQkfQ8i
         ESG+1f7iEfNQllk7xI8W9wrJ+ut2cr/2U4VZASkRmHUMNaDIE2Rt0bc9hmc1HCTAQ60X
         y2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vK/EqmZPx0i//MWPjU+94KyfF9mvfipJAvLfQr7hjBM=;
        b=K714/7Yjm/doDwLI+kPmmOG2Px3roiqUtOyITbhDLd8foeF0A8LLdXMvosElSyEHXy
         MYh/IoqM2R3y3Y6IiLmZkX2Y3gpQ+e/p3WUYV/6p8BRD9zyZaIExI/yKCYKG5zvD5WDb
         tJN2VTNArP3Q8K/e3DTedFy9vfszRK+xmh/kr81kYmEI0CMDNPHDxTDCc1I8j8gDJM5Z
         pT/IbNDgrvj4mks7Sn+6Oa3m+uy0v2WJUEbczlFbhdxw8I1qzr5reBw46XMk8d8R9sSo
         CD6WGGxtMcbu+Jve3wFzhVmhmK4UPjulqwqNEcMAb4sM1JHhV2T9xgB8XnVTk3cFfC4P
         b3qw==
X-Gm-Message-State: APjAAAVV7HjmwjNOSRU/qzAIbiyq2mSSMA52EKQe+meDKHBHRdO/Wfw0
        ZfhbSRhRMfJpMOHGSxjhei8Zy1CN
X-Google-Smtp-Source: APXvYqwAh4UEhm0krQ9DKUMbznzgTbGLnYZBExSs7WOmlMnVDF9QS4qtPNctgaga44H53Ugw8rFQyw==
X-Received: by 2002:a7b:c4d5:: with SMTP id g21mr11113956wmk.133.1555935668559;
        Mon, 22 Apr 2019 05:21:08 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g6sm12826519wro.73.2019.04.22.05.21.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Apr 2019 05:21:07 -0700 (PDT)
Subject: Re: [PATCH v3 4/8] kernel-shark: Add logic for the plugins search
 path
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
References: <20190419135036.19340-1-ykaradzhov@vmware.com>
 <20190419135036.19340-5-ykaradzhov@vmware.com>
 <20190419132815.2820b6af@gandalf.local.home>
 <06f28287-93ee-ffc9-3603-3b67c8e1aa24@gmail.com>
 <20190422075029.232f9b64@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <df7b14d8-3c31-0b7d-90c3-47a788e9e30d@gmail.com>
Date:   Mon, 22 Apr 2019 15:21:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190422075029.232f9b64@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 22.04.19 г. 14:50 ч., Steven Rostedt wrote:
> On Mon, 22 Apr 2019 14:29:49 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
> 
>>> I was hoping to test:
>>>
>>> 	string = cmdline_path() + "../../kernel-shark/lib/";
>>>
>>> If that exists, then we know that we are in the source directory.
>>
>> I don't thing this is a good idea. If we search for plugins in a path
>> that is defined like this:
>>    cmdline_path() + "/something/hard/coded/lib/"
> 
> Your missing the "../.." part.
> 
>>
>> Then the GUI will do one thing when started like this:
>> ./kernelshark
>>
>> and anther thing when started like this:
>> bin/kernelshark
> 
> No it shouldn't, unless you moved the binary.
> 
> I said to add "../../plugins" to the path that the kernelshark binary
> is executed from. If you were to move kernelshark, then yes. it would
> not longer give you the same result.
> 
> If the binary is in:
> 
>   kernelshark/bin/kernelshark
> 
> and you ran it as: kernelshark/bin/kernelshark using the path
> "kernelshark/bin" and adding "../lib" would give you "kernelshark/lib"
> directory.
> 
>   "kernelshark/bin/../lib" == "kernelshark/lib"
> 
> Also, if you were to cd to kernelshark and run
> 
>   "bin/kernelshark" the path would be "bin/../lib" which would be
>   equal to  "lib" and being in the kernelshark directory, would
>   give you the plugins directory that is the same as the previous command.
> 
> If you cd to kernelshark/bin and ran "./kernelshark" we would then use
> "./../lib" which is the same as "../lib" which is still the same path
> as the other two.
> 
> But last call we discussed a way to find the full path name of the
> binary being executed. And if that's the case, we could not only add
> "../lib" we could also check that the binary being executed is also in
> a "kernelshark/bin" first.
> 

OK, now I think I understand what you want.
Thanks!
Yordan


>>
>> and this can be very surprising behavior for the user
>>
>> The other solution has it own weaknesses, but at least it sounds like a
>> simple rule: "If you want to use the compiled version of the plugins you
>> have to start the GUI from the source code directory used to build.
>> Otherwise the installed version of the plugins will be used."
> 
> Building from source, then moving that source tree to another path
> shouldn't cause the binary to act differently.
> 
> -- Steve
> 
