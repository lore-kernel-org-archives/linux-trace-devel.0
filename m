Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A05C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 11:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE266145A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 11:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhENLvR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 07:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbhENLvP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 07:51:15 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF904C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 04:50:03 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id k10so13039295ejj.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 04:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a10mdgHK1+dKfd644sZtjIq/lFP0MX6DeJY2oqfCItA=;
        b=IVQ67W9QCTPpNlwon7lFN9Vc3pNeCn/BEV4U0y6G1Vwsux/MMr6tjrMelHg0eQ9Cwu
         SDsOknuSjK8xRiHu5sRbBjAfOJwaVwnU//GSW5g3yW1WvNGab74DlaRXP8L73MallVY8
         yNtUxOZ3jnnxQsnObo8VmsY/b6BSFRcTbPZeknZh8cmL32iGnld/hyGAqKzPwyEz1TEi
         qLgZNcuxCSVph8KOU16EhPy8MYYT2GV4IBBFRAL6uy0tXW4rnWWE3xWQwl1JFEjpBMeR
         SSE9N0j+2KwbHPt0mYNcXD3LlWXplaM3XwlvRnWkTC9OM313eH1HozvHMGm4RddEdB2/
         PcMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a10mdgHK1+dKfd644sZtjIq/lFP0MX6DeJY2oqfCItA=;
        b=QcW5wAVzpEfcg0D73Ww7qCFYdCx/qVjjViIAYGgK8RQUZTs0ZTPJG3Eqx3YfZCVdmg
         iM+up3jp+y+2ycY8Q8Kp+T3B80+NL78sjJiJZYVVxKwT5/oYOAJzEexmKc0fPxzDJWHd
         W4oaCzG92hfVJ51A8S8sRVMOMXnjk2pImoIlj6tfZGRzqP4fzg1d1otubLT0fefWFKMp
         XjISbHVa2gvLnmPUBDK1CrnyXlkCgpxxAKSFRCCoNb1VEsU1EW4+AaeTJhLczVVVslnu
         Q1Yj0W+jR8mIwi/rX1iggGXHAXo6MUxG2jL8giZ+TEhKj1HtgrE9a5r19EwblQS19jo6
         dNXA==
X-Gm-Message-State: AOAM5322mVcIJ9Vx6FFeyqZqDPgrcT2vAuk7OLvIwALl4DijsDmJwAdK
        n5P4rqf9caXb4XI0KP5x+TOp+Wa0LV0=
X-Google-Smtp-Source: ABdhPJxufRSYxCi0oBsrFc7XPnDK2VI2XlUQDyGjnjni9vRw+NargxnNY8PNNh+t3sdJ7T9+w+OCIg==
X-Received: by 2002:a17:906:8285:: with SMTP id h5mr47675363ejx.456.1620993002277;
        Fri, 14 May 2021 04:50:02 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id ne17sm3373432ejc.56.2021.05.14.04.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 04:50:01 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark: Add check for return of
 ksmodel_get_cpu_front()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20210507093848.72bf0bed@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <8931c804-4879-ca29-10d2-b3173a2cc658@gmail.com>
Date:   Fri, 14 May 2021 14:50:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210507093848.72bf0bed@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 7.05.21 г. 16:38, Steven Rostedt wrote:
> From: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> When I loaded two trace.dat files (host and guest), but the mapping of
> which host thread is associated to which guest vCPU was missing from the
> file, it caused a SEGFAULT. That's because in fillTaskGraph(), the
> lamGetPidCPU() calls ksmodule_get_cpu_front() which returns a negative
> number and does not set index. But the next line checks data[index] where
> index is some random number, and the application crashes.
> 
> By checking the return of ksmodule_get_cpu_front(), and if it is negative
> do not reference data[index] and just let eFront be nullptr, the
> application shows no mapping, but at least it does not crash.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>


I am applying this one.

Thanks Steven!
Y.

> ---
> You can reproduce this with:
> 
>     http://rostedt.org/private/trace-no-map.tar.bz2
> 
> diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
> index 225dc34..abef5f8 100644
> --- a/src/KsPlotTools.cpp
> +++ b/src/KsPlotTools.cpp
> @@ -1280,7 +1280,7 @@ void Graph::fillTaskGraph(int sd, int pid)
>   						 false,
>   						 _collectionPtr,
>   						 &index);
> -		if (index >= 0)
> +		if (cpuFront >= 0 && index >= 0)
>   			eFront = _histoPtr->data[index];
>   
>   		cpuBack = ksmodel_get_cpu_back(_histoPtr, bin,
> 
