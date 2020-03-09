Return-Path: <SRS0=4xj7=42=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3812DC18E7A
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 09:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD432072A
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 09:17:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lUYsFOHN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgCIJRt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Mar 2020 05:17:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38071 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgCIJRt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Mar 2020 05:17:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id t11so10036699wrw.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 09 Mar 2020 02:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eyZXlSbGq8946QdOhm+RPIUSkRt4ColE7EnZsp+qXhY=;
        b=lUYsFOHNdP/2J54YFd2UY6LkV+PDdd0PaZt0ZOAgswLz/9p+3AC2VMb2NhPleQNhP9
         6suW6Qbk8JDD4WosdV2LwD8dZvx5vVUsUTtjzqMYukgz+8/gxtYl63w0P4EjLovXN74j
         Dh5NG85P2HjPGQR8dZXy+/SgPPISZ8Pqp4KHrMce9vo9QvbO7h9At5I68EoTiZRxAUkc
         7Xy5I9rn5sNQuLSCJuoHM6y6DK9rdvlsRAYu9seqhwwChSy7Ek1oCBWhZdZz8I/cmFNN
         aGWJB8JMA4xjnswzvO/Lh8NylPq5bVOa7ev/pSKUOt0UhT1qdfjME9WTCflBvQELfAAR
         cKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eyZXlSbGq8946QdOhm+RPIUSkRt4ColE7EnZsp+qXhY=;
        b=DHchymwuYpRZWi9jPTxe0LCw1Kp+j6kogXHxoepYfplQdqa7rZP2npMktYzYTNnnhL
         3WrGtXOlqTiAeoITjMyyvHi68r0ysLZ9bfGrNZ2zaysaBhl/++udaeIfE339qJ0a6kYv
         iF1VnkN0W0/ABjENh95Ziiy83jUuvkIAvVTDmBo6mnT6j6glxdJx/aBkIwLVqArlvbrs
         Aafd/DtqMR955nkNgmVRhV6MBhhetCMQckYYY0jJDFDksDXTxFrd555uHI2kS4Oyn+k8
         MmaQ2bKMR2YnWEJE8f+Zibg3R37Ujdi42xRni8UCj0lSq+j7SrHTSiZDnx7nR8uv+Wwe
         PnsQ==
X-Gm-Message-State: ANhLgQ28Hbc96IKBIVMFz0aWBGIZPUaV5IN1aDWgzbgVcrzq9bv+S7IA
        WInKjOHoMr/mcBOQVsSbKdqVeQMy
X-Google-Smtp-Source: ADFU+vtVDVgUeNgnAGPsKytrM2q+6B/kUoNECRnscROoYFQRWsRobqLXj1MjFv5XnRKT2XwsswSJsQ==
X-Received: by 2002:adf:a3c9:: with SMTP id m9mr18091199wrb.349.1583745467020;
        Mon, 09 Mar 2020 02:17:47 -0700 (PDT)
Received: from [10.23.10.233] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d63sm24806478wmd.44.2020.03.09.02.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 02:17:46 -0700 (PDT)
Subject: Re: [PATCH 0/2] KernelShark2.0: Use libtracefs APIs to access tracefs
To:     Steven Rostedt <rostedt@goodmis.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20200306092902.48786-1-tz.stoyanov@gmail.com>
 <20200306151356.4bbeef14@gandalf.local.home>
 <20200306173411.783cccd0@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <4aab233c-6f5b-59a7-564b-e520ed1f569f@gmail.com>
Date:   Mon, 9 Mar 2020 11:17:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200306173411.783cccd0@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 7.03.20 г. 0:34 ч., Steven Rostedt wrote:
> On Fri, 6 Mar 2020 15:13:56 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Fri,  6 Mar 2020 11:29:00 +0200
>> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>>
>>> From: "Tzvetomir (VMware)  Stoyanov" <tz.stoyanov@gmail.com>
>>>
>>> The tracefs library provides APIs for accessing files from tracefs.
>>> The library is part of trace-cmd, it is installed as part of trace-cmd
>>> installation. KernelShark uses some of those APIs and must be linked with
>>> the library
>>>
>>> Tzvetomir (VMware)  Stoyanov (2):
>>>    KernelShark2.0: Link KernelShark to libtracefs
>>>    KernelShark2.0: Use libtracefs APIs to access tracefs
>>>    
>>
>> I added these patches to the latest kernelshark-2.0 and it still doesn't
>> work for me. I did a little debugging, and noticed that it fails while
>> reading the guest trace.dat file with:
>>
>> plugin "kvm_combo" failed to initialize on stream /tmp/trace-host-Fedora21.
>>
>> It seems to require that the guest trace.dat file has kvm events?
>>
>> Note, as I build my guest kernel with a make localmodconfig, which disables
>> all modules that are not necessary to boot the box, there is no kvm events
>> there. I can see why the host may need them, but not the guest. I'll
>> rebuild my guest kernel with kvm events and see if that solves this (but
>> that shouldn't be the case).
>>
> 
> Just confirmed it. If I add kvm events to the guest, it synchronizes
> automatically. Thus, it's a bug to expect the guest to have kvm events, as
> there's no reason for them to do so.

Is it possible that something else gets enabled during the recording of 
the data, that actually makes the difference?
Y.

> 
> -- Steve
> 
