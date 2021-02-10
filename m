Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06B2C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 15:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 644C164E0B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 15:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhBJPsH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 10:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhBJPr7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 10:47:59 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F83C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Feb 2021 07:47:19 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id bl23so5054330ejb.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Feb 2021 07:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1PP5sqUGj0s891oDCrPCVRXq4i/mWQrbDliMv/tbwiI=;
        b=LZHeTGFIgrlyr1EVZRQ1yE/CLXCo7l1DCWW6s6/VlhCSneXE7jXDD8cuJ5yqHH0gMX
         OEfQA71dMKbn7kg6T9fUfIXRd1gFu0iKxsQH0XnouRTKPRwF9Zf0kgzTLNN2/OVtyq6e
         Ct0myy+Rprdgcpp4bsOLmLun22rRyvnEKkowkClvm4Ha4z0rCjp5y3lvEZPRln+7XqCw
         t14uDlFGG5HQNRHwNb0PcxyeLw9b0HtQEUUO4uGoCvUim3BM1Qlv75Xr2MSVC1CvB1qW
         w6bLEH8HMxcz5elnY8dGvKCCP3KI/gXRQHkIeAyElz7F6bkyk2zB1Fr5WHzzkrAAu+wd
         efbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1PP5sqUGj0s891oDCrPCVRXq4i/mWQrbDliMv/tbwiI=;
        b=VKOiCAXOwoPW5nfh9wRQ9Xooqe7rtnUcBuODcDX059OqpYR+YoVLt9iL3Iu92gc9C5
         TFNey1BamRq2tDK0D0FKzIdVKtmanObqw0GXJbyWD3lX1xuDJrzZieJXTJ4iSH3feLlT
         Br2+c90OTfOsMWin4su0MG4VG1gy6xiq7QjuSeBBXgJS8xnV7gWEEqTk0FLpCBRadcDl
         z41rfwAEmwKfXiAc0qGj2aniTurttwTIxFGb1ylkO/AxLc4YruVNHelbN+1EgtU83Ny0
         oIMpFgK5H2Sm3cZTjN8o3+VYB1XSpKLoWAqUJ6tgS76YlPJMaodOSzEr+JuvxfIH/R3h
         z+2A==
X-Gm-Message-State: AOAM533ZKc5oMBSr1dxOCTZeu5tiCTLh263T6I2mxWQqle1m0nQUEXnS
        WqUnKwftXKW1vG2foa2v0PM=
X-Google-Smtp-Source: ABdhPJx6Wr3B2LqLRClznBSd3nkMKdbCSRAhNj7R6tiizr91vPvj8zFYb0RNKVzekeZX4eUbyOP4hA==
X-Received: by 2002:a17:906:7c43:: with SMTP id g3mr3527382ejp.210.1612972038251;
        Wed, 10 Feb 2021 07:47:18 -0800 (PST)
Received: from [192.168.43.143] (212-39-89-103.ip.btc-net.bg. [212.39.89.103])
        by smtp.gmail.com with ESMTPSA id g23sm1547847ejd.27.2021.02.10.07.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 07:47:17 -0800 (PST)
Subject: Re: Kernelshark v2 all-black plots area
To:     Dario Faggioli <dfaggioli@suse.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <89dbef38a1050c31390ce263d51fff1f72a42164.camel@suse.com>
 <ce06b82f-6335-4653-0d27-e48a37ffb5aa@gmail.com>
 <e07be2e367576882d0cf84c33834ecafaba38136.camel@suse.com>
 <38b5ea14-cea2-1268-13ef-539fe421e442@gmail.com>
 <c047a5892fccdd5cd9550cba81fd16c71950fd8e.camel@suse.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <60fd40d8-23ab-6518-4e8b-6d66bbd53f5a@gmail.com>
Date:   Wed, 10 Feb 2021 17:47:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c047a5892fccdd5cd9550cba81fd16c71950fd8e.camel@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Dario,

On 10.02.21 г. 16:51 ч., Dario Faggioli wrote:
> And this is how the GUI looks:
> 
> http://xenbits.xen.org/people/dariof/ks2-debug/kernelshark-v2-host.png
> 
> Then, I append the trace-(null).dat file (the guest trace). I do see
> this on the terminal:

I see what you mean. In this case the host and the guest are not 
synchronized at all. I guess something went wrong during the recording. 
Also the fact that the name of the guest VM is "(null)" looks very 
suspicious. I guess this is not the real name of the VM you are using?

Steven, do you have any idea what can cause such problem?

Thanks!
Yordan
