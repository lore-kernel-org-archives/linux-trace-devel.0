Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC0BC433C1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Mar 2021 17:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA4256197F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Mar 2021 17:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhCSRpL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbhCSRoz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Mar 2021 13:44:55 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2D4C06174A
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Mar 2021 10:44:54 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u9so11052374ejj.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Mar 2021 10:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Z0RfzgURa88ZTXb9rH4KuJjbgbMFAY1MjWAtgzU09u8=;
        b=agnqePuoRu5uX2RxPB55ssd+yBmXhs0mMFrhMfw4dMMr86bWSwBhF6m65wZsp3BO6I
         Xkphi1/QQqGbvJ2i0NX6bu8n7JTXiPhrJrBF3+fvjx8bTsaW6x/91d/7j3GtcRL7do7O
         J//NsG1ciLrVC3xhKx+oPVXrPBvrbH6dEUADZEF0mXAnSPkwRHM0N1oY1kT85nKGhlb2
         BD+suvUbIoV5TnSbxF6iqm6DK4RmeHbqE3+t4QcieUk7nyxk4d26yXBFZngSP0VExpUk
         xgeDhvxNCfWyap/XiX0DuMcfskqj+G8ZYc1H4/LAFlcgOSIYvPUfNtCNsjcVQRS91Vkp
         SDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Z0RfzgURa88ZTXb9rH4KuJjbgbMFAY1MjWAtgzU09u8=;
        b=mdzXv8WU6QFA54vtzD8ZYLMBBDVP5fbKgy5SdGceZxyWabbMqe6ZyHiKooQKtgtxVD
         mLPqYwqE69dFTNcONj3iKYApUXBGNGcQtOKroBrVUSeQ98G9vvklc0tbJM5IoiC7zotz
         ubKsnRAef4AJihGKDbFa8vamPp9YBZ6vRTh3XWiidXT1wnofirqlNTT4cLSkE7NN0MvZ
         nTn1SSI5xUPhaloJJwuxLodZtPltnA8P6yK2zXFhjZENRq+XFOA2MpxYzZPfb8IGvD6s
         jbLDQDcojwOu7nqTrymIJ2vZ4Uc3u+KXyNCV6mjZRs5NAZwXPvIiBK5xddV2jn8CsCEF
         jqvA==
X-Gm-Message-State: AOAM5332SkSpXk2f+clya1J3vNK4KWCKloF6sQrlm1XL0jTd8fSJkNCH
        yUsEEjUFjD4Q5tFjB3C8ydc=
X-Google-Smtp-Source: ABdhPJwfwQiMVYwl3aEEwotELmYpYqlpUDUgP1hxeHyoNviVFQ6kqhi0LQ+TEmtuBkI/Y5qaJOgrOg==
X-Received: by 2002:a17:906:948d:: with SMTP id t13mr5576069ejx.402.1616175893605;
        Fri, 19 Mar 2021 10:44:53 -0700 (PDT)
Received: from localhost.localdomain ([151.32.44.55])
        by smtp.gmail.com with ESMTPSA id cw14sm4596408edb.8.2021.03.19.10.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 10:44:53 -0700 (PDT)
Subject: Re: [PATCH v32 0/5]Timestamp synchronization of host - guest tracing
 session
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Dario Faggioli <dfaggioli@suse.com>
References: <20210315061857.168570-1-tz.stoyanov@gmail.com>
 <6796a75b-6a59-767f-08ec-ee0cbfd8c825@gmail.com>
 <CAPpZLN6LJWV_=BB5FgQOkN+SZt3dOeYjzqZVZ-FC4JTva8zn_Q@mail.gmail.com>
From:   Stefano De Venuto <stefano.devenuto99@gmail.com>
Message-ID: <80486620-fe8f-49a5-cdac-05bb2b969984@gmail.com>
Date:   Fri, 19 Mar 2021 18:44:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAPpZLN6LJWV_=BB5FgQOkN+SZt3dOeYjzqZVZ-FC4JTva8zn_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 3/19/21 12:55 PM, Tzvetomir Stoyanov wrote:
> Hi Stefano,
>
> On Fri, Mar 19, 2021 at 12:08 PM Stefano De Venuto
> <stefano.devenuto99@gmail.com> wrote:
Hi!
>> The commands used to record are:
>>
>> Host:
>> # trace-cmd record -C x86-tsc -e kvm:* -e msr:* -A tumbleweed:823 -e
>> msr:* -C x86-tsc sleep 1
> The guest trace clock is set automatically as the host, so this
> command should be enough:
> # trace-cmd record -C x86-tsc -e kvm:* -e msr:* -A tumbleweed:823 -e
> msr:*  sleep 1
>
>> Guest:
>> # echo x86-tsc > /sys/kernel/tracing/trace_clock
> There is no need to set manually the guest clock, it will be
> overwritten by trace-cmd agent.
>
Thanks so much for the proper way to do it, really appreciated.
>> If necessary, I can provide more info about my setup, or do more tests.
> Yes, please can you send me both host and guest trace files ?
Here are the trace files, host and guest respectively:

- http://xenbits.xen.org/people/dariof/tracing-examples/kvm/sync-kvmclock/trace.dat
- http://xenbits.xen.org/people/dariof/tracing-examples/kvm/sync-kvmclock/trace-tumbleweed.dat

> Also, it will be useful to send me the content of the KVM debug files:
>     /sys/kernel/debug/kvm/<guest ID>/vcpu<*>/tsc-offset
The guest has one vcpu (vcpu0) and the content of the file is:

255647917761327
>>
>> Thanks and Regards,
>>
>> Stefano
> Thanks for testing this code!
>
Thanks for your time,

Stefano
