Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F23C4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DCA16104F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Aug 2021 02:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238396AbhHMCsG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238357AbhHMCsG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 22:48:06 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EEAC061756
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 19:47:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so13958276pjb.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Aug 2021 19:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ey5g4Sbja1WQRuNV6Tk9wzsg2+fL/wLDKsNpT0+8y2U=;
        b=Xh9jIa3WUYXfUl4tfPQQjkbJp/KlLDpphJ0otSH0GyIe+5fepeT25UqgGpabiKpTpR
         RHI4GP0DWYmRTRcjLPVNfAM0hDPJSh31qccH/Xtu2TqGimhFAw1u2YM0woqKqLKn22KH
         4sFNbEDzHnHGrfmd4RnZKK7ZCEqA62WBzcNWPhIuHLygQYGmdZvt+f3vFo+FiGeF+ioJ
         3A2wZ0SXPHbuikUgUzW77ELG3xQX6FWLxayL7BfiXFYtcamBMfsKB4tXBx79U3x5SeyT
         +qfyEWDS/jD1PzN3F7E0P6serBwjFDltDR83s+rr2VW2rKBSPoHZ02Znoqqqfgbqa12y
         Z1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ey5g4Sbja1WQRuNV6Tk9wzsg2+fL/wLDKsNpT0+8y2U=;
        b=HPedA2J9IQDadZHXkWwjK17MW27IeudyfXU/c50d9gVg3cVzSYXrK8fD1eqIjtYXni
         uu+TmbaS0U44QJq7oIeXhKExdjQd17TNTzA8eg1rFuY8DUR0Mk+vbWdtdDp+jddKKSGS
         /jlZmNL8Bs/CK/MsxBGkL1ofN/SgM6xTB7yQwnn9Laux+MAnW4Ck4KN9EWirIOtjt9QG
         VqvxYZOxeflIve51tnGRr9/dmvkWBrgQQhNRUrQ4syj739PGF230kF4WcvVloQCH5erl
         Vx4qrtMzHha5FO+Z4bMw/daM6wMSZ2/06jatukKXC8MPgzvq+v3cCLR41kHX8JSnTCX+
         tL9w==
X-Gm-Message-State: AOAM533MSqgjJtZ0kzPisZNwO+Edc2h8TNAjqyAjN1z1YqYpOL0jedJV
        BWEudLbd2CSQhGvvIkQev/e/WJJ9/mfEIg==
X-Google-Smtp-Source: ABdhPJw1u8KBg8VK3l4xyvaeO6HLfEULDVLQJRXa3e2vRJj4n1cxm5nMP/bUA0vjjaCY/YqkpTYVaA==
X-Received: by 2002:a65:67d7:: with SMTP id b23mr198852pgs.356.1628822859562;
        Thu, 12 Aug 2021 19:47:39 -0700 (PDT)
Received: from [10.8.2.4] ([185.153.176.156])
        by smtp.gmail.com with ESMTPSA id 143sm148195pfx.1.2021.08.12.19.47.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 19:47:39 -0700 (PDT)
Subject: Re: [PATCH] trace-cmd: Add dependencies to BUILDING section in README
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210812223353.28135-1-victorcora98@gmail.com>
 <20210812222334.4d486f21@oasis.local.home>
From:   Victor Cora Colombo <victorcora98@gmail.com>
Message-ID: <cb3277bd-ef1a-8172-6f9e-809395578441@gmail.com>
Date:   Thu, 12 Aug 2021 23:47:36 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812222334.4d486f21@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 8/12/21 11:23 PM, Steven Rostedt wrote:
> On Thu, 12 Aug 2021 19:33:53 -0300
> victorcora98@gmail.com wrote:
> 
>> From: Victor Cora Colombo <victorcora98@gmail.com>
>>
>> KernelShark has instructions in its README on how to get necessary
>> dependencies to build it. trace-cmd could follow this example and
>> also add more information on how to build it.
>>
>> This patch adds instructions to README on how to get necessary libraries
>> and dependencies to build trace-cmd.
> 
> Thanks for sending this.
> 
>>
>> Signed-off-by: Victor Cora Colombo <victorcora98@gmail.com>
>> ---
>>   README | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/README b/README
>> index 1153152..16aedac 100644
>> --- a/README
>> +++ b/README
>> @@ -24,6 +24,20 @@ Lesser General Public License 2.1 (See COPYING.LIB).
>>   
>>   BUILDING:
>>   
>> +In order to install build dependencies on Ubuntu do the following:
>> +    sudo apt-get install build-essential git pkg-config bison flex -y
> 
> Note, once the libtracefs settles down, I plan on committing the files
> that are generated by bison and flex, so it shouldn't be a requirement
> once libtracefs 1.3 is officially released. That is, because the files
> generated by flex and bison will be included in the repository, you do
> not need to include bison or flex to build it. Unless you plan on
> modifying the bison and flex source files.
> 
> Also, can we have a Fedora version? If you don't know what that is, I
> could come up with the equivalents.
> 
> -- Steve
> 

Hello Steve, thanks for your kind reply.

I will come up with a Fedora version and send the updated patch tomorrow.
Also, given what you said, I think it is better then to remove bison and 
flex from this patch, and I will also do this when I send the updated patch.

Best regards,

-- Victor

> 
>> +
>> +To install required dependencies:
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
