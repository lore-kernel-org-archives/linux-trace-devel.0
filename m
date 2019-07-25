Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D71DC7618B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 13:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 506A12075E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 13:59:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6CfKaA7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404572AbfGYN7a (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 09:59:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51013 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404173AbfGYN73 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 09:59:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so45129302wml.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2019 06:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GomAvNXaBSqcVI9jRv+cjI+OEHGhyGtVJzrhf20vSj0=;
        b=j6CfKaA74GHIZXQ5e740Gz/oI/RchZ1WCDhM5g5pAEmv55iLMQH3kHIRpv0oq0ExGe
         zoVw0qLaJ4gGJg4LaHvVqIK5yO/0hPWYp/2DiNXRqgj61uaR9KpA+oorxPiS2J2f+JV6
         5jf/Wo6rLJCy+5UaeLG/zR9rveuWnn//nG0RNYXhNlDWncBP/rB9DmVRTc5B2+ZDJL4V
         I5eyDY/8bA+k0USnoMwXrudafX7cQAnZv02Lp4ecaovhM9nKss/LJ3fwaUB/Si5ilFTF
         9BMM6Hmm1wvuuBFrJ6+5vQt+WFRo9Pz45yU/21r4MV0llAglOVm5MgqGbDzmRJkp/Ge0
         F++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GomAvNXaBSqcVI9jRv+cjI+OEHGhyGtVJzrhf20vSj0=;
        b=q1MuRJpnr7TSBgXnp/f44WFA7tic0e9xGzgqNpquSJEOQG23lVrp/J7wXbMcFLrDVJ
         hQRD2W4UhR9N3cSI05r7hNtzdB1zUYkF1WCvd1VZCLM3wgn2NF+ln3NOhsoZ6/SrZMsM
         symGFlhVOa6yoRYo5lWNLowlT1AbveJOSyAwdBa2FHlqXUgr/b723O8rFAoBz4elMx+p
         0cPY9FFwxovHj7p66YocJLXxQbCzSev5ZBnmlwwFxybntt5NIFEk12w0MteLkK2rh3J+
         Ev4pAunB4Q13hse70YG5BnU9FIL0I9WjQ0ZFUjepVRiui5QXGWiN3HJ0pdL8KDHkHWV4
         qd9Q==
X-Gm-Message-State: APjAAAVMtnvWrVDMf9uIuJQ2AxGKnkVMtcso6S2+zPd6AE0IlwZ5LOgs
        SkteTlbQiuzgxn/SkD4NQxYrWSr55HQ=
X-Google-Smtp-Source: APXvYqyATemMk9iAs/OlsiTwYgAQ7EkNboRPWwJhIyOT1m58cl3DUtRfpLeL0n9tLkckitHmjqY0Gg==
X-Received: by 2002:a05:600c:212:: with SMTP id 18mr30363295wmi.88.1564063167950;
        Thu, 25 Jul 2019 06:59:27 -0700 (PDT)
Received: from [10.27.112.116] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h14sm46839430wrs.66.2019.07.25.06.59.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 06:59:27 -0700 (PDT)
Subject: Re: [PATCH 1/2] kernel-shark: Execute kshark-record from same dir as
 kshark-su-record
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20190723225044.576298160@goodmis.org>
 <20190723225238.701263380@goodmis.org>
 <f9ac2e19-cc65-6496-5c42-9668337e6506@gmail.com>
 <20190725084514.410f1cb1@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <1b5e7a79-fdaf-94f9-1727-5688c189d738@gmail.com>
Date:   Thu, 25 Jul 2019 16:59:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725084514.410f1cb1@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 25.07.19 г. 15:45 ч., Steven Rostedt wrote:
> On Thu, 25 Jul 2019 12:01:34 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
> 
>> I just realized that there is one problem with the patch. With this
>> modification, you can use only the installed version of the script (so
>> you more or less depend on PATH).
>>
>> This will work:
>>    kshark-su-record
>>
>> This will work as well:
>>    /usr/local/bin/kshark-su-record
>>
>> However this will not work:
>>    kernel-shark/bin/kshark-su-record
>>
>> because you are trying to start with pkexec an executable from your $HOME
> 
> What about this patch?
> 
> -- Steve
> 
> diff --git a/kernel-shark/bin/kshark-su-record b/kernel-shark/bin/kshark-su-record
> index 8c9fbd02a351..152d0cdff3e7 100755
> --- a/kernel-shark/bin/kshark-su-record
> +++ b/kernel-shark/bin/kshark-su-record
> @@ -6,4 +6,8 @@ then
>   fi
>   
>   THIS_DIR=`dirname $0`
> +if [ "${THIS_DIR#/}" == "${THIS_DIR}" ]
> +then
> +    THIS_DIR=`pwd`"/$THIS_DIR"
> +fi
>   pkexec env DISPLAY=${DISPLAY} ${THIS_DIR}/kshark-record -o ${PWD}/trace.dat
> 

I see that this works, however now I am really confused why it works.

I thought that pkexec will start an executable only from the path 
provided in

kernel-shark/org.freedesktop.kshark-record.policy

Thanks!
Yordan

