Return-Path: <SRS0=gEc1=DP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D53C04EBE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Oct 2020 07:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68F6D2087D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Oct 2020 07:17:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W1Bb6cUq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgJHHRz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Oct 2020 03:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbgJHHRx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Oct 2020 03:17:53 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C938C061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Oct 2020 00:17:53 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id k18so5359332wmj.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Oct 2020 00:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MqjN6JDRgzBg35nqqBz5xq3g/QhiHiOjtkUkRSS6sN4=;
        b=W1Bb6cUqXj+ofy8NgCZMBcaCF4TH44sOs7yQSonDq1Jph9DfU4lwkGpeT/BHi7Pxqn
         mgp+Zbg6JnnkaiNQiHiTqepB8XH5HyX+NtiC/UkeaQr6mcZTiKX4vpI8nXWJhiROD4jH
         nEiur2eenxHXyM20nZLhvLPlKYCTzBujb/0C6q7XHjfl671GtxHpeHdIWFFXFn9V6ntE
         1qgD6XlFMXaxwVH+RcYwekM27r0F+D5VBKnRPkxQQIfer7RS/NEDzxZ4zLl/QSuml1rp
         0/jbK5C8aGVxcqSLdyW/gP4GcH45uM17HqSI2d16CBY2HYfwi4I/3DFrPTjBwLH94KRS
         rang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MqjN6JDRgzBg35nqqBz5xq3g/QhiHiOjtkUkRSS6sN4=;
        b=GPCV5j6D1HZ4MXM8hdK0DROR9fvQHNgZPov3pP/52xfmlXtBVsBF7Z8AXKXr9fw4dT
         B5dnMiFcO1GocBUvE0GPmPMXo5qK6RUPZA+VNf9ry0hRDn+RMl1y1/phc93ARCZSrtiY
         KVW2ySIXLZx3mBhFufH6ZJMj+txb2KzsdZf10HjXIaeI3TzvYsUVFw/op1S7Xjp7pHXa
         k5Y81X3iqxhl2hQmW28kV6RHjnuDactcun74owLpH7Im0bJRnlIpdlh6Ioh4ybH9gadt
         FP2n3weu4GvoH4dy4nHectw4tpHPy8qdOBpu0eGqkmuvmJJ6TTtWwoWYHLZ2lgCM6dt5
         yGpA==
X-Gm-Message-State: AOAM530OVsfXx7Tym18y9HZHRhEucUnpsPnEIXLUDBbMz/yfuHXWV37q
        B9gShHJpXdQIIWk/8vhqYXfAHBRbAyU=
X-Google-Smtp-Source: ABdhPJy3EK2nkdqNqKkphG3fyGUH6luBTtmiZt2MuhiRkHarlgn7NfCteIXI1/qA/eexJoWlVwMkpQ==
X-Received: by 2002:a05:600c:1081:: with SMTP id e1mr7554283wmd.156.1602141471976;
        Thu, 08 Oct 2020 00:17:51 -0700 (PDT)
Received: from [192.168.0.108] ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id a3sm5493789wmb.46.2020.10.08.00.17.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 00:17:51 -0700 (PDT)
Subject: Re: [PATCH 08/15] kernel-shark: Integrate the stream definitions with
 the C API
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20200929134123.178688-1-y.karadz@gmail.com>
 <20200929134123.178688-9-y.karadz@gmail.com>
 <20201007161226.6e1da22e@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <cf2cab03-6797-52d6-e866-5acf8cd99ee6@gmail.com>
Date:   Thu, 8 Oct 2020 10:17:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201007161226.6e1da22e@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On 7.10.20 г. 23:12 ч., Steven Rostedt wrote:
> 
> I didn't apply the first patch, and nothing broke up until this patch.
> 
> On Tue, 29 Sep 2020 16:41:16 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> Unfortunately this integration can only happen in a single change,
>> which results into one huge patch, that may be hard to review. In
>> this patch we modify the API itself plus the two most basic examples
>> demonstrating how to use it. The most noticeable change that this
>> new version of the API brings is that the processing of the
>> trace-cmd/Ftrace data is wrapped inside the dedicated implementation
>> of the Data stream interface and no trace-cmd definitions are leaking
>> outside of src/libkshark-tepdata.c.
> 
> I find it hard to believe that we can't break this up more.
> 
> Can you tell me what the old API did and what the new API does. I can
> probably help out in taking steps to go from one to the other. But I don't
> understand what exactly is changing without spending several days staring
> at this code.

The essence of the change is that in the API we are not allowed to 
include any trace-cmd header files. And because we have been using 
trace-cmd definitions and methods everywhere, once we remove the header 
inclusion everything breaks. The only place that is allowed to include 
trace-cmd stuff is the implementation of the readout interface for 
trace-cmd data (src/libkshark-tepdata.c).

I understand that the approach I am taking with the introduction of the 
regression is against all rules and is a BIG compromise. This is the 
reason why I wanted to keep at least the two very basic example 
applications functional during the change. Of course we can further 
break this huge and ugly change into smaller changes that have better 
logical connection, but in such a case it will be very very hard to keep 
the examples functional during those changes.

Thanks!
Yordan

> 
> -- Steve
> 
