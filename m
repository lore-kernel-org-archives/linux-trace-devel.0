Return-Path: <SRS0=4xj7=42=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854A5C18E5A
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 09:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B2C720674
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 09:10:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DNuLHYVL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgCIJKf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Mar 2020 05:10:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51382 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgCIJKe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Mar 2020 05:10:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id a132so8905533wme.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 09 Mar 2020 02:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4/ontmAOxHzQV2Wy5xpZ5mMsL9iPcWrr6VXaDZdF2JI=;
        b=DNuLHYVLQYw//PeOuZHi9WSvjfzzrLvYx0TSstA3Mw4YtItQ1WcJUQwHuEi8wLw+r4
         NqZdwlwrwUE8gCP/Q6t/DuUMvtrIkqYRnRdgzohZvj21YrJhHTcBEEXSOTaT0qrhHsLC
         v57m5xSfSagz88/SIiH1Td1fD1vFkVRwz/8PdiV866Pq4bVl+UnDTs300DRJsHcv02mP
         F9zVsPmXstit2KrQbGTYbUBUlxP/uLR7HGy0ZeWL3c0/ZDir9C442j5nlx7TC2sN40f9
         +e+u4K/1pdbKZch4+g2jKi1r4IpalDBRK+pEYpMVgOjHEF6pyqvg3+lKF3LNCmzpQkyX
         mUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4/ontmAOxHzQV2Wy5xpZ5mMsL9iPcWrr6VXaDZdF2JI=;
        b=OzpYAD7I43xkGalUCf0+/GtT/aB945HOhiL4EqXXs9G+bmkF+i5s1H7a2Jt9u5rGDO
         PYwdc3Oijvt4wKbEc6g5KkdwZ4ZMGpi0XeMaUg4B517PCzO/EhXHmU7eDs80EItMvc4M
         jd8IGjqyoEe1cSfrmOHKv4yyhVpyPUADchORzw25q9JizM7Glise90GcO6gUxioTUT1U
         M/ItYBFktjGdAMHReJDsWBfNYUd4138Lng1kx8eWojFy4GDjGhI4dHPhQh1Ehs4riXJI
         r+ARoXaK74jhL8z2DLK2ZmwsZPQ7hpcs4HxtG0wuKMQJkPJH2PSAO5n1xvCgNyuk5Q7v
         +1lg==
X-Gm-Message-State: ANhLgQ19SMk1Jtw4cUyjxwV+n0I/Xj7FdifN2Z/f5S8axOtzVad1kGNu
        lNbuIYuQKjI+I0Zs+O0lzjMixc0H
X-Google-Smtp-Source: ADFU+vssUTWQbkvjjwqJ29n1NPlnfaoTeENth7RcgaRlro8PH71dZgZPCAds8WmBB+ywalwhw5Xt1w==
X-Received: by 2002:a1c:7419:: with SMTP id p25mr20248833wmc.159.1583745032982;
        Mon, 09 Mar 2020 02:10:32 -0700 (PDT)
Received: from [10.23.10.233] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a1sm837215wro.72.2020.03.09.02.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 02:10:32 -0700 (PDT)
Subject: Re: [PATCH 0/2] KernelShark2.0: Use libtracefs APIs to access tracefs
To:     Steven Rostedt <rostedt@goodmis.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20200306092902.48786-1-tz.stoyanov@gmail.com>
 <20200306151356.4bbeef14@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <c74dff80-254e-4bea-d044-1c6b5b5d87bb@gmail.com>
Date:   Mon, 9 Mar 2020 11:10:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200306151356.4bbeef14@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 6.03.20 г. 22:13 ч., Steven Rostedt wrote:
> On Fri,  6 Mar 2020 11:29:00 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> 
>> From: "Tzvetomir (VMware)  Stoyanov" <tz.stoyanov@gmail.com>
>>
>> The tracefs library provides APIs for accessing files from tracefs.
>> The library is part of trace-cmd, it is installed as part of trace-cmd
>> installation. KernelShark uses some of those APIs and must be linked with
>> the library
>>
>> Tzvetomir (VMware)  Stoyanov (2):
>>    KernelShark2.0: Link KernelShark to libtracefs
>>    KernelShark2.0: Use libtracefs APIs to access tracefs
>>
> 
> I added these patches to the latest kernelshark-2.0 and it still doesn't
> work for me. I did a little debugging, and noticed that it fails while
> reading the guest trace.dat file with:
> 
> plugin "kvm_combo" failed to initialize on stream /tmp/trace-host-Fedora21.
> 
> It seems to require that the guest trace.dat file has kvm events?

Hi Steven,

Yes it will fail to initialize in the guest's file if it does not 
contain kvm events and this is normal. The plugin only draws the 
additional graphical elements associated with kvm_entry and kvm_exit 
events. So nothing will be plotted on top of the guest data.

The plugin itself has nothing to do with the synchronization of the 
timestamps.

Thanks!
Yordan

> 
> Note, as I build my guest kernel with a make localmodconfig, which disables
> all modules that are not necessary to boot the box, there is no kvm events
> there. I can see why the host may need them, but not the guest. I'll
> rebuild my guest kernel with kvm events and see if that solves this (but
> that shouldn't be the case).
> 
> -- Steve
> 
