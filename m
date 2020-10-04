Return-Path: <SRS0=sBA1=DL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7A0C4727D
	for <linux-trace-devel@archiver.kernel.org>; Sun,  4 Oct 2020 07:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB531206C1
	for <linux-trace-devel@archiver.kernel.org>; Sun,  4 Oct 2020 07:09:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DJQIXK4s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgJDHJq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 4 Oct 2020 03:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDHJq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 4 Oct 2020 03:09:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EBBC0613CE
        for <linux-trace-devel@vger.kernel.org>; Sun,  4 Oct 2020 00:09:46 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id nl2so1192317pjb.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 04 Oct 2020 00:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=neJa1ShGBIQVDpEru5n8wNoR6Aswp1kb/DCpNq9I2zw=;
        b=DJQIXK4s5jZO1Op0CDE0kv7CNSl+xnPMqsq0HZ30Xwlv5ntARToXjoxpasS/76bF8N
         TVPyXTovKYAxMIm3oaL8Stdn1Tk5VJJsXIN4hmOBvfjyK78GQRatcJStfyxEpC3Jayrq
         6AcPjk2DzJuHDIWccGYvBws2vj3btdM00bDhW4oXJ/VP67jdBnvA6/YmpzmVupmlHMBJ
         t7oEl6S2dNyl1BCE68D757nsXTzd5R7g0ck73bj4fMN2yxEMyhtd3ZNveoIWChlXis1R
         XclDok40zIycw21wnXAzAtzpBIRr6sfE6+CdecA2w626x0NeNpmGJ7PVAwMxG+pqDsWH
         sWqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=neJa1ShGBIQVDpEru5n8wNoR6Aswp1kb/DCpNq9I2zw=;
        b=pu7OMVOUY9osiyaXkUk7DMEAR+ozmfG1tPlvPwTqEVXNV/Fh6CZrTRCjCfbTWYQk9T
         flqVT1JNQknxXGpE+9sogIi+uOE7HeGxZdm3bPSZ4FwtqoZN4GEaFcpwKNBmxA1M88yf
         sLBpZAs5e+vz8qy6no+jQu2J3zymImsklfbUeMI0aVoI5/NGDHGR38yHljVCMY5O62ZI
         OqhTILghBLVzOzC9upgyVCI9Ca5zOoGGlvlHFdL7zlXvnVaIXHPMFt0muJD+H0qgNzXd
         /FPLYlQDHqGmOtwa6l1eDNl8fMFukxQ5DISGTDx1JuYCTwqOopY9DWz/cfY9pUevt6Z/
         xL/Q==
X-Gm-Message-State: AOAM530v7xHryoAlJdxxjkJCahA+orbDxUcu83PffTUOazonJCy7PAt+
        gZtH+vBUk4g06hf/08mnBvAglWB8AV2Bjg==
X-Google-Smtp-Source: ABdhPJy71lwa+kOZzwe2r8NfR8D0siPTCLCW2a75qO7bHCt5xPdxxb5+rfwXclbshXmubVpeSh7pFw==
X-Received: by 2002:a17:90a:dc07:: with SMTP id i7mr10679738pjv.111.1601795385885;
        Sun, 04 Oct 2020 00:09:45 -0700 (PDT)
Received: from i7.zsun.org (h150-66-46-238.ablenetvps.ne.jp. [150.66.46.238])
        by smtp.gmail.com with ESMTPSA id j26sm7731874pfa.160.2020.10.04.00.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Oct 2020 00:09:44 -0700 (PDT)
Subject: Re: Co-existing of traceevent of trace-cmd and perf
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     linux-trace-devel@vger.kernel.org, tstoyanov@vmware.com,
        Jiri Olsa <jolsa@redhat.com>, zsun@redhat.com
References: <1baba359-fd07-1a61-0158-e65c6b06425f@gmail.com>
 <3dc91d46-e359-472b-4faf-d9b324cc4c8d@gmail.com>
 <20200930172112.qxb6shj5jkmlfpmt@altlinux.org>
From:   Zamir SUN <sztsian@gmail.com>
Message-ID: <56b36750-9c4b-375a-e21d-f3a7f27c32af@gmail.com>
Date:   Sun, 4 Oct 2020 15:09:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200930172112.qxb6shj5jkmlfpmt@altlinux.org>
Content-Type: text/plain; charset=koi8-r; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10/1/20 1:21 AM, Vitaly Chikunov wrote:
> Zamir, Steven,
> 
> On Tue, Sep 29, 2020 at 10:16:33PM +0800, Zamir SUN wrote:
>> On 9/29/20 9:44 PM, Zamir SUN wrote:
>>> I'm packaging trace-cmd 2.9 into Fedora.
>>>
>>> Back in trace-cmd 2.8, all the plugins are under
>>> $(libdir)/trace-cmd/plugins. While as of trace-cmd 2.9, I find the
>>> traceevent plugins are installed in $(libdir) by default. This brings up
>>> an interesting situation - the perf tool also contains a copy of the
>>> traceevent in the same directory. So this means trace-cmd and perf have
>>> file conflicts. In terms of packaging, this means users can only install
>>> one of them, not in parallel (at least for Fedora). So I'd like to see
>>> if there are existing proposals or suggestions for which one is expected
>>> to be used by other utilities? Or is there any official plan to move one
>>> of them to the other directory?
>>>
>>> I'm copying Tzvetomir and Jiri as I think you're the first people for
>>> getting the plugins in this directory for trace-cmd and perf
>>> respectively.
>>>
>>
>> Sorry, I just saw an email from Steven mentioning there will be a stand
>> alone libtraceevent. However I did not find it in git.kernel.org. So I
>> probably should ask if the stand alone version of libtraceevent is ready
>> now?
> 
> In anticipation of this change I temporary packaged (for ALT) traceevent
> into %_libdir while keeping traceevent form perf in %_libexecdir (for a
> backward compatibility).
> 

Hi Vitaly,

Thanks for the details. I will consider applying something similar to 
what you did for trace-cmd before the new library is being used by both 
in Fedora.

> Thanks,
> 
>>
>> Thanks.
>>
>>> Thanks in advance.
>>>
>>
>> -- 
>> Zamir SUN
>> Fedora user
>> GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E

-- 
Zamir SUN
Fedora user
GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E
