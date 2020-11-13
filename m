Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB27C55ABD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 15:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5922B22240
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 15:08:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVZyoUUQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgKMPIG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Nov 2020 10:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgKMPIF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 10:08:05 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8969DC0613D1
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Nov 2020 07:08:05 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id e18so11089488edy.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Nov 2020 07:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2ld8LKxqbGR1TtYlmEMIhhK8QCM+5eQu0VIAGZ5rs7Q=;
        b=AVZyoUUQCu1HEalVxC2IpM3sW++o2N47PeZ0TYgh/hQvwRODZJ6UQa3kzvvt5O/Xgr
         SSjIOvZRbs+dsDDWem33uCePrmYxmCRaX6yFd8gO5EvYeKLrdCG6kMvt4IHxZC5d0HDi
         T0rClbiV/izyb3MLArUX7ed+xUbpXNOic4aszGNDbh2g6GVZw0bIpa6tGuJ2wRDlsDUw
         KoRyxHSINg5p2v9A8ScBPlTyYOxJe9fRFb5PlnIH7s5SSl22KDB+RGnLnMEcKOeYsu9V
         7kMh9yn87zqBRcr+TAYMap/JMOLGbDbWgU8B13lVGROjpsW6QYKT0mgOPSXDeDl0DlLq
         iRbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2ld8LKxqbGR1TtYlmEMIhhK8QCM+5eQu0VIAGZ5rs7Q=;
        b=ohilHR5Ce5SW2NKhJ/2ECKUMueNNVxtRIDtyxc0d9T8mtR4j/Hw3HRgcQU245gAZm2
         W+5/LaRIDI3P3HoOuOJEebctn/OJ+32w6RyiMTcSvZ3OqztvfFTRJg7+8iCjLbIkoFKe
         aTl+nNCBIvhSUfSFye+p44n4B64mtylx75o/ilTEYYnCAA3ozefUOYx0Hs0PfW/1+rpH
         mqzxsGy/Btr3WkMQclyWNxYTEImA+l1j2BlDUeEbkbSx1h3svUzjoBWFN1O8gbsXNwxb
         obkbeXgfktN4jxUwkeigPg4cGve/FjC+nxIVBNREX6BVwnxZ3PKvSTEU4OL4LOj9So/l
         LH7g==
X-Gm-Message-State: AOAM530pht4jLb83VDmrobiGJFN6iJZWAGzg8onrfcEPG6GTKC4Wt7FA
        qAsOQrYONhC9QsH0HGTONyUpI89OLTc=
X-Google-Smtp-Source: ABdhPJzjfM8wq+u8zTxFR1wI7yWF+Q/mW+Y0wx8zfRt0/U74w3+J9yoFDNYNxS1x2o3JD2hLp/lWMQ==
X-Received: by 2002:a05:6402:114c:: with SMTP id g12mr2877116edw.167.1605280082439;
        Fri, 13 Nov 2020 07:08:02 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id y3sm3869548ejk.92.2020.11.13.07.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 07:08:01 -0800 (PST)
Subject: Re: [PATCH v3 04/20] kernel-shark: Introduce Data streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201112142358.36821-1-y.karadz@gmail.com>
 <20201112142358.36821-5-y.karadz@gmail.com>
 <20201112155051.18e226e9@gandalf.local.home>
 <164442c9-0732-2fda-d6d2-96077d6f170e@gmail.com>
 <20201113094900.594bb761@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <1c364a42-aef8-eec7-55b6-b80447d4c608@gmail.com>
Date:   Fri, 13 Nov 2020 17:08:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201113094900.594bb761@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 13.11.20 г. 16:49 ч., Steven Rostedt wrote:
> On Fri, 13 Nov 2020 15:47:04 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>>> I wonder if this should be a string value that gets registered? Otherwise
>>> we will have to be the registry of every new stream format added.
>>>
>>> This is the approach that Tzvetomir took for protocol ids, because that way
>>> we don't need to keep track of them:
>>>
>>>    https://lore.kernel.org/r/20201029111816.247241-2-tz.stoyanov@gmail.com
>>>    
>>
>> I wonder how we can avoid name collisions, especially in the case when
>> some of the data readout plugins will be proprietary.
>> Also I don't think we can expect more than a dozen of distinct data
>> formats to be supported.
> 
> A plugin would need to register a name on load. If two plugins were to
> collide, the register would fail letting the plugin know why. Then the
> plugin could retry with a different name "SCHED_TRACE2". Kind of like when
> you try to add a user name in a website, and that name already exists.
> Perhaps we shouldn't even bother with a hard coded name or ID. Perhaps
> simply ask for an id, and save it into some global variable for that code,
> and have all the checks test to make sure it matches the id that it
> received.
> 
> In any case, seeing the VMware SchedTrace there makes that stick out as a
> big RED flag to me. I don't see why kernelshark needs to have anywhere in
> its code IDs for proprietary systems. That would be NAK'd in any other open
> source project.
> 

OK, this make sense. Checking the data type will become slower, so I 
just have to be very careful and remove the type checks that are not 
absolutely necessary (mostly in patch 8/20).

Thanks a lot!
Y.


> -- Steve
> 
