Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B47C4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 00:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A2536101A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 00:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhHTA0f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 20:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbhHTA0f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 20:26:35 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60082C061575
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 17:25:58 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id l11so4966901plk.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 17:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mxrhEG4Y61otEp9NbX5lXRzPKB1bwoT0n9pAy5ppwmo=;
        b=iFGxsaQZUKj4gYIvOIRAJg6lpClsDv3pdOxjkNy0W0DYm1/PZUuEcJQswHWLjlIPwj
         dOpVlVvhUQatCq5RVR4405nv0FHr81oT2ZoZLXm/fk+aaiF3SoZQwnqvJjNHoAre5+qT
         gndvMKQlWBNW+twmzrJP33ZYnVQUlLvnKVM3f5fzTiMlQTpEY6tQ8Whtn6y7pXpqWTsU
         r0axsRsxOdJzSuXwCwdj0ce/Wo970ue6JRqq0fmyW9vV0HrWJf4dEbzhSSgm/36YmvyK
         elYDubCHCHt0LPLxUOwD24wsDpLcE993iNvumu6Avm/HoFIeYFvtvZN6gZ2vrTUBLALh
         1N2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mxrhEG4Y61otEp9NbX5lXRzPKB1bwoT0n9pAy5ppwmo=;
        b=EtfTvkhRabyS/lxQGANIruZVPVxLZkIzadukEBJ1zq+bhVdti/8YiGUb2pyOGfhe1c
         6u1ajiFIufCUW3MlmuR2oHlZHjFt0lig4582SIRuTpjVcqyL0ghygaERWD4QDq1R53Cb
         fN+OZl8Y2wEXClsFbsg+3QBFh8vjzDo/fSgjILVETt/7X8Urj/+UOKkjToGCydBwEcL4
         NlzgWUlC+oSmUpei5X+4FRGkhiuMQSybDlUDHiszG2/ojnxLvyJBO6aSOstcb04D2ftS
         RJPo1SFg3krWbZWgcoombCUqQrbgl3k01aDZoVC6rzjFBLslYjXOx8Y5hNHoRoP0sPZT
         NduA==
X-Gm-Message-State: AOAM533bdj5WhKlNMy9KTCzVQ+j7xoUAnfggzV2pC3sDwiqt3EgOFn5M
        PzRODh/rUo5Dr+pfRJ7O6ofPjMzOtz0Q0A==
X-Google-Smtp-Source: ABdhPJwp531HxAet3JwpSkWpYpjoJF8X9AqXz+mO/c1DmaayV96lDatt9C/GFqORdHvx6v43srZ5Yw==
X-Received: by 2002:a17:90a:d595:: with SMTP id v21mr1658549pju.50.1629419157446;
        Thu, 19 Aug 2021 17:25:57 -0700 (PDT)
Received: from [10.8.1.4] ([185.153.176.105])
        by smtp.gmail.com with ESMTPSA id u10sm5668976pgj.48.2021.08.19.17.25.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 17:25:56 -0700 (PDT)
Subject: Re: [PATCH v2] trace-cmd: Add dependencies to BUILDING section in
 README
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210813192516.24872-1-victorcora98@gmail.com>
 <20210819154233.3d4a75aa@oasis.local.home>
From:   Victor Cora Colombo <victorcora98@gmail.com>
Message-ID: <08e62ffe-c173-8c37-229f-39cf0977623c@gmail.com>
Date:   Thu, 19 Aug 2021 21:25:53 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210819154233.3d4a75aa@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 8/19/21 4:42 PM, Steven Rostedt wrote:
> On Fri, 13 Aug 2021 16:25:16 -0300
> victorcora98@gmail.com wrote:
> 
>> From: Victor Cora Colombo <victorcora98@gmail.com>
> 
> I finally got some time to look at this.

No problem!

> 
>>
>> KernelShark has instructions in its README on how to get necessary
>> dependencies to build it. trace-cmd could follow this example and
>> also add more information on how to build it.
>>
>> This patch adds instructions to README on how to get necessary libraries
>> and dependencies to build trace-cmd.
>>
>> Signed-off-by: Victor Cora Colombo <victorcora98@gmail.com>
>> ---
>>   README | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/README b/README
>> index 1153152..094fce1 100644
>> --- a/README
>> +++ b/README
>> @@ -24,6 +24,23 @@ Lesser General Public License 2.1 (See COPYING.LIB).
>>   
>>   BUILDING:
>>   
>> +In order to install build dependencies on Ubuntu do the following:
>> +    sudo apt-get install build-essential git pkg-config -y
>> +
>> +In order to install build dependencies on Fedora, as root do the following:
>> +    dnf install gcc make git pkg-config -y
> 
> I would actually add above libtracefs-devel and libtraceevent-devel for
> fedora, and possibly libtracefs-dev and libtraceevent-dev for ubuntu /
> debian. Oh, I would say that too, as I don't use Ubuntu thus, state "on
> Debian / Ubuntu do the following".
> 
> 
>> +
>> +To install required dependencies:
> 
> Then you can say here.
> 
> In case the distribution does not have the required libtracefs and
> libtraceevent libraries, install them manually:
> 
> Or something to that nature.
> 
> -- Steve

That is a great idea, I'll take a look at it.
Thanks again!

-- Victor

> 
> 
>> +    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
>> +    cd libtraceevent
>> +    make
>> +    sudo make install
>> +
>> +    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
>> +    cd libtracefs
>> +    make
>> +    sudo make install
>> +
>>   To make trace-cmd
>>       make
>>   
> 
