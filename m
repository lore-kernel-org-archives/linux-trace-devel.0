Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99BCC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Dec 2021 16:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbhLIQnf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 11:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237655AbhLIQnf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 11:43:35 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733BCC061746
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Dec 2021 08:40:01 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id r25so20963975edq.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Dec 2021 08:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SgXFn9s+U5gPQxfZKeCws2l9YiGPSx0Oq3fkxMXm5us=;
        b=UQq01cn8hxjfBUq3NxQvLQVk0lQX3rGdUnsWkCz8KWCHvSKH90nFFDkCD34nYqgFXg
         FXlMDLm5iiM7snk9Si+ZWR85Xe/SsraOH41oXKGqNSfra03E77SjzDvlloodgWIrMcT0
         +CVGYN2KGishE+64/n1XyWu1Qf5PF1bfZFezukuiQUZgG2XXpCIqtpx+QlBeoKSBMQhx
         Bsv1a/hzUy70MvuIQYbTXMd63a9Wn1bwkyIznciXMs7ob835Gyqq9toj4TZuFRfuioMW
         Z07oyDqh/k28FBJciJeApdOQ8UhwPktokgc38l45qewid+2GCRnSF7N//lFi07iaXARd
         7KmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SgXFn9s+U5gPQxfZKeCws2l9YiGPSx0Oq3fkxMXm5us=;
        b=AuNR4aHChVH+r0u8r8dSOI2GtUXU6HP0HU3K0/zrSH3NK7MjXfw4f3JN3/uKTV9ZTd
         lr+70f+DaO7Ct9o6utBnP8Hu2oIxU2Jx6p8QgR+za5JrKjiOlf+mLMUh/We8iwveiqJ1
         Orrueov5q8/LWP6+i8a2OXqKAitxrR4rivqU/cEEtbE9p49nLsi+XqEZjXTwr5g19sMa
         UmpeT9ETviCp6YhJKYTrJZ7u5Mz36YyH06TwnNygBK7zskCQhWZ852fKgeXbBYxfss4B
         2jsufsuaxJvFXwvP4RXKjjPEhONEvRs8ijc2yaZQZdBVQq6zmLQk8isWvPTptJ3N1EMU
         cAfQ==
X-Gm-Message-State: AOAM5337CAOHxBNsp6NS/1LSfI1HekzD37EbOPsESKjECvrgUds67EPq
        +KBBYwFg7lGTjBI5oSqckNfHbVt8VJo=
X-Google-Smtp-Source: ABdhPJz4/Pg2HvaxiS/59y8IiOPuUBe0Er6JLvr9ACU6bCCrKALp+ti/lazTusg9LvjToTKqB8C/sg==
X-Received: by 2002:a17:906:ae83:: with SMTP id md3mr16994581ejb.31.1639067853938;
        Thu, 09 Dec 2021 08:37:33 -0800 (PST)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id y17sm165614edd.31.2021.12.09.08.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 08:37:33 -0800 (PST)
Message-ID: <3ea45513-46e4-ab90-6ebb-ad873667fbb8@gmail.com>
Date:   Thu, 9 Dec 2021 18:37:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 0/3] libtracefs: APIs for inspecting hist/synth objects
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20211209104524.5354-1-y.karadz@gmail.com>
 <20211209112320.7692ea87@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20211209112320.7692ea87@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 9.12.21 г. 18:23 ч., Steven Rostedt wrote:
> On Thu,  9 Dec 2021 12:45:21 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> Changes in v2:
>>   - Dropping patch 'libtracefs: New API for getting the raw format of a
>>     histogram'. This patch must be redesigned.
>>
>>   - Adding patch 'libtracefs: New APIs for getting the raw format of
>>     synth event'.
>>
>>   - Number of fixes suggested by Steven in his review.
>>
>>
>> Yordan Karadzhov (VMware) (3):
>>    libtracefs: Rename the 'tracefs_get_hist_*()' APIs
>>    libtracefs: Add new API for getting synth event name
> 
> I pulled in the above two patches.
> 
>>    libtracefs: New APIs for getting the raw format of synth event
> 
> You only need to resend an update to the above.

OK, thanks!
Y.

> 
> Thanks!
> 
> -- Steve
> 
>>
>>   Documentation/libtracefs-hist.txt   |  24 ++++-
>>   Documentation/libtracefs-synth2.txt |  14 ++-
>>   include/tracefs.h                   |  12 ++-
>>   src/tracefs-hist.c                  | 132 +++++++++++++++++++++++-----
>>   4 files changed, 154 insertions(+), 28 deletions(-)
>>
> 
