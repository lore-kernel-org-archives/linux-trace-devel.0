Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562C5C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 20:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 133B26137D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 20:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239295AbhDPUtR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 16:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244287AbhDPUtI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 16:49:08 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE39C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 13:48:43 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id d21so13690747edv.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 13:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K5DZGgSstw+WEXE/z2rG+DZgzQol+bEXcdiCfjOm1gE=;
        b=dUSZnIwDIF1uzUGEjZZWvRKYz6OxnDhhLVqFkDlfVenbEWQDV1DOXaM7y48wx54b0f
         c5pTKWMlp6WFJRumXv7ad1/7EJuhW0JD3WpmNseSKDd/11BTzh6SlJSXJVWm2OoILvvJ
         vQJFSMSJdyv/ImXdIETzaWzJH2tllozwyZhVsC0/NLSU4UISasHP0SvQ9iNt/ZFLX1Cn
         rolbwsdJMX2J4N9ZCfGzJqvB62AChEfr55OlKJdJbfiwIca27N24BGygT2mxtGThKR+J
         m1/DEaf6vCtV3krgPIzT2RqctEvwhfiKLXtTl825IMI+jGWsYPXAuoOOki2b1HHFYGKZ
         Ee/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K5DZGgSstw+WEXE/z2rG+DZgzQol+bEXcdiCfjOm1gE=;
        b=pbDYAXK0udMEpUvoP3IysytP7uO915P8bTnQaoh659D1vf34L8oSSopiWad/iXbPu8
         u+pHjicOkwncqgE21hjXmd2SXZvDnyVk0lwe6w4SgdqytEzLeg3rEnnUcrwNQKsZObtv
         u5v2am05Ev914m2aGRsWEEYL+KYZw8AgHU/WQetxNZEKMMr9GnhYK8ERkis2l4rJRuuh
         cl/Uq/YMZIPPE/4WAuzJcvm0fF0h/NgDMJ8aIRs4Cb1KAsHfp+KhgaSve5ov7xRGdlrL
         MX1iGKj9feFLZLEamIQfNZow1YhJwn4YlHnzEYfu0Hrq2NFKleerwMtZaXSR9lCJvlFl
         Q8yg==
X-Gm-Message-State: AOAM532CqvLkOT92KkaDlSSudVQBzUOdMUwGsmVvjOXiV2BdoIk4gYrB
        PavSrTXwv7J0Zi0CrIWDW8dYPQwrXDI=
X-Google-Smtp-Source: ABdhPJzhjVOznDG8DKfjXUez+TH0lZIjQd9+11hEY97pxAMu1bkUzJCINT9DDLygsPOh4maYDLOrEw==
X-Received: by 2002:a05:6402:1115:: with SMTP id u21mr12137913edv.383.1618606120036;
        Fri, 16 Apr 2021 13:48:40 -0700 (PDT)
Received: from [192.168.1.2] ([151.32.127.129])
        by smtp.gmail.com with ESMTPSA id s11sm6428775edt.27.2021.04.16.13.48.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 13:48:39 -0700 (PDT)
Subject: Re: [RFC] Simple tool for VMEnters/VMExits matching and trace
 validation
To:     Dario Faggioli <dfaggioli@suse.com>, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20210416164653.2949-1-stefano.devenuto99@gmail.com>
 <70d698ef3074a50576da48587aaf4ce2eea9585f.camel@suse.com>
From:   Stefano De Venuto <stefano.devenuto99@gmail.com>
Message-ID: <756cd31c-9dff-5f18-8daf-5fae5e62f947@gmail.com>
Date:   Fri, 16 Apr 2021 22:48:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <70d698ef3074a50576da48587aaf4ce2eea9585f.camel@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 4/16/21 7:47 PM, Dario Faggioli wrote:
> On Fri, 2021-04-16 at 18:46 +0200, Stefano De Venuto wrote:
>> Add a tool in examples/ that scans a merged host + guest trace and
>> search for host events that are inside a vmentry/vmexit block (and
>> vice-versa for guest events ouside the block) and report the found
>> ones.
>>
>> It can be useful as a starting point for identifying issues of for
>> checking the effectiveness of host/guest traces synchronization, or
>> even for improving the placing of the tracepoints in the kernel.
>>
>> Signed-off-by: Stefano De Venuto <stefano.devenuto99@gmail.com>
>>
> Just as an example, by using this tool we noticed that there are a
> bunch of host events that, despite happening before a VMEnter (and
> after a VMExit) were shown in the trace inside of a kvm_enter -
> kvm_exit "block".
> 
> Stefano, do you still have an example of how the trace looks like? Can
> you paste it here?
> 

Yes. An example of those events is visible in this trace:

	   trace.dat:        CPU 0/KVM-1567  [001]14320175367012: kvm_entry:            vcpu 0, rip 0xffffffff84a792b6
	   trace.dat:        CPU 0/KVM-1567  [001]14320175253942: write_msr:            c0011020, value 0
trace-tumbleweed.dat:           <idle>-0     [000]14320175283462: hrtimer_cancel:       hrtimer=0xffff9002fdc21a00
trace-tumbleweed.dat:           <idle>-0     [000]14320175291336: hrtimer_expire_entry: hrtimer=0xffff9002fdc21a00 function=tick_sched_timer now=3601121397289
trace-tumbleweed.dat:           <idle>-0     [000]14320175317345: hrtimer_expire_exit:  hrtimer=0xffff9002fdc21a00
trace-tumbleweed.dat:           <idle>-0     [000]14320175319329: hrtimer_start:        hrtimer=0xffff9002fdc21a00 function=tick_sched_timer expires=3601125253926 softexpires=3601125253926 mode=0x0
           trace.dat:        CPU 0/KVM-1567  [001]14320175331517: write_msr:            c0011020, value 40000000000000
           trace.dat:        CPU 0/KVM-1567  [001]14320175338548: kvm_wait_lapic_expire: vcpu 0: delta 534432 (late)
           trace.dat:        CPU 0/KVM-1567  [001]14320175341750: kvm_eoi:              apicid 0 vector 236
           trace.dat:        CPU 0/KVM-1567  [001]14320175343465: kvm_pv_eoi:           apicid 0 vector 236
           trace.dat:        CPU 0/KVM-1567  [001]14320175345704: kvm_exit:             vcpu 0 reason msr rip 0xffffffff84a792b4 info1 0x0000000000000001 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000

> Stefano has also already developed the attached kernel patch. Which we
> plan to submit upstream as soon as we've tested properly on Intel
> hardware as well. But that's another story (although, feel free to
> provide any feedback already, if interested).
> 
> Thanks and Regards
> 
