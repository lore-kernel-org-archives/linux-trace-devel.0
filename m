Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C645C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Oct 2022 17:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiJKRBw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Oct 2022 13:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiJKRBs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Oct 2022 13:01:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2812766849
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Oct 2022 10:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665507703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1O8TG0lTbu/4liCOrfuaFFh3Fiwnr0eW5JxSfEvkXxQ=;
        b=GMZ59/zClFF6Zpzj/yjwq+0+q+5gxId0GJ8obe+MmeWduHP20pgbJIxFptH53uwr9CL1T2
        +8Ef4s31ICIF+6nqRoSF3JnYlzvyXD+xl2w/UPlvswz+6UYJSHI02XCJX6asqfSPiimASb
        nFcG4UIbQqAMhpSMlyDaPrsiOBIEnMU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-83-HhQ1FC_VNiqTF32mx7wE3A-1; Tue, 11 Oct 2022 13:01:42 -0400
X-MC-Unique: HhQ1FC_VNiqTF32mx7wE3A-1
Received: by mail-ej1-f70.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso6215746ejb.14
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Oct 2022 10:01:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1O8TG0lTbu/4liCOrfuaFFh3Fiwnr0eW5JxSfEvkXxQ=;
        b=GRcBk73G48x16ldUJN6g8wQyl6xkEgMSFzBGAk1IUC/6MNVmI5/PaBIQ6PrLQztER6
         xTxaZx6rLS8F861wk7I5ssMUDUfyjVZIUQE+XdNvzoFZxaObNQ9cUGmNTiJ1OAmlzHGr
         jPQVpIp/gEbHJb/Rl5HPkg2EVtCJTKZM0iqY/t2w+CMUQLR85nOxKeIjg97JIqssa3Ym
         4yFJIEDgRrpT01mCEgk+iuZcRcI+8XFk3GxlZCuoc1C8KP0HAX0URYQbNHhijsXbwVwI
         BVm2oW/pzTn5xCI1m9qm01DOSuNFI4u7FfkXt1BJaV2LRKozSN2bWdbzyqCuB5WVJQ+l
         phLg==
X-Gm-Message-State: ACrzQf0t0Lso/pMocZs94P1YIeIEhYt0CeYsOnJG6ixSdV8VyFJk+tJ8
        0RX8yhyVv5RIHOdSyxYSTP3eJV6b+TH+ZFFAUQmVIZrGiqePCjudAdhdgJ9KZtBMgAewcp348KG
        ehf7SI+ttLQ58eODtpmYSYLt3CkTHJfI=
X-Received: by 2002:a05:6402:550e:b0:456:f79f:2bed with SMTP id fi14-20020a056402550e00b00456f79f2bedmr24040742edb.106.1665507701342;
        Tue, 11 Oct 2022 10:01:41 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5wBQuWK9rhf46PqhVbEHV45uZgcmUwMFMIClO6j1lChKv7FAx2AIwJ7J/EIK0XM60JOK4BAA==
X-Received: by 2002:a05:6402:550e:b0:456:f79f:2bed with SMTP id fi14-20020a056402550e00b00456f79f2bedmr24040724edb.106.1665507701070;
        Tue, 11 Oct 2022 10:01:41 -0700 (PDT)
Received: from [192.168.0.198] (host-79-47-205-133.retail.telecomitalia.it. [79.47.205.133])
        by smtp.gmail.com with ESMTPSA id lt2-20020a170906fa8200b00779cde476e4sm7355ejb.62.2022.10.11.10.01.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 10:01:40 -0700 (PDT)
Message-ID: <51ed39ae-92c9-bc41-4ad4-05e4568b74b6@redhat.com>
Date:   Tue, 11 Oct 2022 19:01:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: Runtime verification for instances
Content-Language: en-US
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <CAEXW_YRUty_YEkUXwSP_v0NHb6tC_tCFavYNze5kBiAuMmKz9w@mail.gmail.com>
 <4e5cadcb-9e15-cc2a-db4d-8f749f654723@redhat.com>
 <CAEXW_YQvdFFhWvLcy46UhjkCwv4cYQ23Z-Mk0v_RGD=+aWD53A@mail.gmail.com>
From:   Daniel Bristot de Oliveira <bristot@redhat.com>
In-Reply-To: <CAEXW_YQvdFFhWvLcy46UhjkCwv4cYQ23Z-Mk0v_RGD=+aWD53A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/6/22 20:57, Joel Fernandes wrote:
> On Wed, Oct 5, 2022 at 12:07 PM Daniel Bristot de Oliveira
> <bristot@redhat.com> wrote:
>>
>> On 10/3/22 22:35, Joel Fernandes wrote:
>>> Hi Daniel,
>>> I was thinking about your RV for a recent problem.
>>>
>>> Basically, we want to check for state transitions on a per-RCU
>>> callback basis. For example, we want to verify that for certain types
>>> of RCU callback, there is no chance of a scheduler wake up happening
>>> (provided such wake up happens for non-hardIRQ context).
>>
>> ack.
>>
>>>
>>> This means every RCU callback in flight needs its own automaton which
>>> is created when the callback is queued and destroyed when the callback
>>> is executed.
>>
>> do you have a "structure callback?" or could attach some extra info into it?
> 
> Unfortunately no, we have rcu_head but the idea is to do this without
> having to grow it.  In theory, you can do this with a hashtable
> maintained by RV and use the callback function as key, with value
> being automata.

right, a global hash table? per-cpu? per task?

>> There cannot be a single global automaton. And we have to
>>> make transitions for different automaton depending on their state.
>>>
>>> I bet you have already thought of something like this for tasks where
>>> you need a per-task automaton instead of a global one for some use
>>> case which requires tracking each task separately.
>>
>> Yep! we do have per task monitors (already).
> 
> Nice. This depends on growing task_struct though right?

We have it there already. If we need a per-task "aux" data we can justify adding
a pointer to a priv data. Note that I was already foreseeing this.

For example I will likely use it to monitor sched deadline tasks (I need
additional data to track the task from the monitor point of view).

Note that this will be available for *any* monitor so, not something
only for your use-case.

>>> We can implement this in RCU itself, however it will be ugly due to
>>> CONFIG options. And also we cannot do it easily in production. On the
>>> other hand, with RV, we could simply have RV watch the tracepoints and
>>> verify them. It will be clean.
>>
>> So, I am not sure if I got the problem here. So, you are saying that it will
>> be easier with RV. Right?
>>
>> If you need one monitor (automata) per task, we have support for it already.
>> If we need "another type of object," we can add.
> 
> Yeah I was hoping that with RV, you could already allocate a new
> automata dynamically or something for a new task/callback/whatever,
> and then drive that automata using tracepoints. So RV can be a nice
> place to do this kind of stuff, without adding debugging code to other
> subsystems.

We can make a dynamic as well, as long as you can allocate memory in the point where
you identify a new "instance," it would work.

Monitors are pretty self-contained, they can do their magic.

We can figure out a possible way.

>>> This is just 1 usecase (wakeup) , we also want to extend something
>>> like this to more things, like making sure callbacks execute in a time
>>> bounded fashion.
>>
>>
>> I know verifying temporal properties doesn't directly
>>> fall under RV,
>>
>> temporal or order or temporal of time? For temporal order yep we have it (I
>> se an overload of this term here... haha). For time, we can add additional
>> structure to transform them into logical events.
> 
> Yes, sorry I mean time. So time from when callback queued to when it
> is invoked falls within a bounded time period.
> 
> But more urgently what we need is:
> 
> For a certain type of callback that is invoked, check if the callback
> does a scheduler wake up. That is - doing a wake up when this type of
> callback is called is a BAD state.
> 
> This can be done purely using tracepoints:
> - We have to add a new tracepoint to call_rcu() for the new callback
> type (the type being Lazy).
> - We have to add a new tracepoint for when callback invocation ends
> (for invocation start, we already have trace_rcu_invoke_callback).
> 
> Then hook up RV to all of these, and verify that no scheduler_wakeup
> can happen during the invocation of a Lazy callback. But it has to be
> done on a per-callback basis.

So, let me see if I understood:

You have a Lazy callback, and you know it is lazy only at the call_rcu time.

Then when you start running the callback:
	no wakeup if it is of the type lazy
until you finish the execution?

> On the other hand, we can simplify it to a single automata by setting
> a per-cpu state for whenever a Lazy callback is invoked. But the
> problem is we have no idea that a callback is lazy when we are
> invoking it.

Wouldn't a global hash help for this?

per-cpu monitor + a global structure that is feed at call_rcu time?

> Thanks.
> 

