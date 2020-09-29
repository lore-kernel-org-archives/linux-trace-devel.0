Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2A8C4727C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 14:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E14B206C1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 14:16:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V7/ekCpo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbgI2OQj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 10:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730452AbgI2OQi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 10:16:38 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9F5C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 07:16:38 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id s14so3827306pju.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 07:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sc2LxCYMt8k+YEE3tZIfmT2drN5IJvkhtZU9TEsoDHM=;
        b=V7/ekCpoDQjc6aluCzZ57rvQuBoZ9rON/epptLyjF4IUnO5kd+P/SGJIhSOCr2V0KM
         jJhVJc/7/fWGCc0J+DUfzhv7tT2xCjJi/Lw2cD77qWjkIFIguqL7F1xZIElTQ5w+qIae
         VGkbW7rwfgJdxis9NzgdOukzb6zY6KxNTEXTTcI56llCo+LbXuL/vSYW8zPigQCC9y3Q
         4/mGkQ5cNd5PB/SetTxSFUtREdPeLxxvotG0whSXUsQecQ7hua4MlgBpFI/Ul/3cdI5T
         Yzuu6k5TGy0EJ4+vC0qNslTmMZ3lkNVYydzvvopgb7hQ4M6kR98EXyN6ybI9eGXm+dBm
         aXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sc2LxCYMt8k+YEE3tZIfmT2drN5IJvkhtZU9TEsoDHM=;
        b=IwmC/0PKtSDkRk8zt2HVgUPJGkYvH2M8HH9AIjUPwPm1KZmBFjKz1JQReJNrvG2fwz
         fEcoisVBLlTa7+Z9pbdN7h6NIYV+n9t2r61sV35lGSD9nGzS4jBox/lfivKkwdrmf78/
         c3s1030I2X9OLmvW4yE5U+bTreBFpT7tk+1/R4ihCayrF6MCBL9CUf6uJo7Mi7D2x9F/
         +kMIb2H5Z9VbgPf+SUiEt56QMoFAqxwG3AuZ0DcAVMrdIH8xkimaO7t5ouBhpGsYYpX0
         4gY8qxMXPIfw+7GPv/qH9DCCsvVEDme+p8UMackvv95xNdeZCjuSd+y+oWVqfL2a9yx0
         TrBA==
X-Gm-Message-State: AOAM53119uOJBR+S/YZS6de93AumdkY78RxSOt7Op1ynAfHFO1iwrrT0
        M3VrrsHAEEkkBudmlc4b8Yk=
X-Google-Smtp-Source: ABdhPJw/vdYW9BSIg24OqagRqCK4B5g9CQsyxS5CmdLq8ncOaOiXMJFK6S9LXzXgxvVhPU85+zpObg==
X-Received: by 2002:a17:90b:617:: with SMTP id gb23mr4028910pjb.36.1601388997884;
        Tue, 29 Sep 2020 07:16:37 -0700 (PDT)
Received: from i7.zsun.org (h150-66-46-238.ablenetvps.ne.jp. [150.66.46.238])
        by smtp.gmail.com with ESMTPSA id g9sm5875853pfo.144.2020.09.29.07.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 07:16:37 -0700 (PDT)
Subject: Re: Co-existing of traceevent of trace-cmd and perf
To:     linux-trace-devel@vger.kernel.org
Cc:     tstoyanov@vmware.com, Jiri Olsa <jolsa@redhat.com>, zsun@redhat.com
References: <1baba359-fd07-1a61-0158-e65c6b06425f@gmail.com>
From:   Zamir SUN <sztsian@gmail.com>
Message-ID: <3dc91d46-e359-472b-4faf-d9b324cc4c8d@gmail.com>
Date:   Tue, 29 Sep 2020 22:16:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1baba359-fd07-1a61-0158-e65c6b06425f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 9/29/20 9:44 PM, Zamir SUN wrote:
> Hi,
> 
> I'm packaging trace-cmd 2.9 into Fedora.
> 
> Back in trace-cmd 2.8, all the plugins are under 
> $(libdir)/trace-cmd/plugins. While as of trace-cmd 2.9, I find the 
> traceevent plugins are installed in $(libdir) by default. This brings up 
> an interesting situation - the perf tool also contains a copy of the 
> traceevent in the same directory. So this means trace-cmd and perf have 
> file conflicts. In terms of packaging, this means users can only install 
> one of them, not in parallel (at least for Fedora). So I'd like to see 
> if there are existing proposals or suggestions for which one is expected 
> to be used by other utilities? Or is there any official plan to move one 
> of them to the other directory?
> 
> I'm copying Tzvetomir and Jiri as I think you're the first people for 
> getting the plugins in this directory for trace-cmd and perf respectively.
> 

Sorry, I just saw an email from Steven mentioning there will be a stand 
alone libtraceevent. However I did not find it in git.kernel.org. So I 
probably should ask if the stand alone version of libtraceevent is ready 
now?

Thanks.

> Thanks in advance.
> 

-- 
Zamir SUN
Fedora user
GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E
