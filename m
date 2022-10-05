Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D197CC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Oct 2022 16:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiJEQHj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 12:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiJEQHi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 12:07:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC947C1AD
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 Oct 2022 09:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664986055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ixK9G8/BKQBInQHOBDYKK6bWZeNDxBVLvfPubdiw7Ng=;
        b=WR/N2PlopBoFZetgXOOL6992Km1DNXh8SGIw32+dhn+O1A/YfkMjKCHEuXEGn9A6dTXsNR
        oZalPRfsib3JqC4nzazOEtpiPaF7U+KHqHefW2CdTtNginhzyjDoAwagATN0i0f+sMxCa0
        LEp3Zgm6WviF0O4yjZVRqsyOTt9PgMU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-221-vo1fRte-PgK9nzEho4U6iQ-1; Wed, 05 Oct 2022 12:07:34 -0400
X-MC-Unique: vo1fRte-PgK9nzEho4U6iQ-1
Received: by mail-ed1-f71.google.com with SMTP id e15-20020a056402190f00b0044f41e776a0so13784186edz.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 05 Oct 2022 09:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ixK9G8/BKQBInQHOBDYKK6bWZeNDxBVLvfPubdiw7Ng=;
        b=S1prBzq1b2M1FEsOU8ucSAWBUGcWss/v1QKWuJ+Zi5hewGgpJ2NwcVooCMXQC65Oz8
         b5m7cXW2hoYV9CMg6PLE/Gu7mZoNNi4oMjOTdmfoyQKw3pTrnHozOu03xuNKNpwFa2LK
         am3tEM85GH4xqMtCkt2vN/THKXQbcoaX5Egnf3vrwUWhpGe9KNL/Ft4ZxNZ6YCl0026U
         w1WvMuW3qkVufAv6xGA1XIo6T/2LdATzujjEuBBKEGFq4Y8G78j63V7gs3Loszj9+4lm
         h/fa/FGtSFxVeRVcPJIeDvJPurbPOV+2FL/rIUKj0UywyQRbUxxV/0fVRWX21vzU4S//
         CXCw==
X-Gm-Message-State: ACrzQf3L0JqrKxf1HXCZdHYCC9oFPxyvofZbfhOefyVXfITMwvCf+JLh
        SfrjelAtj+dgJdpRz2ZXJRmEsUX/pMgTZge0THJs1TeaZbywYAha6B+OIeXy2qdDcRPbk6l/exa
        lsZNzgouulXU1rrQGu/KrY9FRoQkC+Ek=
X-Received: by 2002:a05:6402:2789:b0:451:a578:74dd with SMTP id b9-20020a056402278900b00451a57874ddmr483505ede.72.1664986052961;
        Wed, 05 Oct 2022 09:07:32 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7zTi1rH31J2weQkEkGT/VkKa/DTHz3Yx1YWDsNVWQycsCT07+leU6OXZpvh/R7epkAFzSFCQ==
X-Received: by 2002:a05:6402:2789:b0:451:a578:74dd with SMTP id b9-20020a056402278900b00451a57874ddmr483477ede.72.1664986052642;
        Wed, 05 Oct 2022 09:07:32 -0700 (PDT)
Received: from [192.168.0.198] (host-79-50-96-115.retail.telecomitalia.it. [79.50.96.115])
        by smtp.gmail.com with ESMTPSA id w23-20020a50fa97000000b00456d2721d93sm1465147edr.64.2022.10.05.09.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 09:07:32 -0700 (PDT)
Message-ID: <4e5cadcb-9e15-cc2a-db4d-8f749f654723@redhat.com>
Date:   Wed, 5 Oct 2022 18:07:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: Runtime verification for instances
To:     Joel Fernandes <joel@joelfernandes.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <CAEXW_YRUty_YEkUXwSP_v0NHb6tC_tCFavYNze5kBiAuMmKz9w@mail.gmail.com>
Content-Language: en-US
From:   Daniel Bristot de Oliveira <bristot@redhat.com>
In-Reply-To: <CAEXW_YRUty_YEkUXwSP_v0NHb6tC_tCFavYNze5kBiAuMmKz9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/3/22 22:35, Joel Fernandes wrote:
> Hi Daniel,
> I was thinking about your RV for a recent problem.
> 
> Basically, we want to check for state transitions on a per-RCU
> callback basis. For example, we want to verify that for certain types
> of RCU callback, there is no chance of a scheduler wake up happening
> (provided such wake up happens for non-hardIRQ context).

ack.

> 
> This means every RCU callback in flight needs its own automaton which
> is created when the callback is queued and destroyed when the callback
> is executed.

do you have a "structure callback?" or could attach some extra info into it?

There cannot be a single global automaton. And we have to
> make transitions for different automaton depending on their state.
> 
> I bet you have already thought of something like this for tasks where
> you need a per-task automaton instead of a global one for some use
> case which requires tracking each task separately.

Yep! we do have per task monitors (already).
 
> We can implement this in RCU itself, however it will be ugly due to
> CONFIG options. And also we cannot do it easily in production. On the
> other hand, with RV, we could simply have RV watch the tracepoints and
> verify them. It will be clean.

So, I am not sure if I got the problem here. So, you are saying that it will
be easier with RV. Right?

If you need one monitor (automata) per task, we have support for it already.
If we need "another type of object," we can add.

> 
> This is just 1 usecase (wakeup) , we also want to extend something
> like this to more things, like making sure callbacks execute in a time
> bounded fashion.


I know verifying temporal properties doesn't directly
> fall under RV,

temporal or order or temporal of time? For temporal order yep we have it (I
se an overload of this term here... haha). For time, we can add additional
structure to transform them into logical events.

-- Daniel

but hey we can extend it somehow :) . i.e. we reach the
> final state in bounded time.
> 
> Let me know your thoughts and thanks!
> 
>  - Joel
> 

