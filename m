Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10266C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 12:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhLPM3E (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 07:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhLPM3D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 07:29:03 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B35DC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 04:29:03 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id j9so11787188wrc.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 04:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JAo7qvZsktmCOtTL49hESDUq5ZzXVeZVDbBRN/DTheA=;
        b=gv0z0rBQY+oRXoY6xt8C/8HrlBOvFXQj7C5cH57dAWpCBl3H6he5pYt6g1lKjcW9Xa
         GK+wUUHM0mdmZ5Ca+hwCIprW4MjTLO1zsk669S7jL0vzuKtTy0KjhB3x+3dnWrek5U1l
         nf5nLMXFxbiCsDYU0cHQZQka6un7OAkK0YdAdRXV7Z/0xxrVyvjEp0KowXr/OvUJ3apo
         e9H91wFQDtFStgOFIuMcrVM8pJmn7fj0LYw7q5owhra85HA+Z5TswVncl7v9IF0i2U5j
         N9I9ZSQ/taodRAB1CwkipSyRYWBwxnODnWM8Q3ofo18FKZb4jFeKtwnJ+Q2uEFAD2Bwa
         f1/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JAo7qvZsktmCOtTL49hESDUq5ZzXVeZVDbBRN/DTheA=;
        b=yl0Wu9A3c1KWxbYCGqIOSqX1vgXSfEwzyqcBN5h2d2hwQ9XGC4VuKtviLwX0ezyD6A
         +KXcnaA+rSjXPo6HvyTtuM6L29wXSIA9C13+wBCv7ILA7rKTo+ODVFjj+cO1OuuMvQ05
         V/uB1/p6Ltj6WkI69+5mj9f7dfqb1uCElDbrk9UOvZG40RaYxkXk58hODVdyJ+iRs0E3
         eblMzZOYRv4SvlZim3U/NmdZD0idvr9qbP5kLwtwb2QVH7L+JsszGVrgXWitIM61eJ1l
         OrbL/W6N+MBiIFO/RjhOpp6GtNsG2fU3IJgbuNBngPMzLK7tNJGC5b2G/HXejdmSWqLA
         gOWQ==
X-Gm-Message-State: AOAM532GYq5UUwIc0AaKWJHBfJGypdTeWxHvHD3nkFBMb0GMc3wHwNLg
        RgNo9UeJKo32E6+elcEcCiH926zt4ws=
X-Google-Smtp-Source: ABdhPJy9R2ylw/7oOE15CTvkmtlcyghjMtZWhdVxB91SNF07u7ALpZSOiaOCcILYXIdSnZp+M3gJWQ==
X-Received: by 2002:adf:f9cf:: with SMTP id w15mr8600373wrr.456.1639657742007;
        Thu, 16 Dec 2021 04:29:02 -0800 (PST)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id bg34sm8368024wmb.47.2021.12.16.04.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 04:29:01 -0800 (PST)
Message-ID: <9ac9a1af-6829-425a-7943-755decf7c273@gmail.com>
Date:   Thu, 16 Dec 2021 14:29:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [RFC PATCH 0/1] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch.
Content-Language: en-US
To:     Jan Kiszka <jan.kiszka@siemens.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hongzhan Chen <hongzhan.chen@intel.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Dario Faggioli <dfaggioli@suse.com>,
        giuseppe.eletto@edu.unito.it
References: <20211216021649.7273-1-hongzhan.chen@intel.com>
 <20211215220327.0daae29e@gandalf.local.home>
 <b4599ebc-7e53-9d95-32ac-448c1cac8a8a@siemens.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <b4599ebc-7e53-9d95-32ac-448c1cac8a8a@siemens.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi all,

On 16.12.21 г. 9:11 ч., Jan Kiszka wrote:
> On 16.12.21 04:03, Steven Rostedt wrote:
>> On Wed, 15 Dec 2021 21:16:48 -0500
>> Hongzhan Chen <hongzhan.chen@intel.com> wrote:
>>
>>> I do not know if this patch can be accepted in upstream from function's
>>> view because it is xenomai related which still be different from
>>> pure kernel-shark for pure linux. But it is still independent plugin
>>> which would not influence other kernel-shark's functions and the plugin
>>> would not take effect if there is no cobalt_switch_context event found
>>> in trace data.
>>
>> We are perfectly happy to accept plugins for various OSs, not just pure
>> Linux :-)
>>
> 
> We were just wondering how to handle potential (we have no concrete case
> so far) variations of trace points along releases of those "various OSs"
> best and were therefore also considering maintaining the plugin in
> lock-step with the Xenomai releases. How does KernelShark manage such cases?
> 

I am adding Dario and Giuseppe to the loop, because they may de interested in this work.

We can take the plugin upstream as long as it does not add any xenomai specific dependencies (headers or libraries).
In such case you have to guarantee a persistent commitment for co-maintaining it.
Alternatively, you can maintain the plugin in a stand alone repository. Dario and Giuseppe are doing this.

Cheers,
Yordan

> Thanks,
> Jan
> 
